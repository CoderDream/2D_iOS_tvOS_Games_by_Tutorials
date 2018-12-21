# Chapter 3: Actions
```metadata
author: "By Ray Wenderlich"
number: "3"
title: "Chapter 3: Actions"
section: 1
```

So far, you’ve learned how to move and rotate Sprite Kit nodes—a node being anything that appears onscreen—by manually setting their positions and rotations over time. 

This do-it-yourself approach works and is quite powerful, but Sprite Kit provides an easier way to move sprites incrementally: **actions**.

Actions allow you to do things like rotate, scale or change a sprite’s position over time—with only one line of code! You can also chain actions together to create movement combinations quite easily.

In this chapter, you’ll learn all about Sprite Kit actions as you add enemies, collectibles and basic gameplay logic to your game.

You’ll see how actions can simplify your game-coding life, and by the time you’ve finished this chapter, Zombie Conga will be action-packed!

> **Note**: This chapter begins where the previous chapter’s Challenge 3 left off. If you were unable to complete the challenges or skipped ahead from an earlier chapter, don’t worry—simply open the starter project from this chapter to pick up where the previous chapter left off.

## Move action

Right now, your zombie’s “life” is a bit too carefree. Let’s add action to this game by introducing enemies to dodge: crazy cat ladies!

![width=70% print](images/000_CrazyCatLady.png)
![width=80% screen](images/000_CrazyCatLady.png)

Open **GameScene.swift** and create the start of a new method to spawn an enemy:

```
func spawnEnemy() {
  let enemy = SKSpriteNode(imageNamed: "enemy")
  enemy.position = CGPoint(x: size.width + enemy.size.width/2, 
                           y: size.height/2)
  addChild(enemy)
}
```

This code is a review from the previous two chapters: You create a sprite and position it at the vertical center of the screen, just out of view to the right.

Now you’d like to move the enemy from the right of the screen to the left. If you were to do this manually, you might update the enemy’s position each frame according to a velocity.

No need to trouble yourself with that this time! Simply add these two lines of code to the bottom of `spawnEnemy()`:

```
let actionMove = SKAction.moveTo(
  CGPoint(x: -enemy.size.width/2, y: enemy.position.y),
  duration: 2.0)
enemy.runAction(actionMove)
```

To create an action in Sprite Kit, you call one of several static constructors on the `SKAction` class, such as the one you see here, `moveTo(duration:)`. This particular constructor returns an action that moves a sprite to a specified position over a specified duration (in seconds).

Here, you set up the action to move the enemy along the x-axis at whatever speed is necessary to take it from its current position to just off the left side of the screen in two seconds.

Once you’ve created an action, you need to run it. You can run an action on any `SKNode` by calling `runAction()`, as you did in the above code.

Give it a try! For now, call this method inside `didMoveToView()`, right after calling `addChild(zombie)`:

```
spawnEnemy()
```

Build and run, and you'll see the crazy cat lady race across the screen:

![iphone-landscape bordered](images/001_CatLady1.png)
 
Not bad for only two lines of code, eh? You could have even done it with a single line of code if you didn’t need to use the `actionMove` constant for anything else.

Here you saw an example of `moveTo(duration:)`, but there are a few other move action variants:

* **moveToX(duration:)** and **moveToY(duration:)**. These allow you to specify a change in only the `x`- or `y`-position; the other is assumed to remain the same. You could have used `moveToX(duration:)` in the example above to save a bit of typing. 
* **moveByX(y:duration:)**. The “move to” actions move the sprite to a particular point, but sometimes it’s convenient to move a sprite as an offset from its current position, wherever that may be. You could’ve used `moveByX(y:duration:)` in the example above, passing `-(size.width + enemy.size.width)` for `x` and 0 for `y`. 

![width=100%](images/002_MoveToVsMoveBy.png)
 
You’ll see this pattern of “[action] to” and “[action] by” variants for other action types, as well. In general, you can use whichever of these is more convenient for you—but keep in mind that if either works, the “[action] by” actions are preferable because they're reversible. For more on this topic, keep reading.

## Sequence action

The real power of actions lies in how easily you can chain them together. For example, say you want the cat lady to move in a V—down toward the bottom of the screen, then up to the goal position.

To do this, replace the lines that create and run the move action in `spawnEnemy()` with the following:

```
// 1
let actionMidMove = SKAction.moveTo(
  CGPoint(x: size.width/2, 
          y: CGRectGetMinY(playableRect) + enemy.size.height/2), 
  duration: 1.0)
// 2
let actionMove = SKAction.moveTo(
  CGPoint(x: -enemy.size.width/2, y: enemy.position.y), 
  duration:1.0)
// 3
let sequence = SKAction.sequence([actionMidMove, actionMove])
// 4
enemy.runAction(sequence)
```

Let’s go over this line by line:

1. Here you create a new move action, just like you did before, except this time it represents the “mid-point” of the action—the bottom middle of the playable rectangle.
2. This is the same move action as before, except you’ve decreased the duration to 1.0, since it will now represent moving only half the distance: from the bottom of the V, offscreen to the left.
3. Here’s the new sequence action! As you can see, it’s incredibly simple—you use the `sequence:` constructor and pass in an `Array` of actions. The sequence action will run one action after another.
4. You call `runAction()` in the same way as before, but pass in the sequence action this time.

