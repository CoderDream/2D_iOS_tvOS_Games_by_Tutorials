# Chapter 10 - Intermediate Physics
```metadata
author: "By Marin Todorov"
number: "10"
title: "Chapter 10: Intermediate Physics"
section: 2
```

In Chapter 8, "Scene Editor", you got acquainted with Sprite Kit's level designer by building the first level of a game called Cat Nap. 

Then in Chapter 9, "Beginning Physics", you took up physics in Sprite Kit by experimenting in real time inside a playground. You learned how to add bodies to sprites, create shapes, customize physics properties and even apply forces and impulses. 

In this chapter, you're going to use your newly acquired scene editor and physics skills to add physics into Cat Nap, creating your first fully playable level! By the end of this chapter, you'll finally be able to help the sleepy cat settle into his bed:

![width=67% bordered](<images/image1.png>)

Purr-fect!

> **Note**: This chapter begins where the Chapter 8’s Challenge 2 left off. If you were unable to complete the challenges or skipped ahead from an earlier chapter, don’t worry—simply open the starter project from this chapter to pick up where Chapter 8's Challenge 2 left off.

$[=s=]

## Getting started

Open your CatNap project, and make sure **GameScene.swift** is open.

First, you're going to do some more scene initialization by overriding the scene’s `didMoveToView(_:)`. Just as you did for Zombie Conga, you need to set the scene’s playable area so that when you’re finished developing Cat Nap, it will fully support both iPhone and iPad screen resolutions.

To get rid of the default code added by Xcode, replace the contents of **GameScene.swift** with the following:

```swift
import SpriteKit

class GameScene: SKScene {

  override func didMoveToView(view: SKView) {  
    // Calculate playable margin

    let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
    let maxAspectRatioHeight = size.width / maxAspectRatio
    let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2

    let playableRect = CGRect(x: 0, y: playableMargin, 
      width: size.width, height: size.height-playableMargin*2)

    physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)  
  }
}
```

Just as you did for Zombie Conga, you begin with the aspect ratio of the iPhone 5 screen and then define the frame of the playable area based on the current scene size.

Since Cat Nap is a physics-based game, you set the detected playable frame as the edge loop for the scene. That’s all there is to it—Sprite Kit will now automatically confine your game objects within the area you designate for the gameplay.

Now you're ready to put to work those sprites you placed in the scene editor!

## Custom node classes

When you place objects in the scene editor, you choose from the list provided in the Object Library. As you already know, you can drag-and-drop a generic node, a sprite node showing an image, or a label. At run-time, Sprite Kit creates the nodes from the respective built-in type and sets them up the way you want.

This, however, leaves you with limited room for customization—you can't add new methods or simply override one of the built-in functionalities with your own implementation.

In this section, you'll learn how to create and employ your own custom node classes, which will give you exactly the behavior you need for your game from every node in your level.

You'll start by adding a simple class for the cat bed node. From Xcode's main menu, select **File/New/File...** and for the file template, choose **iOS/Source/Swift file**. Name the new file **BedNode.swift** and save it.

Replace the default contents with an empty `SKSpriteNode` subclass:

```swift
import SpriteKit

class BedNode: SKSpriteNode {
}
```

You've created an empty class that derives from `SKSpriteNode`; now you need to link this class to the bed sprite in the scene editor. To do this, open **GameScene.sks** in the scene editor and select the cat bed. In the utilities area, switch to the **Custom Class Inspector**, which is the last tab on the right.

For **Custom Class**, enter **BedNode**.

![width=50% bordered](<images/image39_1.png>)

This way, when you launch your game, instead of creating a plain `SKSpriteNode` for the cat bed, Sprite Kit will make a new instance of `BedNode`. Now you can customize your `BedNode` class to behave in the way you'd like.

Next, to understand how much you can do with custom node classes, you're going to add an event method that will get called when the node is added to the scene. If you're familiar with building `UIKit` apps for iOS, it will be similar to `UIView.didMoveToWindow()`.

First, you need a new protocol for all the nodes that implement your custom event. Open **GameScene.swift** and add the following after the `import` statement:

```swift
protocol CustomNodeEvents {
  func didMoveToScene()
}
```

Now, switch back to **BedNode.swift** and make the class conform to the new protocol by adding a `didMoveToScene()` method stub that prints out a message. The class will now look like this:

$[=s=]

```swift
import SpriteKit

class BedNode: SKSpriteNode, CustomNodeEvents {
  func didMoveToScene() {
	print("bed added to scene")
  } 
}
```

As the final step, you need to call the new method. A good place to do that is at the bottom of the `didMoveToView(_:)` of your scene class.

Back in **GameScene.swift**, add the following code at the end of `didMoveToView(_:)`:

```swift
enumerateChildNodesWithName("//*", usingBlock: {node, _ in
  if let customNode = node as? CustomNodeEvents {
    customNode.didMoveToScene()
  }
})
```

Here you use `enumerateChildNodesWithName(_:usingBlock:)`, an `SKNode` method that loops over all the nodes that exist in the scene. While `childNodeWithName(_:)` finds the first node matching the given name or search pattern, `enumerateChildNodesWithName(_:usingBlock:)` returns an array containing all the nodes that match the name or pattern you're looking for.

As the first parameter, you can specify either a node name or a search pattern. If you've worked extensively with XML, you'll notice the similarities:

* **/name**: Search for nodes named "name" in the root of the hierarchy
* **//name**: Search for nodes named "name" starting at the root and moving recursively down the hierarchy
* **\***: Matches zero or more characters; e.g. "name\*" will match name1, name2, nameABC and name

> **Note**: For additional examples, review the section "Advanced Searches" in Apple's `SKNode` docs: [http://apple.co/1I9QfBz](http://apple.co/1I9QfBz)

