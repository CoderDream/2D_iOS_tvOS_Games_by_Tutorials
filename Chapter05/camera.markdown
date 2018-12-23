# Chapter 5: Camera
```metadata
author: "By Ray Wenderlich"
number: "5"
title: "Chapter 5: Camera"
section: 1
```

So far, Zombie Conga's background is stationary. In contrast, many games have large scrolling worlds, like the original *Super Mario Bros.*: 

![width=100%](images/001_Mario1.png)
 
The red box shows what you can see on the screen, but the level continues beyond to the right. As the player moves Mario to the right, you can think of the background as moving to the left:
 
![width=100%](images/002_Mario2.png)

$[===]

There are two ways to accomplish this kind of scrolling in Sprite Kit:

1. **Move the background**. Make the player, enemies and power-ups children of the “background layer.” Then, to scroll the game, you can simply move the background layer from right to left, and its children will move with it.

2. **Move the camera**. New in iOS 9, Sprite Kit includes `SKCameraNode`, which makes creating scrolling games even easier. You simply add a camera node to the scene, and the camera node's position represents the center of the current view.

In this chapter, you're going to use `SKCameraNode` to scroll the game, since this is the easiest method and likely what developers will use the most, now that it's available. It's time to get scrolling!

> **Note**: This chapter begins where the previous chapter’s Challenge 1 left off. If you were unable to complete the challenges or skipped ahead from an earlier chapter, don’t worry—simply open the starter project from this chapter to pick up where the previous chapter left off.

## Lights, camera, action!

Working with `SKCameraNode` is a cinch. You simply:

1. Create an `SKCameraNode`;
2. Add it to the scene and set the scene's `camera` property to the camera node;
3. Set the camera node's position, which will represent the center of the screen.

Give this a try. Open **GameScene.swift** and add the following new property for the camera node:

```
let cameraNode = SKCameraNode()
```

This completes step 1. Next, add these lines to the end of `didMoveToView()`:

```
addChild(cameraNode)
camera = cameraNode
cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
```

This completes steps 2 and 3, centering the view in the middle of the scene. 