That’s it! Build and run, and you’ll see the crazy cat lady “bounce” off the bottom of the playable rectangle:

![bordered width=50% print](images/003_CatLady2.png)
![iphone-landscape bordered screen](images/003_CatLady2.png)
 
The sequence action is one of the most useful and commonly used actions—chaining actions together is just so powerful! You’ll use the sequence action many times in this chapter and throughout the rest of this book.

## Wait-for-duration action

The wait-for-duration action does exactly what you’d expect: It makes the sprite wait for a period of time, during which the sprite does nothing.

“What’s the point of that?” you may be wondering. Well, wait-for-duration actions only truly become interesting when combined with a sequence action.

For example, let’s make the cat lady briefly pause when she reaches the bottom of the V-shape. To do this, replace the line in `spawnEnemy()` that creates a sequence with the following lines:

```
let wait = SKAction.waitForDuration(0.25)
let sequence = SKAction.sequence(
  [actionMidMove, wait, actionMove])
```

To create a wait-for-duration action, call `waitForDuration()` with the amount of time to wait in seconds. Then, simply insert it into the sequence of actions where you want the delay to occur. 

Build and run, and now the cat lady will briefly pause at the bottom of the V:

![width=50% print](images/004_CatLady3.png)
![iphone-landscape bordered screen](images/004_CatLady3.png)
 
## Run-block action

At times, you’ll want to run your own block of code in a sequence of actions. For example, let's say you want to log a message when the cat lady reaches the bottom of the V.

To do this, replace the line in `spawnEnemy()` that creates a sequence with the following lines:

```
let logMessage = SKAction.runBlock() {
  print("Reached bottom!")
}
let sequence = SKAction.sequence(
  [actionMidMove, logMessage, wait, actionMove])
```

To create a run-block action, simply call `runBlock()` and pass in a block of code to execute.

Build and run, and when the cat lady reaches the bottom of the V, you'll see the following in the console:

```objc
Reached bottom!
```

> **Note**: If your project still includes the `print` statements from earlier chapters, now would be a great time to remove them. Otherwise, you’ll have to search your console for the above log statement—it’s doubtful you’ll notice it within the sea of messages scrolling by.
>
> While you’re at it, you should remove any comments as well, to keep your project nice and clean.

Of course, you can do far more than log a message here—since it’s an arbitrary code block, you can do anything you want!

You should be aware of one more action related to running blocks of code:

* **runBlock(queue:)** allows you to run the block of code on an arbitrary dispatch queue instead of in the main Sprite Kit event loop.

$[=p=]

## Reversing actions

Let’s say you want to make the cat lady go back the way she came: After she moves in a V to the left, she should move in a V back to the right.

One way to do this would be, after she goes offscreen to the left, to have her run the existing `actionMidMove` action to go back to the middle, and creating a new `moveTo(duration:)` action to send her back to the start position.

But Sprite Kit gives you a better option. You can reverse certain actions in Sprite Kit simply by calling `reversedAction()` on them, resulting in a new action that is the opposite of the original action.

For example, if you run a `moveByX(y:duration:)` action, you can run the reverse of that action to go back the other way:

![width=100%](images/005_Reversed.png)
 
Not all actions are reversible—for example, `moveTo(duration:)` is not. To find out if an action is reversible, look it up in the `SKAction` class reference, which indicates it plainly.

![bordered width=85% print](images/006_Docs.png)
![bordered width=95% screen](images/006_Docs.png)
 
Let’s try this out. First, replace the declarations of `actionMidMove` and `actionMove` in `spawnEnemy()` with the following code:

```
let actionMidMove = SKAction.moveByX(
  -size.width/2-enemy.size.width/2, 
  y: -CGRectGetHeight(playableRect)/2 + enemy.size.height/2, 
  duration: 1.0)
let actionMove = SKAction.moveByX(
  -size.width/2-enemy.size.width/2, 
  y: CGRectGetHeight(playableRect)/2 - enemy.size.height/2, 
  duration: 1.0)
```

Here, you switch the `moveTo(duration:)` actions to the related `moveByX(y:duration:)` variant, since that is reversible. 

$[=s=]

Now replace the line in `spawnEnemy()` that creates `sequence` with the following lines:

```
let reverseMid = actionMidMove.reversedAction()
let reverseMove = actionMove.reversedAction()
let sequence = SKAction.sequence([
  actionMidMove, logMessage, wait, actionMove,
  reverseMove, logMessage, wait, reverseMid
])
```

First, you switch the `moveTo(duration:)` actions to the related `moveByX(y:duration:)` variant, since that is reversible.

Then, you create the reverse of those actions by calling `reversedAction()` on each, and insert them into the sequence.

Build and run, and now the cat lady will go one way, then back the other way:

![iphone-landscape bordered](images/007_CatLady4.png)
 