Now you can decipher the search pattern from the last code block: "**//\***". When your search pattern starts with **//**, the search starts at the top of the node hierarchy, and when you search for **\***, which means *any name*, you loop over all existing nodes, regardless of their names or their locations in the node hierarchy.

As a second parameter, `enumerateChildNodesWithName(_:usingBlock:)` gets a closure; the code inside is executed once per each matching node. The first closure parameter is the node result, and the second gives you an opportunity to stop the search at that point. 

Build and run the game. You'll see your test message show up—your code looped over all nodes, matched the ones implementing `CustomNodeEvents` and called `didMoveToScene()` on each one:

![width=50% bordered](<images/image25_1.png>)

This proves that your game is using your custom `BedNode` `SKSpriteNode` subclass for the cat bed. w00t!

Now you can put all your node setup code in `didMoveToScene()` for each respective node class. That way, you won't clog your scene class with code that's relevant only to specific nodes. In your scene class, you'll add the code that has to do with the entire scene or interaction between nodes.

To give custom classes another try, add a custom class for the cat. From Xcode's main menu, select **File/New/File...** and for the file template, choose **iOS/Source/Swift file**. Name the new file **CatNode.swift** and save it.

Replace the default contents with the following `SKSpriteNode` subclass:

```swift
import SpriteKit

class CatNode: SKSpriteNode, CustomNodeEvents {
  func didMoveToScene() {
	print("cat added to scene")
  } 
}
```

Just like before, you make sure that when the method gets called, it prints a statement.

One last thing before moving on: You don't want to change the class in **GameScene.sks**; you want to change the class in **Cat.sks**. Remember, **GameScene.sks** only holds a reference to **Cat.sks**, so you need to go to **Cat.sks** to set the appropriate class for your cat node.

Open **Cat.sks** and select the `cat_body` sprite node. In the Custom Class Inspector, set the **Custom Class** to **CatNode**.

$[=p=]

Build and run the game again. The output in the console is now:

![width=50% bordered](<images/image25_2.png>)

The cat is one step closer to taking a nap!

Next you need to connect the nodes you created in the scene editor to variables, so you can access the sprites in code.

## Connecting sprites to variables

For those familiar with UIKit development, connecting nodes to variables is somewhat like connecting views in your storyboard to outlets.

Open **GameScene.swift** and add two instance variables to the `GameScene` class:

```swift
var bedNode: BedNode!
var catNode: CatNode!
```

`catNode` and `bedNode` are—or will be in a moment—the cat and cat bed sprite nodes, respectively. Notice that you use their custom classes, because the scene editor takes care to use the correct type when creating the scene nodes.

Open **GameScene.sks** and select the cat bed. In the Attributes Inspector, notice that the sprite has the name **bed**. This is how you'll find that sprite in the scene from code—by its name. In UIKit development, the name of the sprite is much like a view's `tag` property.

Switch back to **GameScene.swift** and add the following code to `didMoveToView(_:)`:

```swift
bedNode = childNodeWithName("bed") as! BedNode
```

`childNodeWithName(_:)` loops through a node's children and returns the *first node* with the required name. In this case, you loop through the scene's children, looking for the bed sprite, which is based on the name you set in the scene editor.

For the cat sprite, you need a different approach. You don't want to work with the cat reference; instead, you want to work with the cat body. After all, only the cat's body will have its own physics body—you don't need to apply physics simulation to the eyes or the whiskers!

Since the `cat_body` sprite is not a direct child of the scene, you can't simply provide the name `cat_body` to `childNodeWithName(_:)` and expect to get it back. Instead, you need to recursively search through all the children of the children of the scene!

![width=85%](images/rage_grandma.png)

Consulting the search pattern table reference from earlier, you end up with the simple pattern **//cat_body**. That being the case, add this line to `didMoveToView(_:)`:

```swift
catNode = childNodeWithName("//cat_body") as! CatNode
```

Now you have a reference to each sprite, so you can modify them in code. To test this, add the following two lines to the end of `didMoveToView(_:)`:

```swift
bedNode.setScale(1.5)
catNode.setScale(1.5)
```

Build and run, and you’ll see Giganto-Cat!

![iphone-landscape bordered](<images/image26.png>)

Now that you’ve proved you can modify the sprites in code, comment out those two lines to revert the cat and bed back to normal:

```swift
// bedNode.setScale(1.5)
// catNode.setScale(1.5)
```

Sorry about that, Giganto-cat, but cats already have a big enough ego! :]

Congratulations - now you know how to connect objects in the scene editor to code. Now it's time to move onto physics!

## Adding physics

Recall from the previous chapter that for the physics engine to kick in, you need to create physics bodies for your sprites. In this section, you’re going to learn three different ways to do that: 

1. Creating simple bodies in the scene editor
2. Creating simple bodies from code
3. Creating custom bodies

Let's try each of these methods, one at a time.

### Creating simple bodies in the scene editor

Looking at your scene as it is now, you can’t help but notice that those wooden blocks would make perfect use of rectangular physics bodies.

![width=75% bordered](<images/image27.png>)

From your experiments in the previous chapter, you already know how to create rectangular bodies in code, so let’s look at how to do it in the scene editor.

Open **GameScene.sks** and select the four block sprites in your scene. Press and hold the **Command** key on your keyboard and click on each block until you've selected them all:

![bordered width=65% print](<images/image28.png>)
![bordered width=75% screen](<images/image28.png>)

In the **Physics Definition** section of the Attributes Inspector, change the selection for **Body Type** to **Bounding Rectangle**. This will open a section with additional properties, allowing you to control most aspects of a physics body. You read about each of these properties in the previous chapter.

![width=40% bordered](<images/image29.png>)

The default property values look about right for your wooden blocks: The bodies will be **dynamic**, can **rotate** when falling and are **affected by gravity**. The **Mass** field reads **Multiple Values**, because Sprite Kit assigned a different mass to each wooden block based on its size.

