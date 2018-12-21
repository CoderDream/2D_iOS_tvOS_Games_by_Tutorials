# Chapter 2: Manual Movement
```metadata
author: "By Ray Wenderlich"
number: "2"
title: "Chapter 2: Manual Movement"
section: 1
```

If you completed the challenges from the previous chapter, you now have a rather large zombie on the screen:

![bordered width=50% print](/images/001_BigZombie.png)
![bordered width=60% screen](/images/001_BigZombie.png)
 
> **Note**: If you were unable to complete the challenges or skipped ahead from the previous chapter, don’t worry—simply open the starter project from this chapter to pick up where the previous chapter left off.

Of course, you want the sprite to move around, not just stand there—this zombie’s got an itch to boogie!

There are two ways to make a sprite move in Sprite Kit:

1. As you might have noticed in the previous chapter—if you looked at the template code provided by Apple—you can make a sprite move using a concept called **actions**. You’ll learn more about actions in the next chapter.

2. You can make a sprite move in the more “classic” way—and that’s to set the position manually over time. It’s important to learn this way first, because it affords the most control and will help you understand what actions do for you.

However, to set a sprite’s position over time, you need a method that the game calls periodically as it runs. This introduces a new topic: the Sprite Kit game loop.

## The Sprite Kit game loop

A game works like a flipbook animation. You draw a successive sequence of images, and when you flip through them fast enough, it gives the illusion of movement.

![width=50%](/images/002_Flipbook.png)
 
Each individual picture that you draw is called a **frame**. Games typically try to draw frames between 30 to 60 times per second so that the animations feel smooth. This rate of drawing is called the **frame rate**, or specifically **frames per second (FPS)**. By default, Sprite Kit displays this in the bottom-right corner of your game:

![iphone-landscape bordered](/images/003_BigZombieFPS.png)
 
> **Note**: It’s handy of Sprite Kit to show your frames per second onscreen by default, because you want to keep an eye on the FPS as you develop your game to make sure your game is performing well. Ideally, you want at least 30 FPS.
>
> You should only pay attention to the FPS display on an actual device, though, as you’ll get very different performance on the simulator. 
>
> In particular, your Mac has a faster CPU and way more memory than an iPhone or iPad, but abysmally slow emulated rendering, so you can’t count on any accurate performance measurements from your Mac—again, always test performance on a device!
>
> Besides the FPS, Sprite Kit also displays the count of nodes that it rendered in the last pass.
>
> You can remove the FPS and node count from the screen by going into **GameViewController.swift** and setting both `skView.showsFPS` and `skView.showsNodeCount` to `false`. 

Behind the scenes, Sprite Kit runs an endless loop, often referred to as the **game loop**, which looks like this:

![width=50%](/images/004_GameLoop.png)
 
This illustrates that each frame, Sprite Kit does the following:

1. **Calls a method on your scene called `update()`**. This is where you can put code that you want to run every frame—making it the perfect spot for code that updates the position or rotation of your sprites.
2. **Does some other stuff**. You’ll revisit the game loop in other chapters, filling in your understanding of the rest of this diagram as you go.
3. **Renders the scene**. Sprite Kit then draws all of the objects that are in your scene graph, issuing OpenGL draw commands for you behind the scenes.

Sprite Kit tries to draw frames as fast as possible, up to 60 FPS. However, if `update()` takes too long, or if Sprite Kit has to draw more sprites than the hardware can handle at one time, the frame rate might decrease. 

Here are two tips to keep your game running fast:

1. **Keep `update()` fast**. For example, you want to avoid slow algorithms in this method since it’s called each frame.
2. **Keep your node count as low as possible**. For example, it’s good to remove nodes from the scene graph when they’re offscreen and you no longer need them.

Now you know that `update()` is called each frame and is a good spot to update the positions of your sprites—so let’s make this zombie move!

## Moving the zombie

You’re going to implement the zombie movement code in five iterations. This is so you can see some common beginner mistakes and solutions, and in the end, understand how movement works step by step.

To start, you’ll implement a simple but not ideal method: moving the zombie a fixed amount per frame.