> **Note**: If you try to reverse an action that isn't reversible, then `reversedAction()` will return the same action. 

Because sequence actions are also reversible, you can simplify the above code as follows. **Remove** the lines where you create the reversed actions and replace the sequence creation with the following lines:

```
let halfSequence = SKAction.sequence(
  [actionMidMove, logMessage, wait, actionMove])
let sequence = SKAction.sequence(
  [halfSequence, halfSequence.reversedAction()])
```

This simply creates a sequence of actions that moves the sprite one way, and then reverses the sequence to go back the other way.

Astute observers may have noticed that the first half of the sequence logs a message as soon as the sprite reaches the bottom of the screen, but on the way back, the message isn’t logged until after the sprite has waited at the bottom for one second. 

This is because the reversed sequence is the exact opposite of the original, unlike your first implementation of the reversal. Later in this chapter, you’ll read about the group action, which you could use to fix this behavior.

$[=p=]

## Repeating actions

So far, so good, but what if you want the cat lady to repeat this sequence multiple times? Of course, there’s an action for that!

You can repeat an action a certain number of times using `repeatAction(count:)`, or an endless number of times using `repeatActionForever()`.

Let’s go with the endless variant. Replace the line that runs your action in `spawnEnemy()` with the following two lines:

```
let repeatAction = SKAction.repeatActionForever(sequence)
enemy.runAction(repeatAction)
```

Here, you create an action that repeats the sequence of other actions endlessly, and run that repeat action on the enemy.

Build and run, and now your cat lady will continuously bounce back and forth. I told you she’s crazy!

![iphone-landscape bordered](images/008_CatLady5.png)
 
Congratulations! You now understand many useful types of actions:

* Move actions
* Sequence actions
* Wait-for-duration actions
* Run-block actions
* Reversing actions
* Repeating actions

Next, you’re going to put all of these together in a new and interesting way to make cat ladies spawn periodically, so your zombie can never get too comfortable.

## Periodic spawning

Right now, the game spawns a single cat lady at launch. To prepare for periodic spawning, you’ll revert the `spawnEnemy()` code to the original version that simply moves the cat lady from right to left. You’ll also introduce random variance so the cat lady doesn’t always spawn at the same y-position.

First things first: You need a helper method to generate a random number within a range of values. Add this new method to **MyUtils.swift**, alongside the other math utilities you added in the challenges section of the previous chapter:

```
extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UInt32.max))
  }

  static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }
}
```

This extends `CGFloat` to add two new methods: The first gives a random number between 0 and 1, and the second gives a random number between specified minimum and maximum values.

It’s not important for you to understand these methods beyond that. But if you’re really curious, you can read the following note:

> **Note:** `random()` calls `arc4random()`, which gives you a random integer between 0 and the largest value possible to store with an unsigned 32-bit integer, represented by `UInt32.max`. If you divide that number by `UInt32.max`, you get a float between 0 and 1. 
>
> Here’s how `random(min:max:)` works. If you multiply the result of `random()`—remember, that's a float between 0 and 1—by the range of values (`max` - `min`), you’ll get a float between 0 and the range. If you add to that the `min` value, you’ll get a float between `min` and `max`. 
>
> This is a very simple way of generating a random number. If you need more advanced control, check out Chapter 20, "Randomization".

Voilà, job done!

Next, head back to **GameScene.swift** and replace the current version of `spawnEnemy()` with the following:

```
func spawnEnemy() {
  let enemy = SKSpriteNode(imageNamed: "enemy")
  enemy.position = CGPoint(
    x: size.width + enemy.size.width/2, 
    y: CGFloat.random(
      min: CGRectGetMinY(playableRect) + enemy.size.height/2, 
      max: CGRectGetMaxY(playableRect) - enemy.size.height/2))
  addChild(enemy)
  
  let actionMove = 
    SKAction.moveToX(-enemy.size.width/2, duration: 2.0)
  enemy.runAction(actionMove)
}
```

You’ve modified the fixed `y`-position to be a random value between the bottom and top of the playable rectangle, and you’ve reverted the movement back to the original implementation—well, the `moveToX(duration:)` variant of the original implementation, anyway.

Now it’s time for some action. Inside `didMoveToView()`, replace the call to `spawnEnemy()` with the following:

```
runAction(SKAction.repeatActionForever(
  SKAction.sequence([SKAction.runBlock(spawnEnemy),
                     SKAction.waitForDuration(2.0)])))
```

This is an example of chaining actions together inline instead of creating separate variables for each. You create a sequence of calling `spawnEnemy()` and waiting two seconds, and repeat this sequence forever.

Note that you’re running the action on the scene itself. This works because the scene is a node, and any node can run actions.

> **Note:** You can pass `spawnEnemy` directly as an argument to `runBlock()`, because a function with no arguments and no return value has the same type as the argument to `runBlock()`. Handy, eh?

Build and run, and the crazy cat ladies will spawn endlessly, at varying positions:

![iphone-landscape bordered](images/009_CatLady6.png)
 
## Remove-from-parent action

If you keep the game running for a while, there’s a problem.

