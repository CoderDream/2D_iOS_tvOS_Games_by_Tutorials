# Chapter 11 - Advanced Physics
```metadata
author: "By Marin Todorov"
number: "11"
title: "Chapter 11: Advanced Physics"
section: 2
```

In the last chapter, you saw how easy it is to create responsive game worlds with Sprite Kit, especially when using the scene editor. By now, you’re a champion of creating sprites and physics bodies and configuring them to interact under simulated physics.

But perhaps you’re already thinking in bigger terms. So far, you can move shapes by letting gravity, forces and impulses affect them. But what if you want to constrain the movement of shapes with respect to other shapes—for example, maybe you want to pin a hat to the top of the cat’s head, and have it rotate back and forth based on physics? Dr. Seuss would be proud!

In this chapter, you’ll learn how to do things like this by adding two new levels to Cat Nap—three, if you successfully complete the chapter’s challenge! By the time you’re done, you’ll have brought your knowledge of Sprite Kit physics to an advanced level and will be able to apply this newfound force in your own apps.

> **Note**: This chapter begins where the previous chapter’s Challenge 1 left off. If you were unable to complete the challenge or skipped ahead from an earlier chapter, don’t worry—simply open the starter project from this chapter to pick up in the right place.

## The Sprite Kit game loop, round 3

To get you back on track with Cat Nap, you’re going to add one last touch to Level 1: a smarter failure detection system.

Specifically, you want to detect whether the cat is leaning to either side by more than 25 degrees. If he is, you want to wake up the cat, at which point the player should fail the level.

![width=33%](<images/image1.png>)

To achieve this, you’ll check the position of the cat every frame, but only after the physics engine does its job. That means you have to understand a bit more about the Sprite Kit game loop.

Back in the third chapter of this book, you learned that the Sprite Kit game loop looks something like this:

![width=80%](<images/image2.jpg>)

Now it’s time to introduce the next piece of the game loop: simulating physics. Here's your new version of the loop:

![width=85%](<images/image3.jpg>)

After evaluating the sprite actions, but just before rendering the sprites onscreen, Sprite Kit performs the physics simulation and moves the sprites and bodies accordingly, represented by the yellow chunk in your new diagram. At that point, you have a chance to perform any code you might like by implementing `didSimulatePhysics()`, represented by the red chunk.

This is the perfect spot to check if the cat is tilting too much!

> **Note**: The new loop also includes `didFinishUpdate()`. This is a method you can override if you want do something after all the other processing has beeen completed.

To write your code to check for the cat's tilt, you’ll use a function from `SKTUtils`, the library of helper methods you added to the project in the previous chapter. In particular, you’ll use a handy method that converts degrees into radians.

Make sure you have CatNap open where you left it off in the previous chapter's challenge. Then inside **GameScene.swift**, implement `didSimulatePhysics()` as follows:

```swift
override func didSimulatePhysics() {
  if playable {
    if fabs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
      lose()
    }
  }
}
```

$[=p=]

Here you perform two tests:

- **Is the game currently playable?** You check if `playable` is `true` to see if the player is still solving the level.
- **Is the cat tilted too much?** Specifically, is the absolute value of the cat’s `zRotation` property more than the radian equivalent of 25 degrees?

When both of these conditions are `true`, then you call `lose()` right away, because obviously the cat is falling over and should wake up immediately!

One more thing to note is that `catNode` never rotates; this node is contained by the cat reference and is therefore pinned to its parent node. That's why you need to keep an eye on the rotation of the cat as a whole by referencing `catNode.parent!`.

Build and run, and then fail the level on purpose. The cat wakes up while he’s still in the air, before he even touches the ground.

![width=75%](<images/image4.png>)

This is more realistic behavior, as it’s hard to sleep when falling to the ground!

## Introducing Level 2

So far, you’ve been working on a game with a single game scene. Cat Nap, however, is a level-based puzzle game.

In this section of the chapter, you’re going to give the game the ability to present different levels onscreen, and you’ll add a second level right away. Level 2 will feature new interactive physics objects, like springs, ropes and hooks.

Except for this game, you’ll call the springs *catapults*. See what I did there? =] 

![width=75%](<images/image5.png>)

Fortunately for the cat, this level will have just one catapult. Here’s how the level will look when you’re finished:

![width=75%](<images/image6.png>)

I know, I know. That catapult underneath the cat and the hook on the ceiling look rather nefarious, but I promise no animals will be harmed in the making of this game.

To win the level, the player first needs to tap the catapult. This will launch the cat upward, where the hook will catch and hold him suspended. With the cat safely out of the way, the player can destroy the blocks. Once the blocks are destroyed, the player can tap the hook to release the cat, who will then descend safely to his bed below.

On the other hand, if the player destroys the blocks first and then taps the catapult, the cat won’t rise high enough to reach the hook, causing the player to lose the level.

$[=s=]

## Loading levels

Lucky for you, you're already loading levels in your game.

You have a single level so far, and the level file is named **GameScene.sks**. You load it, show it onscreen, and then you implement the game logic in your `GameScene` class.

You need to create another **.sks** file for each of Cat Nap’s levels. Then, you need to load and display these new levels, one after the next, as the player solves them.

First of all, to avoid confusion, rename **GameScene.sks** to **Level1.sks**.

Next, you need to add a factory method on your `GameScene` class that takes a level number and creates a scene by loading the corresponding **.sks** file from the game bundle.

To do this, add the following property and class function to `GameScene`:

```swift
//1
var currentLevel: Int = 0

//2
class func level(levelNum: Int) -> GameScene? {
  let scene = GameScene(fileNamed: "Level\(levelNum)")!
  scene.currentLevel = levelNum
  scene.scaleMode = .AspectFill
  return scene
}
```

You'll use the `currentLevel` property to hold the current level’s number. The class method `level(_:)` takes in a number and calls `GameScene(fileNamed:)`. If the level file loads successfully, you set the current level number on the scene and scale correctly.

Now you need to make a few changes to your view controller. Open **GameViewController.swift** and find the following line in `viewDidLoad()`:

```swift
if let scene = GameScene(fileNamed: "GameScene") {
```