Build and run on your **iPad Air 2** simulator (I'll explain why the iPad Air and not the iPhone later), and you'll see the following:

![ipad-landscape bordered](images/003_Camera.png)

The game works as before, except now you're using a camera node. To see the benefit of this, make the camera follow the zombie by adding this line of code to the end of `update()`:

```
cameraNode.position = zombie.position
```

Build and run on your **iPad Air 2** simulator, and you'll see that the camera now follows the zombie:

![ipad-landscape bordered](images/004_CameraFollow.png)

That was easy! But right now, the background is only sized to match the visible area. You don't want your zombie walking through the void, so comment out that line for now.

```
// cameraNode.position = zombie.position
```

Now try running this on your **iPhone 6** simulator. At the time of writing, there appears to be a bug that makes the background a little off-center:

![iphone-landscape bordered](images/005_NotCentered.png)

Luckily, there's a workaround. Add these methods to the bottom of `GameScene`:

```
func overlapAmount() -> CGFloat {
  guard let view = self.view else {
    return 0
  }
  let scale = view.bounds.size.width / self.size.width
  let scaledHeight = self.size.height * scale
  let scaledOverlap = scaledHeight - view.bounds.size.height
  return scaledOverlap / scale
}

func getCameraPosition() -> CGPoint {
  return CGPoint(x: cameraNode.position.x, y: cameraNode.position.y + overlapAmount()/2)
}

func setCameraPosition(position: CGPoint) {
  cameraNode.position = CGPoint(x: position.x, y: position.y - overlapAmount()/2)
}
```

Don't worry too much about how these work; just remember that you should use `getCameraPosition()` and `setCameraPosition()` instead of getting or setting the camera's position directly.

Try this out in `didMoveToView()` by replacing the line that sets the camera's position with the following:

```
setCameraPosition(CGPoint(x: size.width/2, y: size.height/2))
```

$[=p=]

Build and run on your **iPhone 6** simulator, and you'll see the scene is now centered correctly!

![iphone-landscape bordered](images/006_Centered.png)

## A scrolling background

As you may remember from Chapter 2, you're using a background named **background1** that's the same size as the scene itself. Your project contains a second background named **background2** that’s designed to be placed to the right of background1, like so:

![width=100%](images/007_DualBackgrounds.png)
 
Your first task is simple: combine these two background images into a single node so you can easily scroll them both at the same time.

Add this new method to `GameScene`:

```
func backgroundNode() -> SKSpriteNode {
  // 1
  let backgroundNode = SKSpriteNode()
  backgroundNode.anchorPoint = CGPoint.zero
  backgroundNode.name = "background"

  // 2
  let background1 = SKSpriteNode(imageNamed: "background1")
  background1.anchorPoint = CGPoint.zero
  background1.position = CGPoint(x: 0, y: 0)
  backgroundNode.addChild(background1)
  // 3
  let background2 = SKSpriteNode(imageNamed: "background2")
  background2.anchorPoint = CGPoint.zero
  background2.position =
    CGPoint(x: background1.size.width, y: 0)
  backgroundNode.addChild(background2)
  // 4
  backgroundNode.size = CGSize(
    width: background1.size.width + background2.size.width,
    height: background1.size.height)
  return backgroundNode
}
```

Let’s go over this section by section:

1. You create a new `SKNode` to contain both background sprites as children. In this case, instead of using `SKNode` directly, you use an `SKSpriteNode` with no texture. This is so you can conveniently set the size property on the `SKSpriteNode` to the combined size of the background images.

2. You create an `SKSpriteNode` for the first background image and pin the bottom-left of the sprite to the bottom-left of `backgroundNode`.

3. You create an `SKSpriteNode` for the second background image and pin the bottom-left of the sprite to the bottom-right of `background1` inside `backgroundNode`.

4. You set the size of the `backgroundNode` based on the size of the two background images. 

Next, replace the code that creates the background sprite in `didMoveToView()` with the following:

```
let background = backgroundNode()
background.anchorPoint = CGPoint.zero
background.position = CGPoint.zero
background.name = "background"
addChild(background)
```

This simply creates the background using your new helper method rather than basing it on a single background image. 

Also note that before, you had the background centered onscreen. Here, you pin the lower-left corner to the lower-left of the scene, instead.

Changing the anchor point to the lower-left like this will make it easier to calculate positions when the time comes. You also name the background, “background”, so you can readily find it.

Your goal is to make this camera scroll from left to right. To do this, add a property for the camera's scrolling speed:

```
let cameraMovePointsPerSec: CGFloat = 200.0
```

Next, add this helper method to move the camera:

```
func moveCamera() {
  let backgroundVelocity = 
    CGPoint(x: cameraMovePointsPerSec, y: 0)
  let amountToMove = backgroundVelocity * CGFloat(dt)
  cameraNode.position += amountToMove
}
```

This calculates the amount the camera should move this frame, and updates the camera's position accordingly.

Finally, call this new method inside `update()`, right after the call to `moveTrain()`:

```
moveCamera()
```

Build and run, and now you have a scrolling background:

![iphone-landscape bordered](images/008_MovingCamera.png)

But as the screen scrolls, the zombie disappears offscreen, the cats stop spawning—and eventually, you see the void:

![iphone-landscape bordered](images/009_Void.png)

Don't worry. It's not the end of the world yet; it's only a minor zombie apocalypse! Nonetheless, it's time to fix these problems—starting by endlessly scrolling the background.

## An endlessly scrolling background

The most efficient way to continuously scroll your background is to make two background nodes instead of one and lay them side by side:

![width=100%](images/010_TwoPanels.png)
 
Then, as you scroll both images from right to left, as soon as one of the images goes offscreen, you simply reposition it to the right:
 
![width=100%](images/011_Reposition.png)

To do this, replace the code that creates the background node in `didMoveToView():` with the following:

```
for i in 0...1 {
  let background = backgroundNode()
  background.anchorPoint = CGPointZero
  background.position = 
    CGPoint(x: CGFloat(i)*background.size.width, y: 0)
  background.name = "background"
  addChild(background)
}
```

Also, if you still have the lines that get and log the background’s size, comment them out.

The above wraps the code in a `for`-loop that creates two copies of the background and then sets their positions, so the second copy begins after the first ends.

$[===]

Next, add this new method:

```
var cameraRect : CGRect {
  return CGRect(
    x: getCameraPosition().x - size.width/2 
      + (size.width - playableRect.width)/2, 
    y: getCameraPosition().y - size.height/2 
      + (size.height - playableRect.height)/2, 
    width: playableRect.width, 
    height: playableRect.height)
}
```

This is a helper method that calculates the current "visible playable area". You'll be using this for calculations throughout the rest of the chapter.

Next, add the following code to the bottom of `moveCamera()`:

```
enumerateChildNodesWithName("background") { node, _ in
  let background = node as! SKSpriteNode
  if background.position.x + background.size.width < self.cameraRect.origin.x {
    background.position = CGPoint(
      x: background.position.x + background.size.width*2,
      y: background.position.y)
  }
}
```

You check to see if the right-hand side of the background is less than the left hand side of the current visible playable area—in other words, if it's offscreen. Remember, you set the anchor point of the background to the bottom-left.

If part of the background is offscreen, you simply move the background node to the right by double the width of the background. Since there are two background nodes, this places the first node immediately to the right of the second.

Build and run, and now you have an continuously scrolling background! You saved the world from ending—even if it still has zombies.
 
![iphone-landscape bordered](images/012_EndlessLoop.png)

## Fixing the gameplay

You've fixed the background, but the gameplay is still wonky. Nothing appears to stay on the screen!

![width=100%](images/013_WhatHappen.png)

Start by reining in the zombie. In **GameScene.swift**, review `boundsCheckZombie()` and see if you can spot the problem:

```
let bottomLeft = CGPoint(x: 0,
  y: CGRectGetMinY(playableRect))
let topRight = CGPoint(x: size.width,
  y: CGRectGetMaxY(playableRect))
```

This code assumes that the visible portion of the scene never changes from its original position. To correct that assumption, change the lines above so they look like this:

```
let bottomLeft = CGPoint(x: CGRectGetMinX(cameraRect),
  y: CGRectGetMinY(cameraRect))
let topRight = CGPoint(x: CGRectGetMaxX(cameraRect),
  y: CGRectGetMaxY(cameraRect))
```

Here you grab the coordinates from the visible playable area, rather than hardcoding a fixed position.

The cats have a similar problem. Inside `spawnCat()`, change the lines that set the cat's position to the following:

```
cat.position = CGPoint(
  x: CGFloat.random(min: CGRectGetMinX(cameraRect),
    max: CGRectGetMaxX(cameraRect)),
  y: CGFloat.random(min: CGRectGetMinY(cameraRect),
    max: CGRectGetMaxY(cameraRect)))
cat.zPosition = 50
```

This updates the cat so it spawns within the visible playable area rather than at a hardcoded position. You also update the cat's `zPosition` to make sure it stays on top of the background, but below the zombie.

There's one last thing: Since the background is continuously scrolling, your gameplay will be a lot more dynamic if you disable the code that stops the zombie once he reaches the target point - this way the zombie will always keep running. Remember, this was the zombie's original behavior before your second challenge in Chapter 2. 

To let your zombie loose, comment out the relevant code in `update()`, as shown below:

```
/*
if let lastTouchLocation = lastTouchLocation {
  let diff = lastTouchLocation - zombie.position
  if (diff.length() <= zombieMovePointsPerSec * CGFloat(dt)) {
    zombie.position = lastTouchLocation
    velocity = CGPointZero
    stopZombieAnimation()
  } else {
  */
    moveSprite(zombie, velocity: velocity)
    rotateSprite(zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
  /*}
}*/
```

Build and run, and now most of the gameplay works smoothly:

![iphone-landscape bordered](images/014_ScrollingGame.png)

w00t, you're almost done—the only thing left to fix are the enemies! And that challenge is left to you. :] 


## Challenges

There's only one challenge this time: fixing the gameplay for the enemies. 

As always, if you get stuck, you can find the solutions in the resources for this chapter—but give it your best shot first!

## Challenge 1: Fixing the enemies

After awhile, the crazy cat ladies stop spawning and in some cases appear behind the background.

Look at `spawnEnemy()` and you'll see this is because you're still selecting the spawn point assuming the camera never moves, rather than using the currently visible playable area.

Your challenge is to modify this method to instead spawn enemies right outside of the currently visible playable area. Also, be sure to set the enemies' `zPosition` to match that of the cat so they don't appear below the background. 

After you do this, you'll notice that as the level goes on, the enemies spawn faster and faster. Find out why this is and fix it. 

> **Hint**: It has something to do with `actionMove`—is there an alternative action type you can use instead?

If you got this working, congratulations - you now have a complete scrolling game! There's just one bit of polish to wrap things up before we move on to another game: adding some labels to the game.