You can’t see it, but there are a big army of cat ladies offscreen to the left. This is because you never remove the cat ladies from the scene after they've finished moving.

A never-ending list of nodes in a game is not a good thing. This node army will eventually consume all of the memory on the device, and at that point, the OS will automatically terminate your app, which from a user’s perspective will look like your app crashed.

To keep your game running smoothly, a good rule of thumb is “If you don’t need it anymore, remove it.” And as you may have guessed, there’s an action for that, too! When you no longer need a node and want to remove it from the scene, you can either call `removeFromParent()` directly or use the remove-from-parent action.

Give this a try. Replace the call to `runAction()` inside `spawnEnemy()` with the following:

```
let actionRemove = SKAction.removeFromParent()
enemy.runAction(SKAction.sequence([actionMove, actionRemove]))
```

Build and run, and now your nodes will clean up properly. Ah—much better!

$[=p=]

> Note: `removeFromParent()` removes the node that’s running that action from its parent. This raises a question: What happens to actions after you run them? Calling `runAction()` stores a strong reference to the action you give it, so won’t that slowly eat up your memory?
>
> The answer is no. Sprite Kit nodes do you the favor of automatically removing their references to actions when the actions finish running. So you can tell a node to run an action and then forget about it, feeling confident that you haven’t leaked any memory.

## Animation action

This one is super useful, because animations add a lot of polish and fun to your game.

To run an animation action, you first need to gather a list of images called **textures** that make up the frames of the animation. A sprite has a texture assigned to it, but you can always swap out the texture with a different one at runtime by setting the `texture` property on the sprite.

In fact, this is what animations do for you: automatically swap out your sprite’s textures over time, with a slight delay between each.

Zombie Conga already includes some animation frames for the zombie. As you can see below, you have four textures to use as frames to show the zombie walking:

![width=100%](images/010_ZombieFrames.png)
 
You want to play the frames in this order:

![width=100%](images/011_FrameOrder.png)
 
You can then repeat this endlessly for a continuous walk animation.

Give it a shot. First, create a property for the zombie animation action:

```
let zombieAnimation: SKAction
```

$[=p=]

Then, add the following code to `init(size:)`, right before the call to `super.init(size:)`:

```
// 1
var textures:[SKTexture] = []
// 2
for i in 1...4 {
  textures.append(SKTexture(imageNamed: "zombie\(i)"))
}
// 3
textures.append(textures[2])
textures.append(textures[1])

// 4
zombieAnimation = SKAction.animateWithTextures(textures, 
  timePerFrame: 0.1)
```

Let’s go over this one section at a time:

1. You create an array that will store all of the textures to run in the animation.

2. The animation frames are named **zombie1.png**, **zombie2.png**, **zombie3.png** and **zombie4.png**. This makes it easy to fashion a loop that creates a string for each image name and then makes a texture object from each name using the `SKTexture(imageNamed:)` initializer.

The first `for` loop adds frames 1 to 4, which is most of the “forward walk.”

3. This adds frames 3 and 2 to the list—remember, the textures array is 0-based. In total, the textures array now contains the frames in this order: 1, 2, 3, 4, 3, 2. The idea is to loop this for a continuous animation.

4. Once you have the array of textures, running the animation is easy—you simply create and run an action with `animateWithTextures(timePerFrame:)`.

Finally, add this line to `didMoveToView()`, just after calling `addChild(zombie)`:

```
zombie.runAction(SKAction.repeatActionForever(zombieAnimation))
```

This runs the action wrapped in a repeat-forever action, which will seamlessly cycle through the frames 1,2,3,4,3,2,1,2,3,4,3,2,1,2....

Build and run, and now your zombie will strut in style!

![width=50% bordered screen](images/012_ZombieStrut.png)
![iphone-landscape bordered print](images/012_ZombieStrut.png)
 
## Stopping action

Your zombie’s off to a good start, but there’s one annoying thing: When the zombie stops moving, his animation keeps running. Ideally, you’d like to stop the animation when the zombie stops moving.

In Sprite Kit, whenever you run an action, you can give the action a key by using a variant of `runAction()` called `runAction(withKey:)`. This is handy because it allows you to stop the action by calling `removeActionForKey()`.

Give it a shot by adding these two new methods:

```
func startZombieAnimation() {
  if zombie.actionForKey("animation") == nil {
    zombie.runAction(
      SKAction.repeatActionForever(zombieAnimation), 
      withKey: "animation")
  }
}

func stopZombieAnimation() {
  zombie.removeActionForKey("animation")
}
```

The first method starts the zombie animation. It runs the animation as before, but tags it with a key called “animation”.

Also note that the method first uses `actionForKey()` to make sure there isn’t already an action running with the key “animation”; if there is, the method doesn’t bother running another one.

The second method stops the zombie animation by removing the action with the key “animation”. 

Now go to `didMoveToView()` and comment out the line that runs the action there:

```
// zombie.runAction(
//  SKAction.repeatActionForever(zombieAnimation))
```

Call `startZombieAnimation()` at the beginning of `moveZombieToward()`:

```
startZombieAnimation()
```