Replace it with this:

```swift
if let scene = GameScene.level(1) {
```

That’s much nicer on the eye, isn’t it?

Next, open **GameScene.swift** and locate `newGame()`. To improve it with the new factory method, replace the complete method body with this:

```swift
view!.presentScene(GameScene.level(currentLevel))
```

Build and run to verify the game works as usual. 

Good work. Now you can focus on building Level 2.

## Scene Editor, round 2

After doing so much in code, it’ll be nice to use the scene editor again.

From Xcode’s menu, select **File\New\File...**. Then choose **iOS\Resource\SpriteKit Scene** and click **Next**.

![width=80%](<images/image7b.png>)

Name the new file **Level2.sks** and click **Create**.

As soon as you save the file, Xcode opens it in the scene editor. Zoom out until you see the yellow border:

![width=80%](<images/image8.png>)

With the scene editor skills you already possess from previous chapters, setting up this scene will be simple—as well as a great way to review what you've learned.

First, resize the scene to 2048x1536:

![width=50% bordered](<images/image10.png>)

Next, add five color sprite objects to the scene and set their properties as follows:

 * **Background**: Texture **background.png**, Position **(1024, 768)**
 * **Bed**: Texture **cat_bed.png**, Name **bed**, Position **(1024, 272)**, Custom Class **BedNode**
 * **Block1**: Texture **wood_horiz1.png**, Name **block**, Position **(1024, 260)**, Body Type **Bounding Rectangle**, Category Mask **2**, Collision Mask **43**, Custom Class **BlockNode**
 * **Block2**: Texture **wood_horiz1.png**, Name **block**, Position **(1024, 424)**, Body Type **Bounding Rectangle**, Category Mask **2**, Collision Mask **43**, Custom Class **BlockNode**
 * **Spring**: Texture **spring.png**, Name **spring**, Position **(1024, 588)**, Body Type **Bounding Rectangle**, Category Mask **32**, Collision Mask **11**, Custom Class **SpringNode**
 
Whoa, that’s a lot of objects! Much of what you’re doing is recreating the elements from Level 1: a background image, a cat bed, and some blocks.

For this level, you added a sprite for the spring; it uses a new physics category, `32`, and a new custom class, `SpringNode`. You don't have those yet, but you can quickly add them right now.

Open **GameScene.swift** and find the `PhysicsCategory` struct at the top of the file. Add a new constant to use for your springs:

```swift
static let Spring:UInt32 = 0b100000 // 32
```

> **Note**: For practice, see if you can figure out why you set the category mask to 43 for the two blocks in the level. If you get stuck, open Calculator on your Mac, switch to Programmer mode and enter in 43 to see the number in binary.

Next, create a new file by choosing **File/New/File...** and select **iOS/Source/Cocoa Touch Class** for the template. Name the new class **SpringNode**, make it a subclass of **SKSpriteNode** and click **Next**, then **Create**.

Xcode will automatically open the file. When it does, replace the contents of the file with this:

```swift
import SpriteKit

class SpringNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
  
  func didMoveToScene() {
    
  }

  func interact() {
	  
  }
}
```

Look familiar? Your custom node class implements the `CustomNodeEvents` protocol and has an empty `didMoveToScene()` method, where you'll add some code momentarily. In addition, this class conforms to `InteractiveNode`, because you want to let the player tap on the spring node and interact with it.

There's only one key component missing from your new level—the cat!

Open **Level2.sks** and drag in a **reference** from the Object Library:

![width=85%](<images/image-reference.png>)

Give the reference object the following properties, matching the cat's configuration in Level 1:

 * Name **cat\_shared**, Reference **Cat.sks**, Position **(983, 894)**, Z Position **10**.

Next, it's time to test the level. 

$[=p=]

Head over to **GameViewController.swift** and replace `if let scene = GameScene.level(1) {` with this:

```swift
if let scene = GameScene.level(2) {
```

Now the game begins with Level 2, rather than Level 1. That's right: Not only does this make it quicker to test Level 2—now you can cheat in your own game! =]

Build and run the project, and you’ll see the initial setup for your new level:

![width=40%](<images/image11.png>)

You’ll see the cat pass straight through the spring. That happens because your existing code doesn’t know about your new spring objects. You're about to change that.

$[=s=]

### Catapults

Since catapults are a new category of objects for your game, you need to tell your scene how other objects should interact with them. The code for this will be quite familiar to you, so I won’t spell out all of the details; feel free to move through this part quickly.

> **Note**: In this chapter, I use the words **catapults** and **springs** interchangeably.

To make the cat sit on top of the catapult, you need to enable collisions between the cat and the catapult. 

Open **CatNode.swift**, and in `didMoveToScene()`, change the line responsible for setting the cat’s `collisionBitMask` to include `PhysicsCategory.Spring`:

```swift
parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge | PhysicsCategory.Spring
```

Now your catapult and cat should behave as expected. 

Build and run the game, and check it out.

![width=75%](<images/image12.png>)

One small change in code; one big step for sleepy cats!

Next, it's time to make the catapult hurl that kitty when the player taps on the spring sprite. It’s actually quite easy; if the player taps on the catapult, you need to apply an impulse to the spring, which will then bounce the cat—if, of course, the cat is on top of the spring. 

The first step is to enable user interaction on the spring node so it will react to taps. 

Switch to **SpringNode.swift** and add the following line inside `didMoveToScene()`:

```swift
userInteractionEnabled = true
```

And just like you did for the block nodes, add the respective `UIResponder` method to detect taps:

```swift
override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
  super.touchesEnded(touches, withEvent: event)
  interact()
}
```

Now, add the code for the interaction in `interact()`:

```swift
userInteractionEnabled = false

physicsBody!.applyImpulse(CGVector(dx: 0, dy: 250),
  atPoint: CGPoint(x: size.width/2, y: size.height))

runAction(SKAction.sequence([
  SKAction.waitForDuration(1),
  SKAction.removeFromParent()
]))
```

When the player taps a spring node, you apply an impulse to its body using `applyImpulse(_:atPoint:)`; this is similar to what you did in Chapter 9, "Beginning Physics", with the sand particles. Because a spring can "jump" only once, you disable the user input on that node as soon as it receives a tap. Finally, you remove the catapult after a delay of one second.