Before you begin, open **GameScene.swift** and comment out the line in `didMoveToView()` that sets the zombie to double its size:

```swift
// zombie.setScale(2) // SKNode method
```

This line was just a test, so you don’t need it anymore. Zombies scare me enough in normal size! :]

### Iteration 1: Fixed movement per frame

Inside **GameScene.swift**, add the following method:

```
override func update(currentTime: NSTimeInterval) {
  zombie.position = CGPoint(x: zombie.position.x + 8, 
                            y: zombie.position.y)
}
```

Here, you update the position of the zombie to be eight more points along the x-axis than last time, and keep the same position along the y-axis. This makes the zombie move from left to right.

Build and run, and you’ll see the zombie move across the screen:

![width=50%](/images/005_MovingZombie.png)
 
This is great stuff, but the movement feels a bit jagged or irregular. To see why, let’s go back to the Sprite Kit game loop.

Remember, Sprite Kit tries to draw frames as quickly as possible. However, there will usually be some variance in the amount of time it takes to draw each frame: sometimes a bit slower, sometimes a bit quicker.

This means the amount of time between calls to your `update()` loop can vary. To see this yourself, add some code to print out the time elapsed since the last update. Add these variables to `GameScene`’s property section, right after the `zombie` property:

```
var lastUpdateTime: NSTimeInterval = 0
var dt: NSTimeInterval = 0
```

Here, you create properties to keep track of the last time Sprite Kit called `update()`, and the delta time since the last update, often abbreviated as `dt`.

Then, add these lines to the beginning of `update()`:

```
if lastUpdateTime > 0 {
  dt = currentTime - lastUpdateTime
} else {
  dt = 0
}
lastUpdateTime = currentTime
print("\(dt*1000) milliseconds since last update")
```

Here, you calculate the time since the last call to `update()` and store that in `dt`, then log out the time in milliseconds (1 second = 1000 milliseconds). 

Build and run, and you’ll see something like this in the console:

```
33.4451289963908 milliseconds since last update
16.3537669868674 milliseconds since last update
34.1878019971773 milliseconds since last update
15.6998310121708 milliseconds since last update
33.9883069973439 milliseconds since last update
33.5779220040422 milliseconds since last update
```

As you can see, the amount of time between calls to `update()` always varies slightly. 

> **Note**: Sprite Kit tries to call your update method 60 times a second (every ~16 milliseconds). However, if it takes too long to update and render a frame of your game, Sprite Kit may call your update method less frequently, and the FPS will drop. You can see that here—some frames are taking over 30 milliseconds. 
>
> You're seeing such a low FPS because you're running on the simulator. As mentioned earlier, you can’t count on the simulator for accurate performance measurements. If you try running this code on a device, you should see a much higher FPS.
>
> Note that even if your game runs at a smooth 60 FPS, there will always be some small variance in how often Sprite Kit calls your update method. Therefore, you need to take the delta time into account in your calculations—and you'll learn how to do that next!

Since you’re updating the position of the zombie a fixed amount per frame rather than taking this time variance into consideration, you’re likely to wind up with movement that looks jagged or irregular.

![width=100%](/images/006_JaggedMovement.png)
 
The correct solution is to figure out how far you want the zombie to move per second and then multiply this by the fraction of a second since the last update. Let’s give it a shot.

### Iteration 2: Velocity multiplied by delta time

Begin by adding this property to the top of `GameScene`, right after `dt`: 

```
let zombieMovePointsPerSec: CGFloat = 480.0
```

You’re saying that in one second, the zombie should move 480 points, about 1/4 of the scene width. You set the type to `CGFloat`, because you’ll be using this value in calculations with other `CGFloat`s inside a `CGPoint`.

Right after that line, add one more property:

```
var velocity = CGPoint.zero
```

So far, you’ve used `CGPoint`s to represent positions. However, it’s also quite common and handy to use `CGPoint`s to represent **2D vectors**. 

$[=p=]

A 2D vector represents a **direction** and a **length**:

![width=50%](/images/007_Vector.png)