$[=p=]

That’s all you need to do to set up the blocks’ physics bodies. Notice now that when you deselect the blocks, they're faintly outlined in blue-green, indicating they have physics bodies:

![width=50% bordered](<images/image30.png>)

There’s one last thing to do: Select all four wooden blocks again, scroll to the top of the Attributes Inspector and enter **block** in the **Name** field. Now you can easily enumerate all the blocks in the scene and also easily see which ones are blocks when you debug the scene.

> **Note**: This kind of node setup is something you could implement in a custom node class. Don't worry—you'll learn how to set up your bodies both from the scene editor and from code. But you can only do one at a time. :]
>
> In fact, you'll add a custom class for the block nodes later, when you add user interaction to them.

### Simulating the scene

Let’s quickly explore another feature of the scene editor.

You know that clicking the **Animate** button will run any sprite actions you add to sprites. But what about physics? Will the same button also fire up the good old physics engine? Click **Animate** and watch what happens:

![width=90%](<images/image32.png>)

You'll see the blocks fall down off the screen. They won't stop at the edges, because the animate button does not run the code that creates the edge loop that you added to `GameScene`, but this is still a handy way to do some basic testing.

### Creating simple bodies from code

What if you want a physics body to be smaller than a node’s bounding rectangle or circle? For example, you might want to be "forgiving" in the collision detection between two objects to make the gameplay easier or more fun, similar to how you reduced the collision box for the crazy cat lady in Zombie Conga.

Making the physics body a different shape than the sprite itself is easy to do, and also gives you an opportunity to apply your skills from the previous chapter to Cat Nap.

The cat bed itself won’t participate in the physics simulation; instead, it will remain static on the ground and exempt from collisions with other bodies in the scene. It will still have a physics body, though, because you need to detect when the cat falls onto the bed. So you're going to give the bed small, non-interactive body for the purpose of detecting contacts.

Since you’ve already connected your `bedNode` instance variable to the bed sprite, you can create the body in code.

Switch to **BedNode.swift** and add the following to `didMoveToScene()`:

```swift
let bedBodySize = CGSize(width: 40.0, height: 30.0)
physicsBody = SKPhysicsBody(rectangleOfSize: bedBodySize)
physicsBody!.dynamic = false
```

As you learned in the previous chapter, a sprite’s physics body doesn’t necessarily have to match the sprite’s size or shape. For the cat bed, you want the physics body to be much smaller than the sprite, because you only want the cat to fall happily asleep when he hits the exact center of the bed. Cats are known to be picky, after all!

Since you never want the cat bed to move, you set its dynamic property to `false`. This makes the body static, which allows the physics engine to optimize its calculations, because it can ignore any forces applied to this object.

> **Note**: You need to force-unwrap the `physicsBody` property—it’s an *optional* property, so you need to use `!` if you're sure there's a body attached to the sprite, or `?` if you're not.

Open **GameViewController.swift** and add the following line inside `viewDidLoad()`, just after the code that declares `skView`:

```swift
skView.showsPhysics = true
```

Build and run the project, and you’ll see your scene come alive:

![width=67% bordered](<images/image33.png>)

Look at the little rectangle toward the bottom of the screen—that’s the physics body of the cat bed! It’s green so that you remember it’s not a dynamic physics body.

But your carefully built obstacle tower appears a little off-center. That happened because the bed body pushed aside your central wooden block. To fix this, you’ll need to set the block bodies and the bed body so they don’t collide with each other, something you’ll learn how to do a bit later.

### Creating custom bodies

Looking at the cat sprite, you can instantly guess that a rectangular or a circular body won’t do—you'll have to use a different approach and create a custom-shaped physics body.

To do this, you'll load a separate image that describes the shape of the cat's physics body and use it to create the body object itself. Open **CatNode.swift** and add this code to `didMoveToScene()`:

```swift
let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())
```

You create a new texture object out of an image named **cat\_body_outline.png.** From the project navigator, open **cat\_body_outline** from your assets catalog and you'll see it contains this blue shape:

![width=70% bordered](<images/image36b.png>)

This shape doesn’t include the cat’s head or tail, and it doesn’t follow the outline of the paws. Instead, it uses a flat bottom edge, so the cat will remain stable on those wooden blocks.

Next, you create a body for the cat sprite using an `SKPhysicsBody` instance and the appropriate texture, scaling it to the node's own `size`. You’re already familiar with how to do this from the previous chapter.

Build and run the project again, and check out the debug drawing of the cat’s body. Excellent work!

![width=40% bordered](<images/image37b.png>)

Now that you've set up the first level, why don't you take a break from all this physics and get the player in the mood for puzzles by turning on some soothing and delightful music?

## Introducing SKTUtils

In the first few chapters of this book, while you were working on Zombie Conga, you created some handy extensions to allow you to do things like add and subtract two `CGPoints` by using the `+` or `–` operators.

Rather than make you continuously re-add these extensions in each mini-game, we’ve combined them and created a library named `SKTUtils`.

Besides handy geometry and math functions, this library also includes a useful class that helps you easily play an audio file as your game's background music.

Now you're going to add `SKTUtils` to your project so you can make use of these methods throughout the rest of the chapter. Happy birthday!

Locate `SKTUtils` in the root folder for this book and drag the entire **SKTUtils** folder into the project navigator in Xcode. Make sure **Copy items if needed**, **Create Groups** and the **CatNap** target are all checked, and click **Finish**.

Take a minute to review the contents of the library. It should look quite familiar, with a few additions and tweaks:

![width=90% bordered](<images/image37_1.png>)

Now every class in your project has access to these timesaving functions.

## Background music

Now that you've added `SKTUtils`, it will be a cinch to add background music. Open **GameScene.swift** and add this code to `didMoveToView(_:)` to start the music:

```swift
SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
```

Build and run the project, and enjoy the merry tune!