Build and run the game again, and this time, tap on the catapult:

![width=40%](<images/image13.png>)

Houston, we have lift off... and a slight problem.

Right now, when catapulted, the kitty flips through the air and lands on its head. That’s why you need to add the ceiling hook to grab him!

The idea is that the catapult will bounce the kitty right onto the hook, which will hold him while the player clears the blocks. Once the blocks are gone, you'll release the kitty so he falls straight into his bed. Mrrow!

## Joints: An overview

To implement the ceiling hook, you need **joints**. In Sprite Kit, there are five types of joints available, each of which lets you constrain the positions of two bodies relative to each other. This section describes them in turn.

> **Note**: Because joints are a heavily-used concept in physics-based games, it's a good idea to familiarize yourself with them.

### Fixed joint

A fixed joint gives you the ability to attach two physics bodies together.

Imagine you have two objects and you nail them together with a few rusty nails. If you take one of them and throw it, the other one will fly right along with it.

![width=50%](<images/image14.jpg>)

Sometimes, you want to make an object immoveable. The quickest way to do that is to fix it to the scene's edge loop, and you're ready to go. 

Other times, you want a complex object a player can destroy—and perhaps break into many pieces. If that's the case, simply fix the pieces together, and when the player hits the object, remove the joints so the pieces fall apart.

### Limit joint

You can use a limit joint to set the maximum distance between two physics bodies. Although the two bodies can move closer to each other, they can never be farther apart than the distance you specify. 

Think of a limit joint as a soft but strong rope that connects two objects. In the diagram below, the ball is connected to the square via a limit joint; it can bounce around, but it can never move farther away than the length of the limit joint:

![width=40%](<images/image15.jpg>)

These types of joints are useful when you want to connect two objects, but let one move independently of the other within a certain radius—like a dog on a leash!

$[=p=]

### Spring joint

A spring joint is much like a limit joint, but the connection behaves more like a rubber band: it's elastic and springy.

Like a limit joint, a spring joint is useful for simulating rope connections, especially ropes made of elastic. If you have a bungee-jumping hero, the spring joint will be of great help!

![width=40%](<images/image16.jpg>)

### Pin joint

A pin joint fixes two physics bodies around a certain point, the anchor of the joint. Both bodies can rotate freely around the anchor point—if they don’t collide, of course. 

Think of the pin joint as a big screw that keeps two objects tightly together, but still allows them to rotate:

![width=33%](<images/image17.jpg>)

If you were to build a clock, you’d use a pin joint to fix the hands to the dial; if you were to build a physics body for an airplane, you’d use a pin joint to attach the propeller to the plane’s nose.

### Sliding joint

A sliding joint fixes two physics bodies on an axis along which they can freely slide; you can further define the minimum and maximum distances the two bodies can be from each other while sliding along the axis.

The two connected bodies behave as though they're moving on a rail with limits on the distance between them:

![width=67%](<images/image18.jpg>)

A sliding joint might come in handy if you're building a roller coaster game and you needed the two car objects to stay on the track, but to keep some distance from one another.

> **Note:** It's possible to apply more than one joint to a physics body. For example, you could use one pin joint to attach an hour hand to a clock face, and add a second pin joint to connect the minute hand to the clock face.

## Joints in use

The easiest way to learn how to use joints is to try them out for yourself. And what better way to do that than by creating the hook object and attaching it to the ceiling.

Consider this blueprint for the hook object:

![width=40%](<images/image19.jpg>)

There's one body fixed to the ceiling (the base), another body for the hook, and a third body that connects them together (the rope).

To make this structure work, you’ll be using two types of joints:

* **A fixed joint** to fix the base to the ceiling.

* **A spring joint** to connect the hook to the base. The spring joint will be your rope.

### Using a fixed joint

First, you need to add the relevant sprites in the scene editor. Open **Level2.sks** and add two color sprites, configured as follows:

 * **Hook mount**: Texture **wood\_horiz1.png**, Position **(1024, 1466)**
 * **Hook base**: Texture **hook\_base.png**, Name **hookBase**, Position **(1024, 1350)**, Body Type **Bounding Rectangle**, Custom Class **HookNode**

**hookBase** is the node to which the hook and its rope will be attached. The base itself is going to be fixed on the ceiling by a joint to the scene edge body.

You might wonder what purpose the wood block serves. It doesn't even have a physics body! Take a look at the playable area on an iPhone and an iPad:

![width=85%](<images/image20.png>)

On a 4” iPhone, the scene cuts out somewhere just before the top edge of the hook base—it looks like the hook base is built into the ceiling. But remember that an iPad's screen aspect ratio is different, which is why on the iPad, you can see more of the scene. If it weren’t for the wood piece on top, it would look like the hook base were just floating in midair.

So the wood block's only role is to make things look nice. On an iPhone, it’s outside of the screen bounds, so the player won't even see it.

Perhaps you've noticed that the hook has a custom node class; you're going to add that to the project now.

Create a new file by choosing **File/New/File...**, and select the file template **iOS/Source/Cocoa Touch Class**. Name the new class **HookNode**, make it a subclass of **SKSpriteNode** and click **Next** and then **Create**.  Xcode will automatically open the file once it's created.

To clear the error you see in Xcode by default, replace `import UIKit` with:

```swift
import SpriteKit
```

`HookNode` is a little different than the other custom nodes you've created so far. Since the hook is a compound object made of a base, a swinging rope and the hook itself, you'll use only one custom class for the whole structure.

You're also going to create the rope and the hook in code rather than in the scene editor.

First, you need a way to access the parts of the hook, so add the following properties in **HookNode.swift**:

```swift
private var hookNode = SKSpriteNode(imageNamed: "hook")
private var ropeNode = SKSpriteNode(imageNamed: "rope")
private var hookJoint: SKPhysicsJointFixed!

var isHooked: Bool {
  return hookJoint != nil
}
```