The diagram above shows an example of a 2D vector you might use to represent the zombie’s movement. You can see that the orientation of the arrow shows the **direction** in which the zombie should move, while the arrow’s **length** indicates how far the zombie should move in a second. The direction and length together represent the zombie’s **velocity**–you can think of it as how far and in what direction the zombie should move in 1 second.

However, note that the velocity has no set position. After all, you should be able to make the zombie move in that direction, at that speed, no matter where the zombie starts.

Try this out by adding the following new method:

```
func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
  // 1
  let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), 
                             y: velocity.y * CGFloat(dt))
  print("Amount to move: \(amountToMove)")
  // 2
  sprite.position = CGPoint(
    x: sprite.position.x + amountToMove.x, 
    y: sprite.position.y + amountToMove.y)
}
```

You’ve refactored the code into a reusable method that takes the sprite to be moved and a velocity vector by which to move it. Let’s go over this line by line:

1. Velocity is in points per second, and you need to figure out how many points to move the zombie this frame. To determine that, this section multiplies the points per second by the fraction of seconds since the last update. You now have a point representing the zombie’s position—which you can also think of as a vector from the origin to the zombie’s position—as well as a vector representing the distance and direction to move the zombie this frame:

![width=70%](/images/008_Zombie1.png)
 
2. To determine the zombie’s new position, simply add the vector to the point:

![width=70%](/images/009_Zombie2.png)
 
You can visualize this with the diagram above, but in code you simply add the `x`- and `y`-components of the point and the vector together.

> **Note**: To learn more about vectors, check out this great guide: [http://www.mathsisfun.com/algebra/](http://www.mathsisfun.com/algebra/vectors.html). 

Finally, inside `update()`, replace the line that sets the zombie’s position with the following:

```
moveSprite(zombie, 
  velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
```

Build and run, and now the zombie moves much more smoothly across the screen. Look at the console log, and you’ll also see that the zombie is now moving a different number of points each frame, based on how much time has elapsed.

```
0.0 milliseconds since last update
Amount to move: (0.0,0.0)
47.8530780237634 milliseconds since last update
Amount to move: (11.4847387257032,0.0)
33.3498929976486 milliseconds since last update
Amount to move: (8.00397431943566,0.0)
34.2196339915972 milliseconds since last update
Amount to move: (8.21271215798333,0.0)
```

If your zombie’s movement still looks jittery, be sure to try it on a device instead of on the simulator, which has different performance characteristics. 

### Iteration 3: Moving toward touches

So far, so good, but now you want to make the zombie move toward whatever spot the player touches. After all, everyone knows zombies are attracted to noise!

Your goal is for the zombie to move toward the point the player taps and keep moving even after passing the tap location, until the player taps another location to draw his attention. There are four steps to make this work—let’s cover them one at a time.

#### Step 1: Find the offset vector

First, you need to figure out the offset between the location of the player’s tap and the location of the zombie. You can get this by simply subtracting the zombie’s position from the tap position.

Subtracting points and vectors is similar to adding them, but instead of adding the `x`- and `y`- components, you—that’s right—subtract them! :]

![width=70%](/images/010_Subtract1.png)
 
This diagram illustrates that if you subtract the zombie position from the tap position, you get a vector showing the offset amount. You can see this even more clearly if you move the offset vector so it begins from the zombie’s position:

![width=70%](/images/011_Subtract2.png)
 
By subtracting these two positions, you get something with a direction and a length. Call this the offset vector.

Try it out by adding the following method:

```
func moveZombieToward(location: CGPoint) {
  let offset = CGPoint(x: location.x - zombie.position.x, 
                       y: location.y - zombie.position.y)
}
```

You’re not done writing this method; this is only the beginning!

### Step 2: Find the length of the offset vector

Now you need to figure out the length of the offset vector, a piece of information you’ll need in Step 3. 

Think of the offset vector as the hypotenuse of a right triangle, where the lengths of the other two sides of the triangle are defined by the `x`- and `y`- components of the vector:

![width=90%](/images/012_Length1.png)
 