> **Note**: You still have many more build and runs ahead of you in this chapter. If at any time you feel like muting the background music, just comment out this last line.

## Controlling your bodies

So far, you know how to create physics bodies for sprites and let the physics engine do its thing.

But in Cat Nap, you want a bit more control than that. For example:

* **Categorizing bodies**. You want to keep the cat bed from colliding with the blocks, and vice versa. To do this, you need a way to categorize bodies and set up collision flags.
* **Finding bodies**. You want to enable the player to destroy a block by tapping it. To do this, you need a way to find a body at a given point.
* **Detecting collisions between bodies**. You want to detect when the cat hits the cat bed, so he can get his beauty sleep. To do this, you need a way to detect collisions.

You’ll investigate these areas over the next three sections. By the time you’re done, you’ll have implemented the most important parts of this mini-game!

### Categorizing bodies

Sprite Kit’s default behavior is for all physics bodies to collide with all other physics bodies. If two objects are occupying the same point, like the brick and the cat bed, the physics engine will automatically move one of them aside.

The good news is, you can override this default behavior and specify whether or not two physics bodies should collide. There are three steps to do this:

1. **Define the categories**. The first step is to define categories for your physics bodies, such as block bodies, cat bodies and cat bed bodies.
2. **Set the category bit mask**. Once you have a set of categories, you need to specify the categories to which each physics body belongs—a physics body can belong to more than one category—by setting its category bit mask.
3. **Set the collision bit mask**. You also need to specify the collision bit mask for each physics body. This controls which categories of bodies the body will collide with.

As with most things, the best place to start is at the beginning—in this case, by defining the categories for Cat Nap. In **GameScene.swift**, add the category constants **outside** the `GameScene` class, preferably at the top:

```swift
struct PhysicsCategory {
  static let None:  UInt32 = 0
  static let Cat:   UInt32 = 0b1 // 1
  static let Block: UInt32 = 0b10 // 2
  static let Bed:   UInt32 = 0b100 // 4
}
```

Now you can comfortably access body categories like `PhysicsCategory.Cat` and `PhysicsCategory.Bed`.

You’ve probably already spotted that each of the categories turns on another bit:

* **PhysicsCategory.None**: Decimal **0**, Binary **00000000**
* **PhysicsCategory.Cat**: Decimal **1**, Binary **00000001**
* **PhysicsCategory.Block**: Decimal **2**, Binary **00000010**
* **PhysicsCategory.Bed**: Decimal **4**, Binary **00000100**

This is very handy, and very fast for the physics engine to calculate, when you want to specify that the cat should collide with all block bodies and the bed. You can then say the collision bitmask for the cat is `PhysicsCategory.Block | PhysicsCategory.Bed`—read this as “block OR bed”—which produces the logical `OR` of the two values:

* **PhysicsCategory.Block \| PhysicsCategory.Bed**: Decimal **6**, Binary **00000110**

> **Note**: If you aren't quite at ease with binary arithmetic, you can read more about bitwise operations here: [http://en.wikipedia.org/wiki/Bitwise_operation](http://en.wikipedia.org/wiki/Bitwise_operation)

Now you can move on to steps two and three: setting the category and collision bit masks for each object, starting with the blocks.

Go back to **GameScene.sks** and select the **four wooden blocks**, as you did earlier. Look at the current **Category Mask** and **Collision Mask**:

![width=40% bordered](<images/image38.png>)

Both are set to the biggest integer value possible, thus making all bodies collide with all other bodies. If you convert the default value of `4294967295` to binary, you’ll see that it has all bits turned *on*, and therefore, it collides with all other objects:

```swift
4294967295 = 11111111111111111111111111111111
```

It’s time to implement custom collisions. Edit the blocks’ properties like so:

For **Category Mask**, enter the raw value of `PhysicsCategory.Block`, which is **2**;

For **Collision Mask**, enter the bitwise `OR` value of `PhysicsCategory.Cat | PhysicsCategory.Block`, which is **3**.

> **Note**: Just put the decimal values in the boxes—that is, for the Collision Mask, enter **3**.

![width=40% bordered](<images/image38b.png>)

This means you've set each block’s body to be of the `PhysicsCategory.Block` category, and you've set all of the blocks to collide with both the cat and other blocks.

Next, set up the bed. You created this body from code, so go back to **BedNode.swift** and add the following to the end of `didMoveToScene()`:

```swift
physicsBody!.categoryBitMask = PhysicsCategory.Bed
physicsBody!.collisionBitMask = PhysicsCategory.None
```

With the code above, you set the category of the bed body and then set its collision mask to `PhysicsCategory.None`—you don’t want the bed to collide with any other game objects.

> **Note**: As promised earlier, you're learning how to do things both from the scene editor and from code—when you're on your own, just pick whichever suits you. I personally like the code approach a little better, because you can use the defined enumeration members; in the scene editor, you have to use hard-coded integer values.

At this point, you’ve set up both the wooden blocks and the cat bed with the proper categories and collision masks. Build and run the project one more time:

![iphone-landscape bordered](<images/image39b.png>)

As expected, you see a block right in front of the bed’s body without either body pushing the other away. Nice!

Finally, set the bitmasks for the cat. Since you created the physics body for your cat sprite in code, you also have to set the category and collision masks in code, specifically in **CatNode.swift**. Open that file and add this to the end of `didMoveToScene()`:

```swift
parent!.physicsBody!.categoryBitMask = PhysicsCategory.Cat
parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block
```

You put the cat into its own category, `PhysicsCategory.Cat`, and set it to collide only with blocks. Note how you add the physics body to the parent node (i.e. the compound node that holds all cat parts).