The first two properties are the nodes you need in order to finish building the hook object, and `hookJoint` is something you'll use later when the kitty bounces and is "hooked" by the rope. Finally, there's a dynamic property named `isHooked`; this checks if there's already a stored physics joint in `hookJoint`.

Next, make your new class conform to the `CustomNodeEvents` protocol by adding the declaration to the `class` line:

```swift
class HookNode: SKSpriteNode, CustomNodeEvents {
```

 Also, add the initial stub for `didMoveToScene()`:
 
```swift
func didMoveToScene() {
  guard let scene = scene else {
    return
  }
}
```

You check to see if the node has already been added to the scene; if so, you bail out. 

Now in `didMoveToScene()`, you're going to configure and add `hookNode` and `ropeNode`. Then, you're going to finish constructing the hook. You'll do this in a few steps. 

First, add the following, after the `guard` statement but not within it:

```swift
let ceilingFix = SKPhysicsJointFixed.jointWithBodyA(scene.physicsBody!, bodyB: physicsBody!, anchor: CGPoint.zero)
scene.physicsWorld.addJoint(ceilingFix)
```

Here, you use a factory method of `SKPhysicsJointFixed` to create a joint instance between the current node's body and the scene’s own body, which is the edge loop. You're also giving the joint an anchor point, which tells the scene at what location to create the connection between the two bodies.

You always specify the anchor point in scene coordinates. When you attach a body to the scene’s body, you can safely pass any value as the anchor point, so you use `(0, 0)`. Also note that you must have already added the sprites as children of the scene before you can create the joint.

Finally, you add the joint to the scene’s physics world. Now, these two bodies are connected until the end of time—or until you remove the joint.

> **Note:** When you create a fixed joint, the two bodies don’t need to be touching—each body simply maintains its relative position from the anchor point.
>
> In addition, you could get this same behavior without using a joint at all. Instead, you could make the physics body static, either by unchecking the **Dynamic** field in the scene editor or by setting the `dynamic` property of the `physicsBody` to `false`. This would be more efficient for the physics engine, but you’re using a fixed joint here for learning purposes.

Build and run the game, and you’ll see the hook base fixed securely to the top of the screen:

![width=50%](<images/image21.png>)

> **Note**: If you don't see it, try running the game on an iPad or iPad Simulator.

Look at that line going from the bottom-left corner to the top of the scene—this is the debug physics drawing representing the joint you just created. It indicates there's a joint connecting the scene itself—with a position of `(0, 0)`—to the hook.

Since you're on a roll, add the sprite for the rope, too. 

Back in **HookNode.swift**, and in `didMoveToScene()`, add the following at the end:

```swift
ropeNode.anchorPoint = CGPoint(x: 0, y: 0.5)
ropeNode.zRotation = CGFloat(270).degreesToRadians()
ropeNode.position = position
scene.addChild(ropeNode)
```

This positions the rope just under the hook base, sets its anchor point to be its top—since it's going to swing like a pendulum—and aligns it so it points down. 

Now it's time to add the hook itself, which will use a different type of joint.

### Using a spring joint

First, you need one more body category for the hook, so switch back to **GameScene.swift** and add this new value to the `PhysicsCategory`:

```swift
static let Hook:  UInt32 = 0b1000000 // 64
```

Now, go back to **HookNode.swift** and add the following to the end of `didMoveToScene()`:

```swift
hookNode.position = CGPoint(
  x: position.x,
  y: position.y - ropeNode.size.width )

hookNode.physicsBody =
  SKPhysicsBody(circleOfRadius: hookNode.size.width/2)
hookNode.physicsBody!.categoryBitMask = PhysicsCategory.Hook
hookNode.physicsBody!.contactTestBitMask = PhysicsCategory.Cat
hookNode.physicsBody!.collisionBitMask = PhysicsCategory.None

scene.addChild(hookNode)
```

This creates a sprite, sets its position and creates a physics body for it. It also sets the category bitmask to `PhysicsCategory.Hook`, and sets the `contactTestBitMask` such that it detects contacts between the hook and the cat.

The hook doesn’t need to collide with any other objects. Later, you'll implement some custom behavior for it that default Sprite Kit physics doesn’t provide. 

> **Note**: You position the hook sprite just under the ceiling base, because the distance between the base and the hook is precisely the length of the rope that will hold them together.

$[=p=]

Now, create a spring joint to connect the hook and its ceiling holder by adding the following to `didMoveToScene()`:

```swift
let hookPosition = CGPoint(x: hookNode.position.x,
  y: hookNode.position.y+hookNode.size.height/2)

let ropeJoint =
SKPhysicsJointSpring.jointWithBodyA(physicsBody!,
  bodyB: hookNode.physicsBody!,
  anchorA: position,
  anchorB: hookPosition)
scene.physicsWorld.addJoint(ropeJoint)
```

First, you calculate the position of the `hookNode` where the joint should attach itself and store that position in `hookPosition`.

Then, using a factory method similar to the one you used for the ceiling joint, you connect the `hookNode` body and the hook's base body with a spring joint. You also specify the precise points in the scene’s coordinate system where the rope connects to the two bodies.

Build and run the game now. If all's well, you’ll see your hook hanging in the air just under the ceiling:

![width=40%](<images/image22.png>)

The rope joint works fine, but that rope doesn't move.

## The Sprite Kit game loop, round 4

At long last, it’s time to introduce the final missing piece of the Sprite Kit game loop. 

As you can see below, after Sprite Kit finishes simulating physics, it performs one last step: applying something named **constraints** to the scene and notifying your scene that this has happened.

![width=80%](<images/image23.jpg>)

Let's take a look at how this works.

## Constraints: An overview

Constraints are a handy Sprite Kit feature that let you easily ensure certain relationships are true regarding the position and rotation of sprites within your game.

The best way to understand constraints is to see them in action. 

Open **GameScene.swift** and add the following code to the end of `didMoveToView(_:)`:

```swift
let rotationConstraint =  SKConstraint.zRotation(
  SKRange(lowerLimit: -π/4, upperLimit: π/4))
catNode.parent!.constraints = [rotationConstraint]
```

There are two steps to using a constraint:

* **Create the constraint**. This example creates a constraint that limits `z` rotation from -45° to 45°, and applies it to the cat node.