You want to find the length of the hypotenuse. To do this, you can use the Pythagorean theorem. You may remember this simple formula from geometry—it says that the length of the hypotenuse is equal to the square root of the sum of the squares of the two sides.

![width=90%](/images/013_Length2.png)
 
Put this theory into practice. Add the following line to the bottom of `moveZombieToward()`:

```
let length = sqrt(
  Double(offset.x * offset.x + offset.y * offset.y))
```

You’re not done yet!

### Step 3: Make the offset vector a set length

Currently, you have an offset vector where:

* The **direction** points toward where the zombie should go.
* The **length** is the length of the line between the zombie’s current position and the tap location.

What you want is a velocity vector where:

* The **direction** points toward where the zombie should go.
* The **length** is `zombieMovePointsPerSec`, the constant you defined earlier as 480 points per second.

So you’re halfway there—your vector points in the right direction, but isn’t the right length. How do you make a vector pointing in the same direction as the offset vector, but of a certain length?

The first step is to convert the offset vector into a **unit vector**, which means a vector of length 1. According to geometry, you can do this by simply dividing the offset vector’s `x`- and `y`- components by the offset vector’s length.

![width=100%](/images/014_UnitVector.png)
 
This process of converting a vector into a unit vector is called **normalizing** a vector.

Once you have this unit vector, which you know is of length 1, it’s easy to multiply it by `zombieMovePointsPerSec` to make it the exact length you want.

![width=100%](/images/015_UnitVector2.png)
 
Give it a try. Add the following lines to the bottom of `moveZombieToward()`:

```
let direction = CGPoint(x: offset.x / CGFloat(length), 
                        y: offset.y / CGFloat(length))
velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, 
                   y: direction.y * zombieMovePointsPerSec)
```

Now you’ve got a velocity vector with the correct direction and length. There’s only one step left!

### Step 4: Hook up to touch events

In Sprite Kit, to get notifications of touch events on a node, you simply need to set that node’s `userInteractionEnabled` property to `true` and then override that node’s `touchesBegan(withEvent:)`, `touchesMoved(withEvent:)` and/or `touchesEnded(withEvent:)` methods. Unlike other `SKNode` subclasses, `SKScene`’s `userInteractionEnabled` property is set to `true` by default.

$[=p=]

To see this in action, implement these touch handling methods for `GameScene`, as follows:

```
func sceneTouched(touchLocation:CGPoint) {
  moveZombieToward(touchLocation)
}

override func touchesBegan(touches: Set<UITouch>,
  withEvent event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let touchLocation = touch.locationInNode(self)
    sceneTouched(touchLocation)
}

override func touchesMoved(touches: Set<UITouch>,
  withEvent event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let touchLocation = touch.locationInNode(self)
    sceneTouched(touchLocation)
}
```

Finally, inside `update()`, edit the call to `moveSprite()` so it passes in velocity (based on the touch) instead of the preset amount: 

```
moveSprite(zombie, velocity: velocity)
```

That’s it! Build and run, and now the zombie will chase your taps. Just don’t get too close—he’s hungry!

![iphone-landscape bordered](/images/016_MovingZombie.png)
 
> **Note**: You can also use gesture recognizers with Sprite Kit. These can be especially handy if you’re trying to implement complicated gestures, such as pinching or rotating.
>
> You can add the gesture recognizer to the scene's view in `didMoveToView()`, and you can use `SKScene`’s `convertPointFromView()` and `SKNode`’s `convertPoint(toNode:)` methods to get the touch in the coordinate space you need.
>
> For a demonstration of this, see the sample code for this chapter, where I’ve included a commented-out demonstration of gesture recognizers for you. Since it does the same thing as the touch handlers you implemented, comment out your touch handlers when you run with the gesture recognizers if you want to be sure the gestures are working. 

### Iteration 4: Bounds checking

As you play the latest version of the game, you might notice that the zombie happily runs straight off the screen if you let him. While I admire his enthusiasm, in Zombie Conga you’d like him to stay on the screen at all times, bouncing off an edge if he hits one.