> **Note:** A physics body’s `collisionBitMask` value specifies which categories of objects will affect the movement of *that* body when those two bodies collide. But remember, you set the bed’s `dynamic` property to `false`, which already ensures that no forces will ever affect the bed—so there’s no need to set the bed’s `collisionBitMask`.
>
> Generally, there's never a reason to set the `collisionBitMask` for an object with its `dynamic` property set to `false`. Likewise, edge loop bodies are always treated as if their `dynamic` property is `false`, even if it isn’t—so there's never a reason to set the `collisionBitMask` for an edge loop, either.

Now you know how to make a group of bodies pass through some bodies and collide with others. You’ll find this technique useful for many types of games. For example, in some games you want players on the same team to pass through each other, but collide with enemies from the other team. Often, you don't want game physics to imitate real life!

### Handling touches

In this section, you'll implement the first part of the gameplay. When the player taps a block, you'll destroy it with a *pop*.

To distinguish nodes you can tap on and those node that are just static decoration you will add a new protocol. Open **GameScene.swift** and add under the existing protocol declaration for `CustomNodeEvents`:

```swift
protocol InteractiveNode {
  func interact()
}
```

When you create a custom node for the level's block nodes you will make that class adhere to `Interactive` and will add the method `interact()` where you will place all code to react to the player's touches.

Since `SKNode` inherits from `UIResponder`, you can handle touches on each node from the node's own custom class by overriding `touchesBegan(_:withEvent:)`, `touchesEnded(_:withEvent:)` or other `UIResponder` methods.

Since right now you're interested in simple taps on the block nodes, a `BlockNode` class with just `touchesEnded(_:withEvent:)` will suffice.

You're already quite familiar with creating custom node classes, so this should be a breeze. From Xcode's main menu, select **File/New/File...** and for the file template, choose **iOS/Source/Swift file**. Name the new file **BlockNode.swift** and save it.

Replace the default contents with the following:

```swift
import SpriteKit

class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
  func didMoveToScene() {
    userInteractionEnabled = true
  }
  
  func interact() {
	userInteractionEnabled = false
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    print("destroy block")
    interact()
  }
}
```

For this type of node, you did all the physics body setup from the scene editor, so you only need to enable user interactions inside `didMoveToScene()`. By default, `userInteractionEnabled` is off to keep the responder chain as light as possible—but for your blocks, you definitely want to handle touches, so you set it to `true`.

Further, you override `touchesEnded(_:withEvent:)`, so you can handle simple taps on the block node - in the code above you simply call `interact()` and leave it do all the work. 

Since you will allow the players to destroy a block by simply tapping it once, as soon as `interact()` is being called you turn off `userInteractionEnabled` to ignore further touches on the same block.

The final step before you test that code is to set this custom class to all block nodes, in the scene editor. Open **GameScene.sks** and select the four wooden blocks just as you did before. In the Custom Class Inspector, enter **BlockNode** for the **Custom Class**:

![width=75% bordered](<images/image42_1.png>)

Build and run the project, and start tapping some blocks. You should see one line in the console for each of your taps on a block:

![width=50% bordered](<images/image42_2.png>)

Now for the fun part! You want to destroy those blocks and remove them from the scene. Add this to `interact()` in **BlockNode.swift**:

```swift
runAction(SKAction.sequence([
  SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
  SKAction.scaleTo(0.8, duration: 0.1),
  SKAction.removeFromParent()
  ]))
```

Here you're running a sequence of three actions: The first action plays an amusing *pop* sound, the next scales down the sprite and the last removes it from the scene. This should be enough to make the level's basic physics work. 

Build and run the project again. This time, when you tap the blocks, you've got your game on:

![width=75% bordered](<images/image42_3.png>)

### Detecting collisions between bodies

Very often in games, you’d like to know if certain bodies are in contact. Two or more bodies can “touch” or "pass through" each other, depending on whether or not they’re set to collide. In both cases, they're in contact:

![width=90%](<images/image43.jpg>)

In Cat Nap, you want to know whether certain pairs of bodies touch:

1. If **the cat touches the floor**, it means he's on the ground, but out of his bed, so the player fails the level.

![width=67%](<images/image44.jpg>)

2. If **the cat touches the bed**, it means he landed successfully on the bed, so the player wins the level.

![width=67%](<images/image45.jpg>)

Sprite Kit makes it easy for you to receive a callback when two physics bodies make contact. The first step is to implement the `SKPhysicsContactDelegate` methods. 

In Cat Nap, you’ll implement these methods in `GameScene`. Open **GameScene.swift** and add the `SKPhysicsContactDelegate` protocol to the class declaration line, so it looks like this:

```swift
class GameScene: SKScene, SKPhysicsContactDelegate {
```

The `SKPhysicsContactDelegate` protocol defines two methods you'll implement in `GameScene`:

 - `didBeginContact(_:)` tells you when two bodies first make contact.

 - `didEndContact(_:)` tells you when two bodies end their contact.

The diagram below shows how you'd call these methods in the case of two bodies passing through each other:

![width=95%](<images/image46.jpg>)

You’ll most often be interested in `didBeginContact(_:)`, because much of your game logic will occur when two objects touch.

However, there are times you’ll want to know when objects stop touching. For example, you may want to use the physics engine to test when a player is within a trigger area. Perhaps entering the area sounds an alarm, while leaving the area silences it. In a case such as this, you’ll need to implement `didEndContact(_:)`, as well.

To try this out, you first need to add a new category constant for the edges of the screen, since you want to be able to detect when the cat collides with the floor. Scroll to the top of **GameScene.swift** and add this new `PhysicsCategory` value:

```swift
static let Edge:  UInt32 = 0b1000 // 8
```

Then, find this line inside `didMoveToView(_:)`:

```swift
physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
```

And just below it, add the following:

```swift
physicsWorld.contactDelegate = self
physicsBody!.categoryBitMask = PhysicsCategory.Edge
```

First, you set `GameScene` as the contact delegate of the scene’s physics world. Then, you assign `PhysicsCategory.Edge` as the body’s category.