* **Add the constraint to a node**. To add the constraint to a node, simply add it to the constraints array on the node.

> **Note**: To type π in your source code, press and hold the **Alt** key on your keyboard and press **P**. π is a constant defined in `SKTUtils`; you can press Command and click on it in Xcode to jump to its definition. If you prefer, you can use `CGFloat(M_PI)` instead.

$[=p=]

After Sprite Kit finishes simulating the physics, it runs through each node’s constraints and updates the position and rotation of the node so that the constraint is met. 

Build and run to see this in action:

![width=40%](<images/image24.png>)

As you can see, even though the physics simulation sometimes determines that the cat should fall over beyond 45°, during the constraint phase of the game loop, Sprite Kit updates the cat’s rotation to 45° so the constraint remains `true`.

This was just a test, so comment out the previous code:

```swift 
//let rotationConstraint =
//  SKConstraint.zRotation(
// SKRange(lowerLimit: -π/4, upperLimit: π/4))
//catNode.parent!.constraints = [rotationConstraint]
```

You could also add constraints to do such things as:

 * Limit a sprite so it stays within a certain rectangle;

 * Make a turret in your game point in the direction in which it’s shooting;

 * Constrain a sprite’s movement along the x-axis;

 * Limit the rotation of a sprite to a certain range.

After this crash course in constraints, you’re ready to use a real constraint in your Cat Nap game. Specifically, you'll finish the hook object by adding the final piece: the rope constraint.

### Implementing a rope with a constraint

Now you’re going to use a constraint to make sure the rope is always oriented toward the hook sprite, making it appear as if the rope is connected to the hook.

In **HookNode.swift**, add the following code at the end of `didMoveToScene()`:

```swift
let range = SKRange(lowerLimit: 0.0, upperLimit: 0.0)
let orientConstraint = SKConstraint.orientToNode(hookNode, offset: range)
ropeNode.constraints = [orientConstraint]
```

`SKConstraint.orientToNode(_:offset:)` produces a constraint object that automatically changes the `zRotation` of the node to which its being applied, so that the node always points toward another “target” node.

You can also provide an offset range to the constraint if you don’t want to orient the node with perfect precision. Since you want the end of the rope and the hook to be tightly connected, you provide a zero range for the constraint.

Finally, you set the `orientConstraint` as the sole constraint for the `ropeNode`.

One last step. There’s nothing that moves the hook—which makes it look kind of odd. Add this line to the end of `didMoveToScene()`:

```swift
hookNode.physicsBody!.applyImpulse(CGVector(dx: 50, dy: 0))
```

This applies an impulse to the hook node so that it swings from its base. 

Build and run the game again. Check out your moving, customized level object:

![width=75%](<images/image25.png>)

Remember, there are two things going on here that make this behavior work:

* You set up a **joint** connecting the hook to the base. This makes it so the hook is always a certain distance from the base, so it appears to “swing” from the base.

* You set up a **constraint** that makes the rope always orient itself toward the hook so that it appears to follow the hook.

Together, this makes for a pretty sweet effect!

$[=p=]

> **Note**: A previous version of this chapter instructed readers to manually orient the rope inside the scene’s `update()` method. On every invocation of `update()`, the code calculated the angle between the base and hook sprites and set this angle for the `zRotation` of the rope.
>
> This is still a perfectly valid strategy, but since Sprite Kit now has built-in constraints that can handle this for you, this edition uses the new approach. In your games, choose whichever is easiest for you.

There’s one thing I should mention to keep my conscience clear: Right now, the rope is represented by just one sprite. That means your rope is more like a rod.

If you’d like to create an object that better resembles a rope, you could create several shorter sprite segments and connect them to each other, like so:

![width=67%](<images/image26.jpg>)

In this case, you might want to create physics bodies for each rope segment and connect them to each other with pin joints.

### More constraints

So far, you've seen examples of the `zRotation()` and `orientToNode(_:offset:)` constraints.

There are a number of other types of constraints you can create in Sprite Kit beyond these. Here’s a reference of what's available:

* `positionX()`, `positionY()` and `positionX(y:)`: These let you restrict the position of a sprite to within a certain range on the x-axis, y-axis or both. For example, you could use these to restrict the movement of a sprite to be within a certain rectangle on the screen.

* `orientToPoint(_:offset:)` and `orientToPoint(_:inNode:offset:)`: Just like you can make a sprite orient itself toward another sprite, as you made the rope orient itself toward the hook, you can make a sprite always orient itself toward a certain point. For example, you could use these to make a turret point toward where the user taps.

* `distance(_:toNode:)`, `distance(_:toPoint:)` and `distance(_:toPoint:inNode)`: These let you ensure that two nodes, or a node and a point, are always within a certain distance of each other. The function is similar to a limit joint, except these work on any node, whether or not it has a physics body.

## Creating and removing joints dynamically

You need to add a few final touches to get the whole cat-hooking process to work: You need to check for hook-to-cat contact, and you need to create and remove a joint to fix the cat to the rope dynamically.

Open **GameScene.swift** and scroll to `didBeginContact()`. This is the place where you detect when object bodies in your game touch. You need to check if the two contacting bodies are the hook and the cat. You also need to do an additional check to see if they're already hooked together.

To do these checks, you need an outlet to the hook node. Add a new property to **GameScene.swift**:

```swift
var hookNode: HookNode?
```

Next, you need to look through the scene hierarchy to find out if there's a hook node. Don't forget, the other levels don't have a hook, and that's why you need an Optional value for that property.

OK! Next, at the bottom of `didMoveToView(_:)`, add the following:

```swift
hookNode = childNodeWithName("hookBase") as? HookNode
```

That line should be familiar; you simply locate the node by name and assign it to the property you created earlier.

Now scroll back to `didBeginContact()` and add the check for a hook-to-cat contact:

```swift
if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookNode?.isHooked == false {
  hookNode!.hookCat(catNode)
}
```

$[=p=]

You check if the collision bitmask matches the cat and hook categories, and that the two aren't hooked together already. If both are true, you call `hookCat(_:)` on the hook node. Of course, this method doesn't exist yet, so you'll get an error, but that's an easy problem to fix. 