And call `stopZombieAnimation()` inside `update()`, right after the line of code that sets `velocity = CGPointZero`:

```
stopZombieAnimation()
```

Build and run, and now your zombie will only move when he should!

## Scale action

You have an animated zombie and some crazy cat ladies, but the game is missing one very important element: cats! Remember, the player’s goal is to gather as many cats as she can into the zombie’s conga line.

In Zombie Conga, the cats won’t move from right to left like the cat ladies do—instead, they’ll appear at random locations on the screen and remain stationary. Rather than have the cats appear instantly, which would be jarring, you’ll start them at a scale of 0 and grow them to a scale of 1 over time. This will make the cats appear to “pop in” to the game.

To implement this, add the following new method:

```
func spawnCat() {
  // 1
  let cat = SKSpriteNode(imageNamed: "cat")
  cat.position = CGPoint(
    x: CGFloat.random(min: CGRectGetMinX(playableRect), 
                      max: CGRectGetMaxX(playableRect)), 
    y: CGFloat.random(min: CGRectGetMinY(playableRect), 
                      max: CGRectGetMaxY(playableRect)))
  cat.setScale(0)
  addChild(cat)
  // 2
  let appear = SKAction.scaleTo(1.0, duration: 0.5)
  let wait = SKAction.waitForDuration(10.0)
  let disappear = SKAction.scaleTo(0, duration: 0.5)
  let removeFromParent = SKAction.removeFromParent()
  let actions = [appear, wait, disappear, removeFromParent]
  cat.runAction(SKAction.sequence(actions))
}
```

Let’s go over each section:

1. You create a cat at a random spot inside the playable rectangle. You set the cat’s scale to 0, which makes the cat effectively invisible.

2. You create an action to scale the cat up to normal size by calling `scaleTo(duration:)`. This action isn't reversible, so you also create a similar action to scale the cat back down to 0. In sequence, the cat appears, waits for a bit, disappears and is then removed from the parent.

You want the cats to spawn continuously from the start of the game, so add the following inside `didMoveToView()`, just after the line that spawns the enemies:

```
runAction(SKAction.repeatActionForever(
  SKAction.sequence([SKAction.runBlock(spawnCat),
                     SKAction.waitForDuration(1.0)])))
```

This is very similar to the way you spawned the enemies. You run a sequence that calls `spawnCat()`, waits for one second and then repeats.

Build and run, and you’ll see cats pop in and out of the game:

![iphone-landscape bordered](images/013_Cats.png)
 
You should be aware of a few variants of the scale action:

* **scaleXTo(duration:)**, **scaleYTo(duration:)** and **scaleXTo(y:duration:)**: These allow you to scale the x-axis or the y-axis of a node independently, which you can use to stretch or squash a node.
* **scaleBy(duration:)**: The “by” variant of scaling, which multiples the passed-in scale by the current node’s scale. For example, if the current scale of a node is 1.0 and you scale it by 2.0, it is now at 2x. If you scale it by 2.0 again, it is now at 4x. Note that you couldn't use `scaleBy(duration:)` in the previous example, because anything multiplied by 0 is still 0!
* **scaleXBy(y:duration:)**: Another “by” variant, but this one allows you to scale x and y independently.

## Rotate action

The cats in this game should be appealing enough that the player wants to pick them up, but right now they’re just sitting motionless. 

![width=30%](images/014_Meh.png)
 
Let’s give them some charm by making them wiggle back and forth while they sit.

To do this, you need the rotate action. To use it, you call the `rotateByAngle(duration:)` constructor, passing in the angle (in radians) by which to rotate. 

Replace the declaration of the `wait` action in `spawnCat()` with the following:

```
cat.zRotation = -π / 16.0
let leftWiggle = SKAction.rotateByAngle(π/8.0, duration: 0.5)
let rightWiggle = leftWiggle.reversedAction()
let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
let wiggleWait = SKAction.repeatAction(fullWiggle, count: 10)
```

Then, inside the declaration of the `actions` array, replace the `wait` action with `wiggleWait`, as shown below:

```
let actions = [appear, wiggleWait, disappear, removeFromParent]
```

Rotations go counterclockwise in Sprite Kit, so negative rotations go clockwise. First, you rotate the cat clockwise by 1/16 of `π` (11.25 degrees) by setting its `zRotation` to –`π`/16. The user won’t see this because at this point, the cat’s scale is still 0.

Then you create `leftWiggle`, which rotates counterclockwise by 22.5 degrees over a period of 0.5 seconds. Since the cat starts out rotated clockwise by 11.25 degrees, this results in the cat being rotated counterclockwise by 11.25 degrees.

Because this is a “by” variant, it's reversible, so you use `reversedAction()` to create `rightWiggle`, which simply rotates back the other way to where the cat started.

You create a `fullWiggle` by rotating left and then right. Now the cat has completed its wiggle and is back to its start position. This “full wiggle” takes a total of one second, so in `wiggleWait`, you repeat this 10 times to have a 10-second wiggle duration.

Build and run, and now your cats look like they’ve had some catnip!

![iphone-landscape bordered](images/015_CatWiggle.png)
 