Build and run the project to see the results of your actions so far.

Hmm... that’s not right. All the blocks fall through the edge—but just seconds ago, the project worked fine!

![iphone-landscape bordered](<images/image47b.png>)

The issue here is that the world edge now has a category, `PhysicsCategory.Edge`, but the blocks aren’t set to collide with it. Therefore, they fall through the floor. Meanwhile, the cat bed’s `dynamic` property is set to `false`, so it can’t move at all.

With no blocks on the screen, you have no game! Open **GameScene.sks** in the scene editor and select the four wooden blocks, just as you did before. Then, change the **Collision Mask** for their bodies from 3 to **11**.

* **PhysicsCategory.Block \| PhysicsCategory.Cat \| PhysicsCategory.Edge**: Decimal **11**, Binary **00001011**

Build and run the project now, and you’ll see the familiar scene setup. But try popping all the blocks out of the cat’s way, and you’ll see the cat fall through the bottom of the screen and disappear. Goodbye, Kitty!

By now, you probably know what's wrong: The cat doesn’t collide with the scene’s edge loop, of course!

Go to **CatNode.swift** and change the line where you set the cat’s collision mask so that the cat also collides with the scene's boundaries:

```swift
parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge
```

This should keep that pesky feline from falling off the screen!

Build and run the project again, and everything will appear (and behave!) as it should.

![iphone-landscape bordered](<images/image48b.png>)

### Detecting contact between bodies

You’ve learned to use the `categoryBitMask` to set a physics body's categories, and the `collisionBitMask` to set the colliding categories for a physics bodies. Well, there’s another bit mask: `contactTestBitMask`.

You use `contactTestBitMask` to detect contact between a physics body and designated categories of objects. Once you’ve set this up, Sprite Kit will call your physics contact delegate methods at the appropriate time.

$[=p=]

In Cat Nap, you want to receive callbacks when the cat makes contact with either the edge loop body or the bed body, so switch to **CatNode.swift** and add this line to the end of `didMoveToScene()`:

```swift
parent!.physicsBody!.contactTestBitMask = PhysicsCategory.Bed | PhysicsCategory.Edge
```

That’s all the configuration you need to do. Every time the cat body makes contact with either the bed body or the edge loop body, you’ll get a message.

Now to handle those contact messages. Back in **GameScene.swift**, add this contact delegate protocol method to your class:

```swift
func didBeginContact(contact: SKPhysicsContact) {

  let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

  if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
    print("SUCCESS")
  } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
    print("FAIL")  
  }
}
```

Look at the parameter this method receives—it’s of class `SKPhysicsContact` and tells you a lot about the contacting bodies:

![width=75%](<images/image49.jpg>)

There's no way to guarantee a particular object will be in `bodyA` or `bodyB`. But there are various ways you can find out, such as by checking the body’s category or looking for some property of the body’s node.

This simple game contains only four categories so far, which correspond to the integer values `1`, `2`, `4` and `8`. That makes it simple to check for contact combinations—simply use bitwise `OR` as you did to define the collision and contact bitmasks.

![width=75%](<images/image50.jpg>)

> **Note**: If you feel the ground loosening under your feet when you think about comparing bitmasks, consider reading this short but informative article: [http://en.wikipedia.org/wiki/Mask_(computing)](http://en.wikipedia.org/wiki/Mask_(computing)).

Inside your implementation of `didBeginContact(_:)`, you first add the categories of the two bodies that collided and store the result in `collision`. The two `if` statements check `collision` for the combinations of bodies in which you're interested:

 - If the two contacting bodies are the **cat** and the **bed**, you print out “SUCCESS”.

 - If the two contacting bodies are the **cat** and the **edge**, you print out “FAIL”.

![width=80% bordered](<images/image51.png>)

Build and run the project to verify you've got this working thus far. You'll see a message in the console when the cat makes contact with either the bed or the floor. 

> **Note**: When the cat falls on the ground, you'll see several FAIL messages. That’s because the cat bounces off the ground just a little by default, so it ends up making contact with the ground more than once. You’ll fix this soon.

$[=p=]

## Finishing touches

You’re almost there—you already know when the player should win or lose, so you just need to do something about it.

There are three steps remaining in this chapter:

 - **Add an in-game message**

 - **Handle losing**

 - **Handle winning**

### Adding an in-game message

First, add this new category value to the `PhysicsCategory` structure in **GameScene.swift**:

```swift
static let Label: UInt32 = 0b10000 // 16
```

Next, you need a new custom class; it will inherit from `SKLabelNode`, the built-in Sprite Kit label class, but it will implement some custom behavior.

From Xcode's main menu, select **File/New/File...** and for the file template, choose **iOS/Source/Swift file**. Name the new file **MessageNode.swift** and save it.

$[=s=]

Replace the default code with the following:

```swift
import SpriteKit

class MessageNode: SKLabelNode {
  
  convenience init(message: String) {
	
    self.init(fontNamed: "AvenirNext-Regular")
    
    text = message
    fontSize = 256.0
    fontColor = SKColor.grayColor()
    zPosition = 100
    
    let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
    front.text = message
    front.fontSize = 256.0
    front.fontColor = SKColor.whiteColor()
    front.position = CGPoint(x: -2, y: -2)
    addChild(front)
    
  }
}
```

You add a new `convenience init` that expects a parameter for the text to show onscreen. To initialize the label node, you call another built-in `convenience init` that sets the label with the AvenirNext font.

Next, you set the label's text, font size, color and z-position; you want the text to display over all other scene nodes and 100 is an acceptable value.

To make things a bit more interesting, you add another label as a child to the current one, the second one having a different color and offset by a few points. Essentially, you're creating a poor man's drop-shadow for the text by combining dark and light copies of the message.

Now, to make the message more amusing, add some physics to it by appending the following to the `convenience init` of `MessageNode`:

```swift
physicsBody = SKPhysicsBody(circleOfRadius: 10)
physicsBody!.collisionBitMask = PhysicsCategory.Edge
physicsBody!.categoryBitMask = PhysicsCategory.Label
physicsBody!.restitution = 0.7
```

You create a circular physics body for the label and set it to bounce off of the scene's edge. You also assign it to its own physics category, `PhysicsCategory.Label`.

When you add the label to the scene, it will bounce around until it rests on the "ground", like so:

![width=50%](<images/image50_1.png>)

To make showing an in-game message even easier, add a short utility method to **GameScene.swift**:

```swift
func inGameMessage(text: String) {
  let message = MessageNode(message: text)
  message.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
  addChild(message)
}
```

In this method, you create a new message node and add it at the center of the scene. Once that's done, the physics engine will take care of the rest.

Now you'll add the methods that run the winning and losing sequences, and you'll use `inGameMessage(_:)` from there.

### Losing scenario

First of all, you’re going to add a method to restart the current level. To do that, you’ll simply call `presentScene(_:)` again on the `SKView` of your game, and it will reload the whole scene.

Still in **GameScene.swift**, add this new method:

```swift
func newGame() {
  let scene = GameScene(fileNamed:"GameScene")
  scene!.scaleMode = scaleMode
  view!.presentScene(scene)
}
```

In just a few lines of code, you:

- Create a new instance of `GameScene` out of **GameScene.sks** by using the `init(fileNamed:)` initializer;

- Set the scale mode of the scene to match the scene's current sacale mode;

- Pass the new `GameScene` instance to `presentScene(_:)`, which removes the current scene and replaces it with the shiny new scene.

With all preparations complete, it's time to add the initial version of the `lose` method to **GameScene.swift**:

```swift
func lose() {
  //1
  SKTAudio.sharedInstance().pauseBackgroundMusic()
  runAction(SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false))

  //2
  inGameMessage("Try again...")

  //3
  performSelector(#selector(newGame), withObject: nil, afterDelay: 5)
}
```

With this snippet of code, you do a few things:

1. You play a fun sound effect when the player loses. To make the effect more prominent, you pause the in-game music by calling `pauseBackgroundMusic()` on `SKTAudio`. Then, you run an action to play the effect on the scene.

2. You also spawn a new in-game message that reads, "Try again...", to keep your players motivated. :]