Go back to **HookNode.swift** and add a new method to hook the cat:

```swift
func hookCat(catNode: SKNode) {
  catNode.parent!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
  catNode.parent!.physicsBody!.angularVelocity = 0
}
```

First, you manually alter the physics simulation by forcing a velocity and angular velocity of zero on the cat’s body. You do this to calm things down when the cat's about to get hooked; you don’t want to make players wait too long before their next moves while they wait for the hook to stop swinging.

The important point here is that you can manually alter the physics simulation. How great is that? Don’t be afraid to do this—making the game fun is your top priority. 

$[=s=]

Now, add the following to that same method:

```swift
let pinPoint = CGPoint(
  x: hookNode.position.x,
  y: hookNode.position.y + hookNode.size.height/2)

hookJoint = SKPhysicsJointFixed.jointWithBodyA(hookNode.physicsBody!,
  bodyB: catNode.parent!.physicsBody!, anchor: pinPoint)
scene!.physicsWorld.addJoint(hookJoint)

hookNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
```

With that block of code, you calculate the position where the two bodies will be fixed together. Using this position, you create a new `SKPhysicsJointFixed` to connect the hook and cat, and then you add it to the world.

You also need to make `didSimulatePhysics()` respect the fact that the kitty is “hooked”, so that the game is OK with rotating to angles more than the margin of 45 degrees. 

Open **GameScene.swift** and inside `didSimulatePhysics()`, change the `if` condition from `if playable {` to this:

```swift
if playable && hookNode?.isHooked != true {
```

Now when the cat swings on the hook, he won’t wake up. 

$[=p=]

Build and run the game, and play around.

![width=75%](<images/image27.png>)

When the cat hangs from the ceiling, you can safely destroy the blocks over the cat bed. But you’re still missing one thing—the cat needs to fall off the hook and into the bed. To make that happen, you need to remove the joint you just added.

This time, add the method to destroy the joint before you call it. Open **HookNode.swift** and add the following:

```swift
func releaseCat() {
  hookNode.physicsBody!.categoryBitMask = PhysicsCategory.None
  hookNode.physicsBody!.contactTestBitMask = PhysicsCategory.None
  hookJoint.bodyA.node!.zRotation = 0
  hookJoint.bodyB.node!.zRotation = 0
  scene!.physicsWorld.removeJoint(hookJoint)
  hookJoint = nil
}
```

In this method, you simply undo what you did in `hookCat(_:)`. You remove the joint connecting the hook and the cat. Then, you straighten up the cat and the hook.

Next, you'll add the code to let the cat fall off the hook. In the game, the player will need to tap the cat while it swings in midair.

Here you encounter a new problem: The player needs to tap on the cat node, but the hook node needs to react to this action. You don't want to couple the hook and the cat by making them know about each other in some way. You want to keep nodes de-coupled, since different levels feature different node combinations.

To keep the nodes independent from each other, you'll use notifications. 

Each time the player taps on the cat, it will send a notification, and nodes that are interested in this event will have the chance to catch the broadcast and react in whatever way is necessary.

First, you're going to handle taps on the cat node. Open **CatNode.swift** and add the following to `didMoveToScene()`:

```swift
userInteractionEnabled = true
```

Just like before, you need to make this class adhere to `InteractiveNode`. 

Add the protocol to the class declaration:

```swift
class CatNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
```

As soon as you do that, Xcode will complain about missing the required protocol method, so add a stub for now:

```swift
func interact() {
}
```

Then, outside of the class body and just under `import SpriteKit`, define a new notification name:

```swift
let kCatTappedNotification = "kCatTappedNotification"
```

$[=s=]

Now add the method to handle touches:

```swift
override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
  super.touchesEnded(touches, withEvent: event)
  interact()
}
```

Each time the player taps on the cat, a notification needs to be sent via `NSNotificationCenter`. To make that happen, add the following line of code inside `interact()`:

```swift
NSNotificationCenter.defaultCenter().postNotificationName(
  kCatTappedNotification, object: nil)
```

You'll do more in `interact()`, but for now, you simply broadcast a `kCatTappedNotification`.

> **Note**: This time around, you don't disable user interactions inside `interact()`. Since other nodes might implement custom logic based on taps on the cat, you can't speculate whether or not further touches on that node would be of interest. To be safe, you keep accepting touches and broadcasting the same notification over and over again.

Next, you're going to observe for the `kCatTappedNotification`. If one is received, you're going to release the cat from the hook, but—needless to say—only if the cat is already hooked.

Open **HookNode.swift** and in `didMoveToScene()`, add the following:

```swift
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(catTapped), name: kCatTappedNotification, object: nil)
```

This code "listens" for a notification named `kCatTappedNotification`. If it "hears" a notification, it will invoke the `catTapped()` method on the `CatNode` class. Of course, you still need to add that method, so do that now:

```swift
func catTapped() {
  if isHooked {
    releaseCat()
  }
}
```

In `catTapped()`, you simply check if the cat is currently hanging from the hook, and in that case, you call `releaseCat` to let it go. That's all!

Build and run the game again, and try to land the cat on the bed. You probably don’t need this advice, but: tap on the catapult, tap on all the blocks, and then tap the cat to solve the level.

![width=75%](<images/image28.png>)

Creating joints dynamically is a fun and powerful technique. I hope to see you use it a lot in your own games!

$[=p=]

## Compound shapes

It’s time to move on to the third level of Cat Nap.

In this level, you’ll tackle another game physics concept, one related to body complexity. With this in mind, have a look at the completed Level 3 and try to guess what’s new compared to the previous levels:

![width=75%](<images/image29.png>)

You guessed right if you said that in Level 3, one of the blocks has a more complicated shape than your average wooden block. 

Perhaps you also noticed that the shape is broken into two sub-shapes. Maybe you even wondered why it was done that way instead of being constructed as a polygon shape, like the shape in the challenge in Chapter 9, "Beginning Physics".

Sometimes in games, for reasons related to game logic, you need an object that’s more complex than a single image with a physics body. To better understand the problem, let's go back in time, I mean - back in chapters.