## Group action

So far, you know how to run actions one after another in sequence, but what if you want to run two actions at exactly the same time? For example, in Zombie Conga, you want to make the cats scale up and down slightly as they’re wiggling.

For this sort of multitasking, you can use what’s called the group action. It works in a similar way as the sequence action, where you pass in a list of actions. However, instead of running them one at a time, a group action runs them all at once.

Let’s try this out. Replace the declaration of the `wiggleWait` action in `spawnCat()` with the following:

```
let scaleUp = SKAction.scaleBy(1.2, duration: 0.25)
let scaleDown = scaleUp.reversedAction()
let fullScale = SKAction.sequence(
  [scaleUp, scaleDown, scaleUp, scaleDown])
let group = SKAction.group([fullScale, fullWiggle])
let groupWait = SKAction.repeatAction(group, count: 10)
```

This code creates a sequence similar to that of the wiggle sequence, except it scales up and down instead of wiggling left and right.

The code then sets up a group action to run the wiggling and scaling at the same time. To use a group action, you simply provide it with the list of actions that should run simultaneously.

Now replace `wiggleWait` with `groupWait` inside the declaration of the actions array, as shown below:

```
let actions = [appear, groupWait, disappear, removeFromParent]
```

$[=p=]

Build and run, and your cats will bounce with excitement:

![iphone-landscape bordered](images/016_CatBounce.png)
 
> **Note:** The duration of a group action is equal to the longest duration of any of the actions it contains. So if you include an action that takes one second and another that takes 10 seconds, both actions will begin to run at the same time, and after one second, the first action will be complete. The group action will continue to execute for nine more seconds until the other action is complete.

## Collision detection

You’ve got a zombie, you’ve got cats, you’ve even got crazy cat ladies—but you don’t have a way to detect when they collide.

There are multiple ways to detect collisions in Sprite Kit, including by using the built-in physics engine, as you’ll learn in Chapter 9, “Intermediate Physics”. In this chapter, you’ll take the simplest and easiest approach: bounding-box collision detection.

There are three basic ideas you’ll use to implement this:

1. You need a way of getting all of the cats and cat ladies in a scene into lists, so that you can check for collisions one by one. An easy solution is to give nodes a name when you create them, allowing  you to use `enumerateChildNodesWithName(usingBlock:)` on the scene to find all the nodes with a certain name.

2. Once you have the lists of cats and cat ladies, you can loop through them to check for collisions. Each node has a `frame` property that gives you a rectangle representing the node’s location onscreen.

3. If you have the frame for either a cat or a cat lady, and the frame for the zombie, you can use the built-in method `CGRectIntersectsRect()` to see if they collide.

$[=p=]

Let’s give this a shot. First, set the name for each node. Inside `spawnEnemy()`, right after creating the enemy sprite, add this line:

```
enemy.name = "enemy"
```

Similarly, inside `spawnCat()`, right after creating the cat sprite, add this line:

```
cat.name = "cat"
```

Then add these new methods to the file:

```
func zombieHitCat(cat: SKSpriteNode) {
  cat.removeFromParent()
}

func zombieHitEnemy(enemy: SKSpriteNode) {
  enemy.removeFromParent()
}

func checkCollisions() {
  var hitCats: [SKSpriteNode] = []
  enumerateChildNodesWithName("cat") { node, _ in
    let cat = node as! SKSpriteNode
    if CGRectIntersectsRect(cat.frame, self.zombie.frame) {
      hitCats.append(cat)
    }
  }
  for cat in hitCats {
    zombieHitCat(cat)
  }
 
  var hitEnemies: [SKSpriteNode] = []
  enumerateChildNodesWithName("enemy") { node, _ in
    let enemy = node as! SKSpriteNode
    if CGRectIntersectsRect(
      CGRectInset(node.frame, 20, 20), self.zombie.frame) {
      hitEnemies.append(enemy)
    }
  }
  for enemy in hitEnemies {
    zombieHitEnemy(enemy)
  }
}
```

Here, you enumerate through any child of the scene that has the name “cat” or “enemy” and cast it to an `SKSpriteNode`, since you know it’s a sprite node if it has that name. 

You then check if the frame of the cat or enemy intersects with the frame of the zombie. If there is an intersection, you simply add the cat or enemy to an array to keep track of it. After you finish enumerating the nodes, you loop through the `hitCats` and `hitEnemies` arrays and call a method that removes the cat or enemy from the scene.

Note that you don’t remove the nodes from within the enumeration. It’s unsafe to remove a node while enumerating over a list of them, and doing so can crash your app.

Also, notice that you do a little trick for the cat lady. Remember that the frame of a sprite is the sprite’s entire image, including transparent space:

![width=25%](images/017_TransparentSpace.png)
 
That means if the zombie went into the area of transparent space at the top of the cat lady image, it would “count” as a hit. Totally unfair!

To resolve this, you shrink the bounding box a little by using `CGRectInset()`. It’s not a perfect solution, but it’s a start. You’ll learn a better way to do this in Chapter 10, “Advanced Physics”.

Add the following call to your collision detection method at the end of `update()`:

```
checkCollisions()
```

Build and run, and now when you collide with a cat or enemy, it disappears from the scene. It’s your first small step toward the zombie apocalypse!

![iphone-landscape bordered](images/018_Collisions.png)
 
$[=p=]

## The Sprite Kit game loop, round 2

There's a slight problem with the way you’re detecting collisions, and it’s related to Sprite Kit’s game loop.

Earlier, you learned that during Sprite Kit’s game loop, first `update()` gets called, then some “other stuff” occurs, and finally Sprite Kit renders the screen:

![width=50%](images/019_GameLoop1.png)
 
One of the things in the “other stuff” section is the evaluation of the actions you’ve been learning about in this chapter:
 
![width=50%](images/020_GameLoop2.png)

Herein lies the problem with your current collision detection method. You check for collisions at the end of the `update()` loop, but Sprite Kit doesn’t evaluate the actions until _after_ this `update()` loop. Therefore, your collision detection code is always one frame behind!

As you can see in your new event loop diagram, it would be much better to perform collision detection after Sprite Kit evaluates the actions and all the sprites are in their new spots. So comment out the call at the end of `update()`:

```
// checkCollisions()
```

And implement `didEvaluateActions()` as follows:

```
override func didEvaluateActions()  {
  checkCollisions()
}
```

You probably won’t notice much of a difference in this case, because the frame rate is so fast, it’s hard to tell it was behind. But it could be quite noticeable in other games, so it’s best to do things properly.

## Sound action

The last type of action you’ll learn about in this chapter also happens to be one of the most fun—it’s the action that plays sound effects!

Using the `playSoundFileNamed(waitForCompletion:)` action, it takes just one line of code to play a sound effect with Sprite Kit. The node on which you run this action doesn’t matter, so typically you’ll run it as an action on the scene itself.

First, you need to add sounds to your project. In the resources for this chapter, find the folder named **Sounds** and drag it into your project. Make sure that **Copy items if needed**, **Create Groups** and the **ZombieConga** target are selected, and click **Finish**.

Now for the code. Add this line to the end of `zombieHitCat()`:

```
runAction(SKAction.playSoundFileNamed("hitCat.wav", 
  waitForCompletion: false))
```

Then add this line to the end of `zombieHitEnemy()`:

```
runAction(SKAction.playSoundFileNamed("hitCatLady.wav", 
  waitForCompletion: false)) 
```

Here, you play the appropriate sound action for each type of collision. Build and run, move the zombie around and enjoy the sounds of the smash-up!

## Sharing actions

In the previous section, perhaps you noticed a slight pause the first time the sound plays. This can occur whenever the sound system loads a sound file for the first time. The solution to this problem also demonstrates one of the most powerful features of Sprite Kit’s actions: sharing.

The `SKAction` object doesn't itself maintain any state, and that allows you to do something cool: reuse actions on any number of nodes simultaneously! For example, the action you create to move the cat ladies across the screen looks something like this:

```
let actionMove = 
  SKAction.moveToX(-enemy.size.width/2, duration: 2.0)
```

But you're creating this action for every cat lady. Instead, you could create an `SKAction` property, store this action in it and then use that property wherever you're currently using `actionMove`.

> Note: In fact, you could modify Zombie Conga so it reuses most of the actions you’ve created so far. This would reduce the amount of memory your system uses, but that’s a performance improvement you probably don’t need to make in such a simple game. 

But how does this relate to the sound delay? 

The application is loading the sound the first time you create an action that uses it. So to prevent the sound delay, you can create the actions in advance and then use them when necessary.

Create the following properties:

```
let catCollisionSound: SKAction = SKAction.playSoundFileNamed(
  "hitCat.wav", waitForCompletion: false)
let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed(
  "hitCatLady.wav", waitForCompletion: false)
```

These properties hold shared instances of the sound actions you want to run. 

Finally, replace the line that plays the sound in `zombieHitCat()` with the following:

```
runAction(catCollisionSound)
```

And replace the line that plays the sound in `zombieHitEnemy()` with the following:

```
runAction(enemyCollisionSound)
```

Now you're reusing the same sound actions for all collisions rather than creating a new one for each collision.

Build and run again. You'll no longer experience any pauses before the sound effects play.

As for music, stay tuned (no pun intended!)—you’ll learn about that in the next chapter, where you’ll wrap up the core gameplay by adding a win/lose scene to the game.

But before you move on, be sure to get some practice with actions by working through the challenges for this chapter!

## Challenges

This chapter has three challenges, and as usual, they progress from easiest to hardest. 

Be sure to do these challenges. As a Sprite Kit developer, you’ll be using actions all the time, so it’s important to practice with them before moving further.

As always, if you get stuck, you can find solutions in the resources for this chapter—but give it your best shot first!

### Challenge 1: The ActionsCatalog demo

This chapter covers the most important actions in Sprite Kit, but it doesn’t cover all of them. To help you get a solid understanding of all the actions available to you, I’ve created a little demo called ActionsCatalog, which you can find in the resources for this challenge.

Open the project in Xcode and build and run. You’ll see something like the following:

![iphone-landscape bordered](images/021_ActionsCatalog.png)
 
Each scene in the app demonstrates a particular set of actions, shown as the part of the label before the backslash. This first example demonstrates the various move actions.

Each time you tap the screen, you’ll see a new set of actions. As the scenes transition, you’ll also see different transition effects, shown as the part of the label after the backslash.

Your challenge is to flip through each of these demos, then take a look at the code to answer the following questions:

1. What action constructor would you use to make a sprite follow a certain pre-defined path?

2. What action constructor would you use to make a sprite 50% transparent, regardless of what its current transparency settings are?

3. What are “custom actions” and how do they work at a high level?

You can check your answers in a comment at the top of GameScene.swift in the solution project for this chapter.

### Challenge 2: An invincible zombie

Currently, when an enemy hits the zombie, it destroys the enemy. This is a sneaky way of avoiding the problematic scenario of the enemy colliding with the zombie multiple times in a row as it moves through the zombie, which would result in the squish sound effect playing just as many times in rapid succession.

Usually in a video game, you'd resolve this problem by making the player sprite invincible for a few seconds after it gets hit, so the player has time to get his or her bearings.

Your challenge is to modify the game to do just this. When the zombie collides with a cat lady, he should become temporarily invincible instead of destroying the cat lady. 

While the zombie is invincible, he should blink. To do this, you can use the custom blink action that's included in ActionsCatalog. Here’s the code for your convenience:

```
let blinkTimes = 10.0
let duration = 3.0
let blinkAction = SKAction.customActionWithDuration(duration) {
  node, elapsedTime in
  let slice = duration / blinkTimes
  let remainder = Double(elapsedTime) % slice
  node.hidden = remainder > slice / 2
}
```

If you’d like a detailed explanation of this method, see the comment in the solution for the previous challenge. Here are some hints for solving this challenge:

* You should create a variable property to track whether or not the zombie is invincible.
* If the zombie is invincible, you shouldn’t bother enumerating the scene’s cat ladies.
* If the zombie collides with a cat lady, don’t remove the cat lady from the scene. Instead, set the zombie as invincible. Next, run a sequence of actions that first makes the zombie blink 10 times over three seconds, then runs the block of code described below.
* The block of code should set `hidden` to `false` on the zombie, making sure he’s visible at the end no matter what, and set the zombie as no longer invincible.

### Challenge 3: The conga train

This game is called Zombie Conga, but there’s no conga line to be seen just yet!

Your challenge is to fix that. You’ll modify the game so that when the zombie collides with a cat, instead of disappearing, the cat joins your conga line!

![iphone-landscape bordered](images/022_CongaLine.png)
 
In the process of doing this, you’ll get more practice with actions, and you’ll also review the vector math material you learned in the last chapter. Yes, that stuff still comes in handy when working with actions!

First, when the zombie collides with a cat, don’t remove the cat from the scene. Instead, do the following:

1.	Set the cat’s name to “train” instead of “cat”.
2.	Stop all actions currently running on the cat by calling `removeAllActions()`.
3.	Set the scale of the cat to 1 and its rotation to 0.
4.	Run an action to make the cat turn green over 0.2 seconds. If you’re not sure what action to use for this, check out `ActionsCatalog`.

After this, there are three more things you have to do:

1. Create a constant `CGFloat` property to keep track of the cat’s move points per second. Set it to 480.0. 
2. Set the zombie’s `zPosition` to 100, which will make the zombie appear on top of the other sprites. Larger `z` values are “out of the screen” and smaller values are “into the screen”, and the default value is 0.
3. Make a new method called `moveTrain`. The basic idea for this method is that every so often, you make each cat move toward the current position of the previous cat. This creates a conga line effect!

$[===]

Use the following template:

```
func moveTrain() {
  var targetPosition = zombie.position

  enumerateChildNodesWithName("train") { 
    node, _ in
    if !node.hasActions() {
      let actionDuration = 0.3
      let offset = // a 
      let direction = // b 
      let amountToMovePerSec = // c 
      let amountToMove = // d 
      let moveAction = // e 
      node.runAction(moveAction)
    }
    targetPosition = node.position
  }
}
```

You need to fill in **a** through **d** by using the `CGPoint` operator overloads and utility functions you created last chapter, and **e** by creating the appropriate action. Here are some hints:

1.	You need to figure out the offset between the cat’s current position and the target position.
2.	You need to figure out a unit vector pointing in the direction of the offset.
3.	You need to get a vector pointing in the direction of the offset, but with a length of the cat’s move points per second. This represents the amount and direction the cat should move in a second. 
4.	You need to get a fraction of the `amountToMovePerSec` vector, based on the `actionDuration`. This represents the offset the cat should move over the next `actionDuration` seconds. Note that you’ll need to cast `actionDuration` to a `CGFloat`.
5.	You should move the cat a relative amount based on the `amountToMove`.

Finally, don't forget to call `moveTrain` at the end of `update()`.

And that’s it—who said you couldn’t herd cats? If you got this working, you’ve truly made this game live up to its name: Zombie Conga!