3. Finally, you wait for five seconds and then restart the level by calling `newGame()`.

That’s it for now—locate `didBeginContact(_:)` and add the following line after `print("FAIL")`:

```swift
lose()
```

You now have a working fail sequence. Build and run the project, and give it a try:

![width=67% bordered](<images/image52_1.png>)

Oops! Something isn't quite right, and it's a problem you've noticed before.

As the cat bounces off the floor, it produces numerous contact messages, and since the contact is always between the cat and the scene's edge, you get many calls to your shiny, new `lose()` method.

To prevent this from happening, you need a mechanism to stop in-game interactions once the player has failed or completed the level. This calls for a state machine! 

For Cat Nap, you're going to build a very simple state machine, but don't let that sink your motivation level—you're going to learn much more about building solid game state machines in Chapter 15, "State Machines".

#### A basic state machine

Your Cat Nap state machine will handle two distinct states: when the level is playable, and when the level is inactive. In the latter state, contacts produced by bodies won't have any effect.

Add a new instance variable to your `GameScene` class to hold the state of your level:

```swift
var playable = true
```

The level is playable as soon as it loads and appears onscreen. However, you want the level to become inactive as soon as you call `lose()`, because the player should never be able to lose multiple times without trying again. :]

$[=p=]

Insert the following line at the top of `lose()`:

```swift
playable = false
```

Finally, to prevent more successful contacts, insert the following at the top of `didBeginContact(_:)`:

```swift
if !playable {
  return
}
```

This should suffice for now—your level is playable at launch. Then, as soon as the player fails, it becomes inactive. When the level restarts, it's playable again.

Build and run the program, and test it once more. You've solved the multi-message problem and the game restarts after a few seconds:

![bordered width=75% print](<images/image52_2.png>)
![bordered width=67% screen](<images/image52_2.png>)

Good work—it was an easy fix that introduced you to the importance of handling your game state! 

### Playing an animation

There's something that feels incomplete about this losing sequence—the cat seems emotionless about his grand failure to comfortably sneak in a nap.

It's finally time to put the wake-up animation you designed in Chapter 8, "Scene Editor", to work. 

Remember that you created the wake up action in **CatWakeUp.sks**? To wrap up this section, you're going to show the wake animation when the player fails to solve the level.

$[=p=]

Open **CatNode.swift** and add a new method:

```swift
func wakeUp() {
  // 1
  for child in children {
    child.removeFromParent()
  }
  texture = nil
  color = SKColor.clearColor()
  

  // 2
  let catAwake = SKSpriteNode(fileNamed: "CatWakeUp")!.childNodeWithName("cat_awake")!

  // 3
  catAwake.moveToParent(self)
  catAwake.position = CGPoint(x: -30, y: 100)
}
```

You call this method on the cat node to "wake up" the cat. The method consist of two sections:

1. In the first section, you loop over all of the cat's child nodes—the cat "parts"—and remove them from the cat body. Then you set the current texture to `nil`. Finally, you set the cat's background to a transparent color, which effectively resets the cat to an empty node.

2. In the second section, you load **CatWakeUp.sks** and fetch the scene child named **cat\_awake**. Review the contents of that .sks file, and you'll see that **cat\_awake** is the name of the only sprite found there. This is also the sprite on which the **cat\_wake** action runs. 

3. Finally, you change the sprite's parent from the **CatWakeUp.sks** scene to the `CatNode`. You set the node's position to make sure that it will appear exactly over the existing texture.