Do you remember your old friend the zombie from the Zombie Conga minigame?

![width=33%](<images/zombie4.png>)

In a physics based game a zombie would have quite a complex shape and you might be temped to use a single texture for it. But if you make the zombie body-parts separate nodes with separate physics bodies you could make him wave his hands, move his legs, etc.

Also - everyone knows that when zombies don't keep a strict diet of fresh brains they start loosing limbs. You have surely seen your green friends drop an arm or a jaw on the way while they chase the hero in the latest Hollywood horror movie.

For example if you use separate nodes for the zombie arms you could simply "detach" them during any point in your game for an added comical effect.

Having said that, in this section you'll build a simple compound body for the next level of Cat Nap. 

### Designing the third level

Just as before, replace the starting level in **GameViewController.swift**:

```swift
if let scene = GameScene.level(3) {
```

Creating the third level of Cat Nap in the scene editor will follow much the same process as for Level 2.

Select the **Scenes** group in the project navigator. From Xcode’s menu, select **File/New/File...** and then **iOS/Resource/SpriteKit Scene**. Click **Next**, save the file as **Level3.sks**, and click **Create**.

You'll be rewarded, as usual, with the sight of an empty game scene. Sorry, no flashing lights, screaming fans or bells and whistles. But hey, maybe they'll add that in a future release. =]

OK, first, resize the scene to 2048x1536 points. Then, add the following color sprite objects to the empty scene:

 * **Background**: Texture **background.png**, Position **(1024, 768)**
 * **Bed**: Texture **cat\_bed.png**, Name **bed**, Position **(1024, 272)**, Custom Class **BedNode**
 * **Block1**: Texture **wood\_square.png**, Name **block**, Position **(946, 276)**, Body Type **Bounding Rectangle**, Category Mask **2**, Collision Mask **11**, Custom Class **BlockNode**, Z Position **2**
 * **Block2**: Texture **wood\_square.png**, Name **block**, Position **(946, 464)**, Body Type **Bounding Rectangle**, Category Mask **2**, Collision Mask **11**, Custom Class **BlockNode**, Z Position **2**
 * **Block3**: Texture **wood\_vert2.png**, Name **block**, Position **(754, 310)**, Body Type **Bounding Rectangle**, Category Mask **2**, Collision Mask **11**, Custom Class **BlockNode**, Z Position **2**
 * **Block4**: Texture **wood\_vert2.png**, Name **block**, Position **(754, 552)**, Body Type **Bounding Rectangle**, Category Mask **2**, Collision Mask **11**, Custom Class **BlockNode**, Z Position **2**
 * **Stone1**: Texture **rock\_L\_vert.png**, Name **stone**, Position **(1282, 434)**, Custom Class **StoneNode**
 * **Stone2**: Texture **rock\_L\_horizontal.png**, Name **stone**, Position **(1042, 714)**, Custom Class **StoneNode**

Finally, drag in a **reference** from the Object Library. Give the reference object the following properties:

 * Name **cat\_shared**, Reference **Cat.sks**, Position **(998, 976)**.

This is the complete setup for Level 3.

Build and run the game to see what you have so far:

![width=75%](<images/image32.png>)

The level in its current state doesn’t look very good. The cat falls through the stone L-shaped block as if the block weren't in the scene at all. And no wonder—you didn't create any bodies for the two blocks used to build the L-shape. In the next section, you'll learn how to create a complex body that matches the shape of the new stone block.

### Making compound objects

For your stone nodes, you'll have an even more elaborate initialization than for the hook.

You'll develop a custom class called `StoneNode`. When you add it to the scene, it will search for all stone pieces, remove them from the scene and create a new compound node to hold them all together. As you can see, when it comes to creating custom node behavior, the sky's the limit!

First, create a new file by choosing **File/New/File...** and selecting **iOS/Source/Cocoa Touch Class** for the template. Name the new class **StoneNode**, make it a subclass of **SKSpriteNode** and click **Create**. Xcode will automatically open the new file.

To clear the error you see in Xcode, replace the default contents with the following:

$[=p=]

```swift
import SpriteKit

class StoneNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
  
  func didMoveToScene() {
    
  } 

  func interact() {
    
  }
}
```

This code looks familiar by now: You create a custom `SKSpriteNode` subclass and adapt your `CustomNodeEvents` protocol.

Next, add the method that will look through the scene nodes and bind together all the stone pieces. Make it a static method:

```swift
static func makeCompoundNode(inScene scene: SKScene) -> SKNode {
  let compound = StoneNode()
  compound.zPosition = -1
   
}
```

You initialize an empty `StoneNode` object to hold your stone pieces, and give it a `zPosition` of `-1` to make sure the empty node doesn't "stay" in front of some other nodes.

> **Note**: Don't worry about the error. That will disappear after you finishing adding the rest of the code.

Next, find all the stone pieces and remove them from the scene. Then, add each one to `compound`, instead:

```swift
for stone in scene.children.filter({node in node is StoneNode}) {
  stone.removeFromParent()
  compound.addChild(stone)
}
```

You filter the scene child nodes, taking only the ones of type `StoneNode`. Then, you simply move them from their current places into the hierarchy of the `compound` node.

$[=p=]

Next, you need to create physics bodies for each of these pieces. You'll just loop over all the stone nodes now contained in `compound` node and create a physics body for each one:

```swift
let bodies = compound.children.map({node in
  SKPhysicsBody(rectangleOfSize: node.frame.size, center: node.position)
})
```

With this code, you store all the bodies in the `bodies` array, because in the next bit of code, you'll be supplying them to the initializer of `SKPhysicsBody(bodies:)` and creating a compound physics body out of all the pieces. 

Do that now by adding the following:

```swift
compound.physicsBody = SKPhysicsBody(bodies: bodies)
compound.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Cat | PhysicsCategory.Block
compound.physicsBody!.categoryBitMask = PhysicsCategory.Block
compound.userInteractionEnabled = true
compound.zPosition = 1

return compound
```

`SKPhysicsBody(bodies:)` takes all of the bodies you provide and binds them together; you set the result as the body of the compound node. Finally, you set the collision bitmask of the stone node so that it collides with the cat, the other blocks and the edge of the screen.