To do this, you need to check if the newly calculated position is beyond any of the screen edges and make the zombie bounce away, if so. Add this new method:

```
func boundsCheckZombie() {
  let bottomLeft = CGPointZero
  let topRight = CGPoint(x: size.width, y: size.height)
  
  if zombie.position.x <= bottomLeft.x {
    zombie.position.x = bottomLeft.x
    velocity.x = -velocity.x
  }
  if zombie.position.x >= topRight.x {
    zombie.position.x = topRight.x
    velocity.x = -velocity.x
  }
  if zombie.position.y <= bottomLeft.y {
    zombie.position.y = bottomLeft.y
    velocity.y = -velocity.y
  }
  if zombie.position.y >= topRight.y {
    zombie.position.y = topRight.y
    velocity.y = -velocity.y
  } 
}
```

First, you make constants for the bottom-left and top-right coordinates of the scene.

Then, you check the zombie’s position to see if it’s beyond or on any of the screen edges. If it is, you clamp the position and reverse the appropriate velocity component to make the zombie bounce in the opposite direction.

Now call your new method at the end of `update()`:

```
boundsCheckZombie()
```

Build and run, and you have a zombie bouncing around the screen. I told you he was ready to party!

![iphone-landscape bordered](/images/017_BouncingZombie.png)
 
### Iteration 5: Playable area

Run the game on your iPhone 6 simulator and move your zombie toward the top of the screen. Notice that your zombie moves offscreen before he bounces back!

![iphone-landscape bordered](/images/018_WheresMyZombie.png)
 
Run the game on the iPad simulator, and you’ll see the game works as expected. Does this give you a clue as to what’s going on?

Recall from the "Universal app support" section in Chapter 1 that Zombie Conga has been designed with a 4:3 aspect ratio (2048x1536). However, you want to support up to a 16:9 aspect ratio, which is what the iPhone 5, 6, and 6 Plus use (1136x640, 1334x750, and 1920x1080, respectively).

Let’s take a look at what happens with a 16:9 device. Since you’ve configured the scene to use aspect fill, Sprite Kit first calculates the largest 16:9 rectangle that fits within the 2048x1536 space: that's 2048x1152. It then centers that rectangle and scales it to fit the actual screen size; for example, the iPhone 6's 1334x750 screen requires scaling by ~0.65.

![width=68% print](/images/019_PlayableArea.png)
![width=80% screen](/images/019_PlayableArea.png)
 
This means that on 16:9 devices, there are 192-point gaps at the top and bottom of the scene that won’t be visible (1536 - 1152 = 384. 384 / 2 = 192). Hence, you should avoid critical gameplay in those areas—such as letting the zombie move in those gaps.

Let’s solve this problem. First, add a new property to `GameScene` to store the playable rectangle:

```
let playableRect: CGRect
```

Then, add this initializer to set the value appropriately:

```
override init(size: CGSize) {
  let maxAspectRatio:CGFloat = 16.0/9.0 // 1
  let playableHeight = size.width / maxAspectRatio // 2
  let playableMargin = (size.height-playableHeight)/2.0 // 3
  playableRect = CGRect(x: 0, y: playableMargin, 
                        width: size.width,
                        height: playableHeight) // 4
  super.init(size: size) // 5
}

required init(coder aDecoder: NSCoder) {
  fatalError("init(coder:) has not been implemented") // 6
}
```

Line by line, here’s what this code does:

1. Zombie Conga supports aspect ratios from 3:2 (1.33) to 16:9 (1.77). Here you make a constant for the max aspect ratio supported: 16:9 (1.77).
2. With aspect fit, regardless of aspect ratio, the playable width will always be equal to the scene width. To calculate the playable height, you divide the scene width by the max aspect ratio.
3. You want to center the playable rectangle on the screen, so you determine the margin on the top and bottom by subtracting the playable height from the scene height and dividing the result by 2.
4. You put it all together to make a centered rectangle on the screen, with the max aspect ratio.
5. You call the initializer of the superclass.
6. Whenever you override the default initializer of a Sprite Kit node, you must also override the required `NSCoder` initializer, which is used when you're loading a scene from the scene editor. Since you're not using the scene editor in this game, you simply add a placeholder implementation that logs an error.