> **Note**: I hope you noticed the use of `moveToParent:`. If a sprite already has a parent, you can't use `addChild(_:)` directly to add it elsewhere; `moveToParent(_:)` removes it from its current hierarchy and adds it at the new location you specify.

That's it! Switch back to **GameScene.swift** and add the following at the bottom of `lose()`:

```swift
catNode.wakeUp()
```

$[=p=]

Build and run the project and enjoy your complete sequence:

![bordered width=45% print](<images/image54_1.png>)
![bordered width=50% screen](<images/image54_1.png>)

### Winning scenario

Now that you have a losing sequence, it's only fair to give the player a winning sequence. Add this new method to your `GameScene` class:

```swift
func win() {
  playable = false

  SKTAudio.sharedInstance().pauseBackgroundMusic()
  runAction(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))

  inGameMessage("Nice job!")

  performSelector(#selector(newGame), withObject: nil, afterDelay: 3)
}
```

This code looks almost identical to what you did in `lose()`, with few differences, of course. When you pause the music, you play an uplifting win song and show the rewarding **Nice job!** message.

Just like before, you'll add an extra method in your cat node class to load the winning animation. Open **CatNode.swift** and add the following:

```swift
func curlAt(scenePoint: CGPoint) {
  parent!.physicsBody = nil
  for child in children {
    child.removeFromParent()
  }
  texture = nil
  color = SKColor.clearColor()

  let catCurl = SKSpriteNode(fileNamed: "CatCurl")!.childNodeWithName("cat_curl")!
  catCurl.moveToParent(self)
  catCurl.position = CGPoint(x: -30, y: 100)
}
```

This is exactly the same as `wakeUp()`, with a couple of differences: 

1. You remove the cat's physics body, because you'll animate the cat manually into the bed;
2. You load the happy curl animation from **CatCurl.sks**.

`curlAt(_:)` expects a single `CGPoint` parameter, which is the bed location in the scene's coordinate system. To find the curl point in the cat coordinate system, you need to first convert the location. That's easy thanks to the `convertPoint(_:fromNode:)` API, which converts positions from one node's coordinate system to another node's coordinate system.

Append to the bottom of `curlAt(_:)`:

```swift
var localPoint = parent!.convertPoint(scenePoint, fromNode: scene!)
localPoint.y += frame.size.height/3
```

In the first line, you call `convertPoint(_:fromNode:)` on the cat body's parent—that is, the cat reference you load from the .sks file. You need to work with the body's parent coordinates while the body itself is positioned at those coordinates. Thus, you need the target curl point within a coordinate system in which you can animate the body.

In the second line, you add one third of the cat's height to the curl point, which makes the curl happen toward the bottom of the bed, not in its center.

Finally, add the animation to the cat in `curlAt(:_)` in **CatNode.swift**:

```swift
runAction(SKAction.group([
  SKAction.moveTo(localPoint, duration: 0.66),
  SKAction.rotateToAngle(0, duration: 0.5)
]))
```

This action group animates the cat to the center of the bed, and it also straightens up the cat in case he was falling over.

You've reached the final steps to put everything together. Open **GameScene.swift** and in `win()`, append this line at the bottom:

```swift
catNode.curlAt(bedNode.position)
```

Then, inside `didBeginContact(_:)`, find the `print("SUCCESS")` line and add this line after it:

```swift
win()
```

Build and run the project. You now have a winning sequence in place (pun intended):

![width=75% bordered](<images/image55.png>)

Believe it or not, you’ve completed another mini-game! And this time, your game also has a complete physics simulation. Give yourself a pat on the back.

Don’t be sad that your game has only one level. You’ll continue to work on Cat Nap in the next two chapters, adding two more levels as well as some crazy features before you’re done.


## Challenges

Make sure you aren’t rushing through these chapters. You're learning a lot of new concepts and APIs, so iterating over what you've learned is the key to retaining it. 

That’s one reason why the challenges at the end of each chapter are so important. If you feel confident about everything you’ve covered so far in Cat Nap, move on to the challenge.

This chapter introduced a lot of new APIs, so in case you get stuck, the solutions are in the resources folder for this chapter. But have faith in yourself—you can do it!

### Challenge 1: Count the bounces

Think about the in-game message you show when the player wins or loses the level. Your challenge is to fine-tune when it disappears from the scene.

More specifically, your challenge is to count the number of times the label bounces off the bottom margin of the screen and remove the message on exactly the fourth bounce. Working through this will teach you more about custom node behaviors, and it will be a nice iteration over what you've already learned.

Try implementing the solution on your own, but if you need a little help, follow the directions below.

1. Add a variable in `MessageNode` to keep track of the number of bounces. Also, add a `didBounce()` method that increases the counter and removes the node from its parent on the fourth bounce. 

2. Enable contact detection between the label's physics body and the edge of the screen. To do that you will need to set the `contactTestBitMask` of `MessageNode`.

3. In `didBeginContact(_:)` of your `GameScene` class, add a check for contact between two physics bodies with the categories `PhysicsCategory.Label` and `PhysicsCategory.Edge`. Keep in mind, you need to add this check *before* the line `if !playable {`, because otherwise, your bounce contact messages will fire in vain.

Locate the node body by accessing its `node` property or by looking for the message node; for example:

```swift
let labelNode = (contact.bodyA.categoryBitMask == PhysicsCategory.Label) ? contact.bodyA.node : contact.bodyB.node
```

3. Once you grab the node, you can cast it to a `MessageNode` and call your custom method that increases its bounce counter. Finally, don't forget to add a contact mask to your custom label node, so that it produces contact notifications when it bounces off the scene's edge.

This exercise will get you on the right path to implementing more complicated contact handlers. Imagine the possibilities—all the custom actions you could make happen in a game depending on how many times two bodies touch, or how many bodies of one category touch the edge, and so forth.