Before returning the ready-for-use `compound` node, you enable user interactions on it. That way, the player can't tap on the separate pieces; only the compound node will accept taps.

> **Note**: Now that you're returning a valid object, the error should be resolved.

$[=s=]

All that's left to do is call the new method from `didMoveToScene()`, so do that now:

```swift
let levelScene = scene
    
if parent == levelScene {
  levelScene!.addChild(StoneNode.makeCompoundNode(inScene: levelScene!))
}
```

For each node, you check if its parent is `levelScene`. If it is, that means the node hasn't been moved to the `compound` node, in which case you call `makeCompoundNode(inScene:)`.

Since you're removing the stone nodes from their parents before adding them to `compound` within `makeCompoundNode(inScene:)`, they lose their link to the game scene. That's why, before you start modifying the nodes, you store a pointer to the current scene object in `levelScene` and use that variable until the end of the method.

Build and run the game, and behold the coveted L-shaped stone in all its compound glory! 

Destroy one of the **wooden** blocks on the left to see the two stone pieces now behave as one solid body:

![width=75%](<images/image34.png>)

Victory! You have a compound body in your scene.

If you try to solve the level, it won't work; that's because you haven't added interactivity to the stone blocks yet.

$[=s=]

Switch back to **StoneNode.swift** and override the `UIResponder` method to react to touches:

```swift
override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
  super.touchesEnded(touches, withEvent: event)
  interact()
}
```

Then add the relevant code in `interact()`:

```swift
userInteractionEnabled = false

runAction( SKAction.sequence([
  SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
  SKAction.removeFromParent()
]))
```

Note that `interact()` will be called on your compound node, so calling `removeFromParent()` will remove the compound node and both of the pieces it contains. Two for the price of one!

No matter which of the pieces the player taps, you remove *all* of the pieces by removing the node that holds them. 

Build and run the game again. This time, you'll be able to solve the level.

![width=75%](<images/image39.png>)

## Level progression

Until this point, you've worked on one level at a time, so you’ve manually specified which level to load. However, that won’t work for players—they expect to proceed to the next level after winning!

This is quite easy to implement. Begin by setting the game to load Level 1. Change the line that loads the scene in **GameViewController.swift** so it looks like this:

```swift
if let scene = GameScene.level(1) {
```

Then, in **GameScene.swift**, add the following code at the beginning of `win()`. Make sure you add it before all of the other code:

```swift
if (currentLevel < 3) {
  currentLevel += 1
}
```

Now, every time the player completes a level, the game will move on to the next one. 

Finally, to raise the stakes, add this to the beginning of `lose()`:

```swift
if (currentLevel > 1) {
  currentLevel -= 1
}
```

That’ll certainly make the player think twice before tapping a block!

![width=50%](<images/image40.png>)

Congratulations - you now have three unique levels for Cat Nap. You've learned how to use the scene editor and how to create custom classes for your nodes. You've even learned how to implement custom behavior. From here on out, you're ready to start working on your own level-based game. The principles you learned in the last four chapters remain the same in any physics game.

There's one more chapter with Cat Nap to go, where you'll be learning about some more advanced types of nodes you can use in your game. But before you move on - try your hand at the challenge below!

## Challenges

By now, you’ve come a long way toward mastering physics in Sprite Kit.

And because I’m so confident in your skills, I’ve prepared a challenge for you that will require a solid understanding of everything you’ve done in the last three chapters—and will ask even more of you.

### Challenge 1: Add one more level to Cat Nap

Your challenge is to develop an entirely new level by yourself. If you do everything just right, the finished level will look like this:

![width=75%](<images/image41.png>)

As you can see, this time, besides blocks, there’s a seesaw between the poor cat and its bed. This cat sure has a hard life.

And yes, it’s a real seesaw; it rotates about its center and is fully interactive. And you developed it all by yourself! Er, sorry—you *will* develop it all by yourself. See, I have confidence in you. :]

I’ll lay down the main points and you can take it from there. 

Here are the objects to place in **Level4.sks**:

 * **Background**: Texture **background.png**, Position **(1024, 768)**
 * **Bed**: Texture **cat\_bed.png**, Name **bed**, Position **(1024, 272)**, Custom Class **BedNode**
 * **Block1**: Texture **wood\_square.png**, Name **block**, Position **(1024, 626)**, Body type **Bounding Rectangle**, Category Mask **2**, Collision Mask **11**, Custom Class **BlockNode**
 * **Block2**: Texture **wood\_square.png**, Name **block**, Position **(1024, 266)**, Body type **Bounding Rectangle**, Category Mask **2**, Collision Mask **11**, Custom Class **BlockNode**
 * **Seesaw base**: Texture **wood\_square.png**, Name **seesawBase**, Position **(514, 448)**, Body type **Bounding Rectangle**, Uncheck **Dynamic** checkbox under Body Type, Category Mask **0**
 * **Seesaw**: Texture **ice.png**, Name **seesaw**, Position **(518, 440)**, Body type **Bounding Rectangle**, Category Mask **2**, Collision Mask **11**
 
 And, of course, the cat reference:
 
 * Name **cat\_shared**, Position **(996, 943)**, Z position **10**

Once you’ve placed these objects, the scene should look something like this:

![width=70%](<images/image42.png>)

There’s not much left to do from here—I’ll assume you’ve done everything perfectly so far!

You’ll need to fix the seesaw board to its base on the wall. Do that by creating a pin joint that will anchor the center of the board to the center of the base and let the board rotate around that anchor, like so:

![width=75%](<images/image44.png>)

You can create a pin joint in two ways. First, create it in code using `SKPhysicsJointPin.jointWithBodyA(bodyB:anchor:)` to make sure you understand how that works. You’ll need to find the node by name and use it to create the joint.

After that, you can remove that code and do the much simpler thing: Check the **Pinned** checkbox in the scene editor, in the seesaw’s **Physics Definition** section. This will create a pin joint that connects the node to the scene at the node’s anchor point.

That's it. Try solving the level yourself. I’m not going to give you any other tips besides the fact that the order in which you destroy the blocks matters.