To visualize this, add a helper method to draw this playable rectangle to the screen:

```
func debugDrawPlayableArea() {
  let shape = SKShapeNode()
  let path = CGPathCreateMutable()
  CGPathAddRect(path, nil, playableRect)
  shape.path = path
  shape.strokeColor = SKColor.redColor()
  shape.lineWidth = 4.0
  addChild(shape)
}
```

For the moment, don’t worry about how this works; you’ll learn all about `SKShapeNodes` in Chapter 11, “Crop, Video and Shape Nodes”. For now, consider this a black box that draws the debug rectangle to the screen.

Next, call this method at the end of `didMoveToView()`:

```
debugDrawPlayableArea()
```

And finally, modify the first two lines in `boundsCheckZombie()` to take into consideration the `y`-values in `playableRect`:

$[=s=]

```
let bottomLeft = CGPoint(x: 0, 
                       y: CGRectGetMinY(playableRect))
let topRight = CGPoint(x: size.width, 
                       y: CGRectGetMaxY(playableRect))
```

Build and run, and you’ll see the zombie now bounces correctly, according to the playable rectangle, drawn in red and matched to the corners of the screen:

![iphone-landscape bordered](/images/020_PlayableArea2.png)
 
Then build and run on an iPad simulator, and you’ll see the zombie bounces correctly there, as well, according to the playable rectangle: 

![ipad-landscape bordered](/images/021_PlayableArea3.png)
 
The playable area outlined in red is exactly what you see on the iPhone device, which has the largest supported aspect ratio, 16:9.

Now that you have a playable rectangle, you simply need to make sure the rest of the gameplay takes place in this box—and your zombie can party everywhere!

> **Note**: An alternate method would be to restrict the zombie’s movement based on the visible area of the current device. In other words, you could let the zombie move all the way to the edges of the iPad, rather than restricting him to the minimum playable area. 
>
> However, this would make the game easier on the iPad, as there’d be more space to avoid enemies. For Zombie Conga, we think it’s more important to have the same difficulty across all devices, so we’re keeping the core gameplay in the guaranteed playable area.

## Rotating the zombie

The zombie is moving nicely, but he always faces the same direction. Granted, he's undead, but this zombie is on the curious side and would like to turn to see where he’s going!

You already have a vector that includes the direction the zombie is facing: velocity. You just need to find the rotation angle to get the zombie facing in that direction.

Once again, think of the direction vector as the hypotenuse of a right triangle. You want to find the angle:

![width=95%](/images/022_FindAngle.png)
 
You may remember from trigonometry the mnemonic _SOH CAH TOA_, where the last part stands for:

```
tan(angle) = opposite / adjacent
```

Since you have the lengths of the opposite and adjacent sides, you can rewrite the above formula as follows to get the angle of rotation:

```
angle = arctan(opposite / adjacent)
```

If none of this trigonometry rings any bells, don’t worry. Just think of it as a formula that you type in to get the angle—that’s all you need to know.

$[=p=]

Give this formula a try by adding the following new method:

```
func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
  sprite.zRotation = CGFloat(
    atan2(Double(direction.y), Double(direction.x)))
} 
```

This uses the equation from above. It includes a bunch of casting because `CGFloat` is defined as a `Double` on 64-bit machines and as a `Float` on 32-bit machines.

This works because the zombie image faces to the right. If the zombie image were instead facing the top of the screen, you’d have to add an additional rotation to compensate, because an angle of 0 points to the right.

Now call this new method at the end of `update`:

```
rotateSprite(zombie, direction: velocity)
```

Build and run, and the zombie rotates to face the direction in which he’s moving:

![iphone-landscape bordered](/images/023_RotateZombie.png)
 
Congratulations, you’ve given your zombie life! The sprite moves smoothly, bounces off the edges of the screen and rotates on both the iPhone and the iPad—a great start to a game.

But you’re not done yet. It’s time for you to try some of this stuff on your own to make sure you’ve got it down.

## Challenges

This chapter has three challenges, and they’re particularly important ones. Performing these challenges will give you useful practice with vector math and introduce new math utilities you’ll use throughout the rest of the book.

As always, if you get stuck, you can find solutions in the resources for this chapter—but give it your best shot first!

## Challenge 1: Math utilities

As you’ve no doubt noticed while working on this game, you frequently have to perform calculations on points and vectors: adding and subtracting points, finding lengths and so on. You’ve also been doing a lot of casting between `CGFloat` and `Double`.

So far in this chapter, you’ve done all of this yourself inline. That’s a fine way of doing things, but it can get tedious and repetitive in practice. It’s also error-prone.

Create a new file with the **iOS\Source\Swift File** template and name it **MyUtils**. Then replace the contents of **MyUtils.swift** with the following:

```
import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
  left = left + right
}
```

In Swift, you can make operators like `+`, `-`, `*` and `/` work on any type you want. Here, you make them work on `CGPoint`.

Now you can add points like the ones below—but don’t add this anywhere; it's just an example:

```
let testPoint1 = CGPoint(x: 100, y: 100)
let testPoint2 = CGPoint(x: 50, y: 50)
let testPoint3 = testPoint1 + testPoint2
```

Let’s override operators for subtraction, multiplication and division on `CGPoints` as well. Add this code to the end of **MyUtils.swift**:

```
func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (inout left: CGPoint, right: CGPoint) {
  left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (inout left: CGPoint, right: CGPoint) {
  left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (inout point: CGPoint, scalar: CGFloat) {
  point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (inout left: CGPoint, right: CGPoint) {
  left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (inout point: CGPoint, scalar: CGFloat) {
  point = point / scalar
}
```

Now you can subtract, multiply or divide a `CGPoint` by another `CGPoint`. You can also multiply and divide points by scalar `CGFloat` values, as below—again, don’t add this anywhere; it's just an example:

```
let testPoint5 = testPoint1 * 2
let testPoint6 = testPoint1 / 10
```

Finally, add a class extension on `CGPoint` with a few helper methods:

```
#if !(arch(x86_64) || arch(arm64))
func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
  return CGFloat(atan2f(Float(y), Float(x)))
}

func sqrt(a: CGFloat) -> CGFloat {
  return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
  
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
  
  var angle: CGFloat {
    return atan2(y, x)
  }
}
```

The `#if`/`#endif` block is `true` when the app is running on 32-bit architecture. In this case, `CGFloat` is the same size as `Float`, so this code makes versions of `atan2` and `sqrt` that accept `CGFloat`/`Float` values rather than the default of `Double`, allowing you to use `atan2` and `sqrt` with `CGFloats`, regardless of the device’s architecture.

Next, the class extension adds some handy methods to get the length of the point, return a normalized version of the point (i.e., length 1) and get the angle of the point. 

Using these helper functions will make your code a lot more concise and clean. For example, look at `moveSprite(velocity:)`:

```
func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
  let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), 
                             y: velocity.y * CGFloat(dt))
  print("Amount to move: \(amountToMove)")
  sprite.position = CGPoint(
    x: sprite.position.x + amountToMove.x, 
    y: sprite.position.y + amountToMove.y)
}
```

Simplify the first line by multiplying `velocity` and `dt` using the `*` operator, and avoid the cast. Also, simplify the final line by adding the sprite’s position and amount to move using the `+=` operator. 

Your end result should look like this:

```
func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
  let amountToMove = velocity * CGFloat(dt)
  print("Amount to move: \(amountToMove)")
  sprite.position += amountToMove
}
```

Your challenge is to modify the rest of Zombie Conga to use this new helper code, and verify that the game still works as expected. When you’re done, you should have the following calls, including the two mentioned already:

* `+=` operator: 1 call
* `-` operator: 1 call
* `*` operator: 2 calls
* `normalized`: 1 call
* `angle`: 1 call

You'll also notice when you’re done that your code is a lot cleaner and easier to understand. In future chapters, you’ll use a math library we made that’s very similar to the one you created here.

## Challenge 2: Stop that zombie!

In Zombie Conga, when you tap the screen, the zombie moves toward the tap point—but then continues beyond it.

That’s the behavior you want for Zombie Conga, but in another game, you might want the zombie to stop where you tap. Your challenge is to modify the game to do this.

Here are a few hints for one possible implementation:

* Create an optional property called `lastTouchLocation` and update it whenever the player touches the scene.
* Inside `update()`, check the distance between the last touch location and the zombie’s position. If that remaining distance is less than or equal to the amount the zombie will move this frame (`zombieMovePointsPerSec` * `dt`), then set the zombie’s position to the last touch location and the velocity to zero. Otherwise, call `moveSprite(velocity:)` and `rotateSprite(direction:)` like normal. `boundsCheckZombie()` should always occur.
* To do this, use the `-` operator once and call `length()` once using the helper code from the previous challenge.

### Challenge 3: Smooth moves

Currently, the zombie immediately rotates to face the tap location. This can be a bit jarring—it would be nicer if the zombie rotated smoothly over time to face the new direction.

To do this, you need two new helper routines. Add these to the bottom of **MyUtils.swift** (to type `π`, use Option-p):

```
let π = CGFloat(M_PI)

func shortestAngleBetween(angle1: CGFloat, 
                          angle2: CGFloat) -> CGFloat {
  let twoπ = π * 2.0
  var angle = (angle2 - angle1) % twoπ
  if (angle >= π) {
    angle = angle - twoπ
  }
  if (angle <= -π) {
    angle = angle + twoπ
  }
  return angle
}

extension CGFloat {
  func sign() -> CGFloat {
    return (self >= 0.0) ? 1.0 : -1.0
  }
}
```

`sign()` returns 1 if the `CGFloat` is greater than or equal to 0; otherwise it returns -1.

`shortestAngleBetween()` returns the shortest angle between two angles. It’s not as simple as subtracting the two angles, for two reasons:

1. Angles “wrap around” after 360 degrees (2 * `M_PI`). In other words, 30 degrees and 390 degrees represent the same angle.

![width=70% print](/images/024_Shortest1.png)
![width=85% screen](/images/024_Shortest1.png)
 
2. Sometimes the shortest way to rotate between two angles is to go left, and other times to go right. For example, if you start at 0 degrees and want to turn to 270 degrees, it’s shorter to turn -90 degrees than to turn 270 degrees. You don’t want your zombie turning the long way around—he may be undead, but he’s not stupid!

![width=70% print](/images/025_Shortest2.png)
![width=85% screen](/images/025_Shortest2.png)
 
So this routine finds the difference between the two angles, chops off any amount greater than 360 degrees and then decides if it’s faster to go right or left.

Your challenge is to modify `rotateSprite(direction:)` to take and use a new parameter: the number of radians the zombie should rotate per second.  

Define the constant as follows:

```
let zombieRotateRadiansPerSec:CGFloat = 4.0 * π
```

And modify the method signature as follows:

```
func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, 
                  rotateRadiansPerSec: CGFloat) {
  // Your code here!
}
```

Here are a few hints for implementing this method:

* Use `shortestAngleBetween()` to find the distance between the current angle and the target angle. Call this `shortest`.
* Figure out the amount to rotate this frame based on `rotateRadiansPerSec` and `dt`. Call this `amtToRotate`.
* If the absolute value of `shortest` is less than the `amtToRotate`, use that instead.
* Add `amountToRotate` to the sprite’s `zRotation`—but multiply it by `sign()` first, so that you rotate in the correct direction.
* Don’t forget to update the call to rotate the sprite in `update()` so that it uses the new parameter.

If you’ve completed all three of these challenges, great work! You really understand moving and rotating sprites, using the “classic” approach of updating the values yourself over time.

Ah, but the classic, while essential to understand, always gives way to the modern. In the next chapter, you’ll learn how Sprite Kit can make some of these common tasks much easier, through the magic of actions!


