# Chapter 9 - Beginning Physics
```metadata
author: "By Marin Todorov"
number: "9"
title: "Chapter 9: Beginning Physics"
section: 2
```

So far, you’ve learned to move sprites by manually positioning them and by running actions. But what if you want to simulate more complex behavior, like a ball bouncing against a wobbly pillar, a chain of dominos falling down or a house of cards collapsing?

You could accomplish the above with plenty of math, but there’s an easier way. Sprite Kit contains a powerful and user-friendly physics engine that will help you move your objects realistically—in ways both simple and complex—without breaking a sweat.

With a physics engine, you can accomplish effects like those you see in many popular iOS games:

-   **Angry Birds** uses a physics engine to simulate what happens when the bird collides with the tower of bricks.

-   **Tiny Wings** uses a physics engine to simulate the bird riding the hills and flying into the air.

-   **Cut the Rope** uses a physics engine to simulate the movement of the ropes and the effect of gravity on the candy.

![width=90%](images/image001.png)

Combing a physics engines with touch controls can give your games a wonderfully realistic dynamism—and as you can see in Angry Birds, sometimes in the name of destruction!

If you like this kind of lifelike behavior and you want to know how to build your own physics-based game, you’re in the right chapter.

Since you'll be playing around with physics—while learning, of course—a playground is the best place to get started. And I don’t mean an actual playground; I mean an Xcode playground, which is perfect for experimenting with code.

In this chapter, you'll take a break to learn Sprite Kit physics basics in a playground. But don't worry - in the next two chapters you'll return to your old friend Cat Nap and integrate the physics engine there.

## Physics in Sprite Kit

Under the hood, Sprite Kit uses a library called Box2D to perform all the physics calculations. Box2D is open-source, full-featured, fast and powerful. A lot of popular games already use Box2D—on the iPhone, Android, BlackBerry, Nintendo DS, Wii, OS X and Windows—so it’s nice to see the library as a part of Sprite Kit.

However, Box2D has two main drawbacks for iOS developers: It's written in C++, and it could stand to be more user-friendly, especially for beginners.

Apple doesn’t expose Box2D directly, instead it abstracts it behind its own API in Sprite Kit. In fact, Box2D is walled so well that Apple could choose to change the physics engine in a later version of iOS, and you wouldn’t even know it.

![width=40%](<images/image003.jpg>)

To make a long story short, in Sprite Kit, you get access to all the power of a super-popular engine, but through a friendly, polished, Apple-style API.

### Physics bodies

For the physics engine to control the movement of one of your sprites, you have to create a **physics body** for the sprite. You can think of a physics body as a rough boundary for your sprite that the engine will use for collision detection.

The illustration below depicts a typical physics body for a sprite. Note that the shape of the physics body doesn't need to match the boundaries of the sprite exactly. Usually, you'll choose a simpler shape to help the collision detection algorithms run faster.

![width=90%](<images/image005.png>)

If you need a more precise shape, you can tell Sprite Kit's physics engine to detect the shape of your sprite by ignoring all transparent parts of the image. This is a good strategy if you want a more lifelike collision between the objects in your game. For the cat, the automatically-detected, transparency-based physics body would look something like this:

![width=30%](<images/image007.png>)

You may be thinking, “Excellent! I’ll just use that all the time.”

Think twice. Before you rush into anything, understand that it takes *much* more processing power to calculate the physics for a complex shape like this one, as compared to a simpler polygonal shape.

Once you set a physics body for your sprite, it will move similarly to how it would in real life: It will fall with gravity, be affected by impulses and forces and move in response to collisions with other objects.

You can adjust the properties of your physics bodies, such as how heavy or bouncy they are. You can also alter the laws of the entire simulated world—for example, you can decrease gravity so that a ball, upon falling to the ground, will bounce higher and travel farther. 

Imagine you throw two balls and each bounces for a while—the red one under normal Earth gravity and the blue one under low gravity, such as on the Moon. It would look something like this:

![width=67%](<images/image009.jpg>)

There are few things you should know about physics bodies:

- **Physics bodies are rigid**. In other words, physics bodies can’t be squished or deformed under pressure and won't change shape as a consequence of the physics simulation. For example, you can't use a physics body to simulate a squishy ball that deforms as it rolls along the floor.

- **Complex physics bodies have a performance cost**. While it may be convenient to use the alpha mask of your images as the physics body, you should only use this feature when absolutely necessary. If you have many shapes onscreen colliding with each other, try using an alpha mask only for your main character or for two to three main characters, and set the rest to rectangles or circles.

- **Physics bodies are moved by forces or impulses**. Impulses, such as the transfer of energy when two physics bodies collide, adjust the object’s momentum immediately. Forces, such as gravity, affect the object gradually over time. You can apply your own forces or impulses to physics bodies, as well—for example, you may use an impulse to simulate firing a bullet from a gun, but use a force to simulate launching a rocket. You’ll learn more about forces and impulses later in this chapter.

Sprite Kit makes all of these features, and many more, incredibly easy to manage. In Apple’s typical manner, most of the configuration is fully pre-defined, meaning a blank Sprite Kit project will already include lifelike physics with absolutely no set up required.

## Getting started

Let's learn about physics in Sprite Kit in the best way possible: by experimenting in real time inside an Xcode playground.

Launch Xcode and from its initial dialogue, select **Get started with a playground**.

![width=67%](<images/image011.png>)

> **Note**: If you previously disabled the startup dialogue, select **File\\New\\Playground…** from the main menu.

In the next dialogue, enter **SpriteKitPhysicsTest** for the **Name** and select **iOS** for the **Platform**.

![width=67%](<images/image013.png>)

Click **Next** and select a location to save the playground.

Xcode will create a new, empty playground, importing only the UIKit framework, so you can use all of the data types, classes and structures you're used to working with in your iOS projects.

The empty playground window will look like this:

![width=90%](<images/image019.png>)

This view may seem a little strange if you haven't used playgrounds before. Don't worry—this next section covers the interface and how to experiment (play!) in a playground.

$[=s=]

> **Note:** If you're already comfortable working in playgrounds, you can skip the next section and move on to "Creating a Sprite Kit playgound".

## Your first playground

In previous chapters, you've worked with Xcode projects, which usually include many source files, resources, storyboards, game scenes and so forth. A playground, on the other hand, is just a single file with a **.playground** extension. 

Playgrounds allow you to experiment with code in real time. But before you do that, it's a good idea to get familiar with the interface.

Take a look at your empty playground window:

![width=85% bordered](<images/image021.png>)

On the left-hand side is the source editor *(1)* and on the right-hand side is the results sidebar *(2)*. As you type code, Xcode evaluates and executes every line and produces the results in the results sidebar, as you'd expect.

For example, if you change “Hello, playground” to “Sprite Kit rules!”, you'll immediately see the results sidebar update to reflect this change. You can experiment with anything you like, but right now give the code below a try:

```swift
let number = 0.4
let string = "Sprite Kit is #\(5-4)"
let numbers = Array(1...5)

var j = 0
for i in 1..<10 {
  j += i*2
}
```

As soon as you paste or type in the code, you'll see the results sidebar update and neatly align the output of every line against the corresponding code in the editor.

The first line of code produces the result you'd expect:

```swift
let number = 0.4
0.4
```

> **Note**: For clarity, we'll display the code line followed by the corresponding result.

This is a static value, so to see the output of an expression, as well as prove the code really gets executed in real time, look at the result of the second line:

```swift
let string = "Sprite Kit is #\(5-4)"
"Sprite Kit is #1"
```

Xcode wraps the result in quotes to show you that the data type of that result is a `String`. The next example shows you the result of an even more elaborate piece of code:

```swift
let numbers = Array(1...5)
[1, 2, 3, 4, 5]
```

The code creates a new array containing `Int` elements with values from 1 to 5.

When you enter an expression like that, on a line by itself, Xcode will evaluate it and send the result to the results sidebar. This is incredibly useful for debugging purposes—rather than use a separate log function as you would in a project, simply write a variable name or an expression, and you'll immediately see its value to the right.

The final example produces a somewhat surprising result—the text **(9 times)**:

```swift
var j = 0
for i in 1..<10 {
    j += i*2
}

(9 times)
```

If you consider everything you’ve learned so far, you might expect this. The result is aligned to the code, so even though the line `j += i*2` is executed nine times in the loop, it can still produce only a single line of text.
The line tells you how many times the loop ran, but that’s far from what would actually be useful to you: to see the values of the variables while the loop runs.

No fear—a playground is smarter than that! Hover with your mouse cursor over the text **(9 times)**. You'll see an extra button appear along with a little tip: 

![width=55%](<images/image023.png>)

Click the **+** button to show the history of the value over the nine loop iterations. This history is displayed directly under the line of code that calculates the value of `j`. Click on the points representing the loop iterations to see the value of your tracked expression in a little pop-up.

![width=80% bordered](<images/image025.png>)

Good work. This is the basic knowledge you need to use an Xcode playground. Now comes the interesting part: conducting physics experiments in a playground.

## Creating a Sprite Kit playground

Delete any code you have in your playground and add these imports at the top:

```swift
import UIKit
import SpriteKit
import XCPlayground
```

These import the basic `UIKit` classes, the Sprite Kit framework and the handy `XCPlayground` module, which will help you visualize your Sprite Kit scene right inside the playground window.

Since you already know how to create a new game scene, you'll do that first.

Make sure Xcode’s assistant editor is open; it usually stays in the right-hand side of the window. To show the assistant editor, select **View/Assistant Editor/Show Assistant Editor** from Xcode’s main menu.

![width=85% bordered](<images/image026.png>)

Now, add the following to your playground’s source code:

```swift
let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))

let scene = SKScene(size: CGSize(width: 480, height: 320))
sceneView.showsFPS = true
sceneView.presentScene(scene)

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = sceneView
```

Most of this code is surely familiar, though you've never seen it in this context. Let's have a look at what you achieve above.

First, you create a new `SKView` instance and give it a frame size of 480 by 320 pixels. Then, you create an empty default `SKScene` instance and give it the same size. This is what the code in your view controllers has been doing for you in the previous chapters of this book.

Next, you tell the `SKView` to present the scene. 

Finally, you call `XCPShowView` from the **XCPlayground** module and pass in a string title and the view. As you can see, `XCPShowView` is quite handy and helps with a few things:

1. First and foremost, it tells Xcode *not* to abort executing your playground as soon as it runs through the source code. In a game prototype, you’d like things to keep running, right? In this case, the playground will continue to run for the default duration of 30 seconds every time you change the source code.

2. It renders the current state of the view in the assistant editor.

3. Finally, it records the view over time so you can rewind, fast forward and skim through the recorded session. You'll see this momentarily.

In the assistant editor, you'll see your game scene:

![width=55% print](<images/image027.png>)
![width=60% screen](<images/image027.png>)

Do you see the frame rate label flickering as it renders different rates? This tells you that the scene is rendering live. Wait until the 30 seconds of execution time are up, and then drag the little slider below the scene left and right. You're dragging through the recorded session—how cool is that?

![width=67%](<images/image029.png>)

Playing with an empty game scene is not so much fun. Fortunately, that’s easy to change! You have a nice, blank slate; your next step is to add sprites to the scene.

Add this code to the playground to create a new sprite with the image **square.png**:

```swift
let square = SKSpriteNode(imageNamed: "square")
```

Hover the mouse over the results sidebar where it reads **SKSpriteNode** and click on the eye icon to see the sprite you just created:

![width=50%](<images/image034.png>)

Oh no! The preview shows a broken image. That's because you didn't add any assets to your playground, and Sprite Kit is letting you know that it couldn't find an image named **square.png**.

From Xcode’s main menu, select **View/Navigators/Show Project Navigator**. Have a look at the file structure of your playground:

![width=50%](<images/image035.png>)

The playground contains two empty folders. The first, **Sources**, contains code you want to pre-compile and make available to your playground, while the second, **Resources**, contains assets you want to use, like images, sounds and so forth.

In the **Resources** folder for this chapter, you'll find a **Shapes** folder that includes all of the artwork you need for your playground. Grab all the files inside **Shapes** and drop them into the **Resources** folder in your playground.

![width=50%](<images/image037.png>)

Excellent! Now, switch back to Xcode and click the eye icon next to your sprite node in the results sidebar. This time, you'll see a blue patterned image. With your assets in place, you're ready to proceed.

Add this code to the end of the file:

```swift
square.name = "shape"
square.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height *
0.50)

let circle = SKSpriteNode(imageNamed: "circle")
circle.name = "shape"
circle.position = CGPoint(x: scene.size.width * 0.50, y: scene.size.height *
0.50)

let triangle = SKSpriteNode(imageNamed: "triangle")
triangle.name = "shape"
triangle.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height *
0.50)
```

This code creates three constants: `square`, `circle` and `triangle`. All of them are sprite nodes, and you initialize them with the textures **square.png**, **circle.png** and **triangle.png**, respectively.

At this point, you can see in the results sidebar that the three sprites have been created successfully, but you still can’t see them onscreen. You need to add them to your scene, so do that with the following code: 

```swift
scene.addChild(square)
scene.addChild(circle)
scene.addChild(triangle)
```

This creates three sprites in the center of the screen: a square, a circle and a triangle. Check them out:

![width=60%](<images/image039.png>)

For the most part, this has been a review of creating sprites and positioning them manually onscreen, although this time, you've done it using a playground. But now it’s time to introduce something new—controlling these objects with physics!

## Circular bodies

Remember two things from earlier in this chapter:

1. For the physics engine to control the movement of a sprite, you must create a **physics body** for the sprite.

2. You can think of a physics body as a rough boundary for your sprite that the physics engine uses for collision detection.

Let's attach a physics body to the circle. Add this at the bottom of the file:

```swift
circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width/2)
```

Since the `circle` sprite uses an image shaped like a circle, it's best to create a physics body of roughly the same shape. `SKPhysicsBody` has a convenience initializer method, `SKPhysicsBody(circleRadius:)`, that creates a circular body. Because you need to supply the radius of the circle, you'll be dividing the width of the circle sprite by 2.

> **Note**: The radius of a circle is the distance from the center of the circle to its edge.

Believe it or not, thanks to Sprite Kit’s pre-configured physics simulation, you're all done!

Once you save your file, the playground will automatically re-execute your code and you'll see the circle drop with gravity:

![width=67%](<images/image041.png>)

But wait a minute—the circle keeps falling offscreen and disappears! Not to mention that by the time the scene is rendered, the circle is almost out of sight—you don’t see much of the fall happen.

The easiest way to fix this is to turn off gravity at the start of your scene and then turn it back on a few seconds later. Yes—you heard me right—turn off gravity!

Skim through your Swift code and find the line where you call `presentScene()` on your `SKView`. Just before this line, add the code to turn off gravity:

```swift
scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
```

Your scene has a property named `physicsWorld` that represents the basic physics setup of your game. When you alter the `gravity` vector of your physics world, you change the constant acceleration that is applied to every physics body in your scene each frame.

As soon as you enter the code to reset gravity to a zero vector, you'll see that now the circle stays at its initial position without falling down. So far, so good.

Now you're going to create a little helper function named `delay`. Since you'll write it once, and not need to re-compile it each time the playground executes, you may put it aside in the **Sources** folder.

The easiest way to add a source file is to right-click on **Sources** and choose **New File** from the pop-up menu.

![width=50%](<images/image042.png>)

Name the newly added file **SupportCode.swift** and then open it in the source editor. Once it's opened, add the following code to it:

```swift
import UIKit

public func delay(seconds seconds: Double, completion:()->()) {
  
  let popTime = dispatch_time(DISPATCH_TIME_NOW,
    Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime,
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
      completion()
  }
}
```

Don't worry too much about this code. All you need to know is that you're using it to delay code execution, something you'll be doing throughout this chapter.

With that done, open the playground again by clicking on **SpriteKitPhysicsTest** in the project navigator, at the top.

Now scroll back down to the end of the code and add the following to re-establish gravity two seconds after the scene is created:

```swift 
delay(seconds: 2.0, completion: {
  scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
})
```

> **Note**: Keep this piece of code at the bottom of the file—all the code you add from here on out, you'll add *just above* it.

Now that you've paused gravity, you'll be able to see the circle shape appear in the assistant editor and then fall under the pull of gravity, two seconds later.

![width=67%](<images/image043.png>)

$[=p=]

> **Note**: While you were editing **SupportCode.swift**, Xcode might have switched the contents of the assistant editor so you won't see the rendered scene. In that case, click on the quick jump bar at the top of the assistant editor and choose **Timeline/SpriteKitPhysicsTest.playground**.

![width=67%](<images/image044.png>)

But that’s still not exactly what you want! For this demo, you want the circle to stop when it hits the bottom of the screen and stay there.

Luckily, Sprite Kit makes this easy to do using something called an **edge loop body**.

## Edge loop bodies

To put bounds around the scene, which is something you'll need to do in many physics-based games, add this line of code just before you present the scene:

```swift
scene.physicsBody = SKPhysicsBody(edgeLoopFromRect: scene.frame)
```

First you set the physics body for the scene itself. Any Sprite Kit node can have a physics body, and remember, a scene is a node, too!

Next, you create a different type of body—an edge loop rather than a circle. There is a major difference between these two types of bodies:

- The circle body is a **dynamic** physics body—that is, it moves. It's solid, has mass and can collide with any other type of physics body. The physics simulation can apply various forces to move volume-based bodies.

- The edge loop body is a **static** physics body—that is, it does not move. As the name implies, an edge loop only defines the edges of a shape. It doesn't have mass, cannot collide with other edge loop bodies and is never moved by the physics simulation. Other objects can be inside or outside its edges.

The most common use for an edge loop body is to define collision areas to describe your game’s boundaries, ground, walls, trigger areas or any other type of unmoving collision space.

Since you want to restrict bodies to movement within the screen's edges, you create the scene’s physics body to be an edge loop with the scene’s `frame CGRect`:

![width=90%](<images/image045.jpg>)

As you saw when Xcode ran your playground, the circle now stops when it hits the bottom of the screen and even bounces a little:

![width=67%](<images/image047.png>)

$[=s=]

## Rectangular bodies

Next, you'll add the physics body for the square sprite. Add the following line to the end of your code:

```swift
square.physicsBody = SKPhysicsBody(rectangleOfSize: square.frame.size)
```

You can see that creating a rectangular physics body is very similar to creating a circular body. The only difference is that instead of passing in the radius of the circle, you pass in a `CGSize` representing the width and height of the rectangle.

Now that it has a physics body attached to it, the square will fall down to the bottom of the scene, too... well, in two seconds, thanks to you having paused gravity—like a boss!

![width=67% print](<images/image049.png>)
![width=55% screen](<images/image049.png>)

## Custom-shaped bodies

Right now, you have two very simple shapes—a circle and a square. What if your shape is more complicated? For example, there's no built-in triangle shape.

You can create arbitrarily-shaped bodies by giving Sprite Kit a **Core Graphics path** that defines the boundary of the body. The easiest way to understand how this works is by looking at an example—so let's try it out with the triangle shape.

Add the following code:

```swift
var trianglePath = CGPathCreateMutable()

CGPathMoveToPoint(trianglePath, nil, -triangle.size.width/2,
-triangle.size.height/2)

CGPathAddLineToPoint(trianglePath, nil, triangle.size.width/2,
-triangle.size.height/2)

CGPathAddLineToPoint(trianglePath, nil, 0, triangle.size.height/2)

CGPathAddLineToPoint(trianglePath, nil, -triangle.size.width/2,
-triangle.size.height/2)

triangle.physicsBody = SKPhysicsBody(polygonFromPath: trianglePath)
```

Let's go through this step by step:

1. First, you create a new `CGMutablePathRef`, which you'll use to plot out the triangle's points.

2. Next, you move your virtual “pen” to the triangle's first point, which in this case is the bottom left, by using `CGPathMoveToPoint()`. Note that the coordinates are relative to the sprite’s anchor point, which by default is its center.

3. You then draw three lines, one to each of the three corners of the triangle, by calling `CGPathAddLineToPoint()`. Note the terms “draw” and “line” do not refer to things you’ll see onscreen—rather, they represent the notion of virtually defining the points and line segments that make up a triangle.

4. Finally, you create the body by passing the `trianglePath` to `SKPhysicsBody(polygonFromPath:)`.

As expected, all three objects fall down when gravity is restored:

![width=67%](<images/image051.png>)

## Visualizing the bodies

Each of the three objects now has a physics body that matches its shape, but at the moment, you can't prove that the physics bodies are indeed different for each sprite.

Before beginning the code for this section, add one more utility function to make your code shorter and easier to read. You’ll need a random function that returns a `CGFloat` value in a given range, so open **Sources/SupportCode.swift** and add the following:

```swift
public func random(min min: CGFloat, max: CGFloat) -> CGFloat {
  return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF)) * (max - min) + min
}
```

> **Note**: You can force the use of an external parameter name by including the external and internal parameter names, separated by a space, as shown here with the `min` parameter. These names don't need to be the same, though they are in this case. Sometimes forcing the parameter name for the first parameter helps to provide a better understanding of the values being passed into the function.

With that done, let's pour particles over the objects to observe their true physical shapes. 

$[=p=]
Return to your playground and add this function *before* your call to `delay(seconds:completion:)`:

```swift
func spawnSand() {
  
  let sand = SKSpriteNode(imageNamed: "sand")
  
  sand.position = CGPoint(
    x: random(min: 0.0, max: scene.size.width),
    y: scene.size.height - sand.size.height)
  
  sand.physicsBody = SKPhysicsBody(circleOfRadius: sand.size.width/2)
  
  sand.name = "sand"
  scene.addChild(sand)
}
```

In this function, you make a small circular body, just like you did before, out of the texture named **sand.png** and position the sprite in a random location at the top of the scene. You also give the sprite the name **sand** for easy access to it later.

Let’s add 100 of these sand particles and see what happens! Modify your call to `delay(seconds:completion:)` by replacing what's there now with this:

```swift
delay(seconds: 2.0) {
  scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
  scene.runAction(
    SKAction.repeatAction(
      SKAction.sequence([
        SKAction.runBlock(spawnSand),
        SKAction.waitForDuration(0.1)
        ]),
      count: 100)
  )
}
```

Finally, some (SK-)action! :]

The new `delay(seconds:completion:)` creates a sequence of actions that calls `spawnSand` and then waits for `0.1` seconds before executing the sequence 100 times on the scene.

When the scene starts rendering in the assistant editor, you'll see a "sand storm" as the 100 sand particles rain down and fill the spaces between the three bodies on the ground:

![width=67%](<images/image053.png>)

Observe how the sand bounces off of the shapes, proving that your shapes indeed have unique bodies.

After 30 seconds of execution, move the recording slider left and right to see the comical action of the sand going up and down and bouncing off the shapes.

Have some fun with that—you've earned it!

## Bodies with complex shapes

The code to create `CGPath` instances is not easy to read, especially if it’s been awhile since you wrote it. In addition, if you have a complex body shape to create, it’s going to be a long and cumbersome process to create the path for it by code.

While it's useful to know how to create bodies out of custom paths, there's a much easier way to handle complex shapes.

Before you begin, there’s one more shape you need to add to your scene, and it looks a bit like a rotated capital letter L:

![width=20%](<images/image059.png>)

Considering the code you wrote to define a triangular path, you probably already realize that the shape above will be painful to put together in code.

Let's use the alpha mask of the image to create the physics body for the sprite. Add this to your code:

```swift
let l = SKSpriteNode(imageNamed:"L")
l.name = "shape"
l.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.75)
l.physicsBody = SKPhysicsBody(texture: l.texture!, size: l.size)
scene.addChild(l)
```

The initializer `SKPhysicsBody(texture:size:)` is the one that lifts the burden from your shoulders and automatically detects the shape of your sprite. It takes two parameters, an `SKTexture` and a `CGSize`.

In the example above, you use the texture of the sprite to generate the physics body for that sprite—but you aren't restricted to using the sprite's texture. If your sprite’s texture has a very complex shape, you can also use a different image with a rough outline of your sprite to improve the performance of your game.

You can also control the size of the created body by adjusting the `size` parameter of `SKPhysicsBody(texture:size:)`.

Look at the scene now, and you'll see that the L shape automatically got a physics body that follows its outline. It conveniently falls onto the circle shape for a strong visual effect:

![width=67%](<images/image061.png>)

I'm sure you're already wondering how would you debug a real game scene with many complex shapes—you can't always have particles raining over your game objects!

Apple to the rescue! 

The Sprite Kit physics engine provides a very convenient feature: an API that enables physics debug output to your live scene. You can see the outlines of your objects, the joints between them, the physics constraints you create and more.

Find the line in your code that enables the frame counter label, `sceneView.showsFPS = true`, and add this line below it:

```swift
sceneView.showsPhysics = true
```

As soon as the scene starts rendering anew, you'll see the shapes of all your bodies drawn in bright green (it may be hard to see in this screenshot but it's there):

![width=67%](<images/image063.png>)

Thanks to this feature, you can do some serious debugging of your physics setup.

## Properties of physics bodies

There’s more to physics bodies than collision detection. A physics body also has several properties you can set, such as, colloquially speaking, slipperiness, bounciness and heaviness.

To see how a body’s properties affect the game physics, you'll adjust the properties for the sand. Right now, the sand falls as though it's very heavy, much like granular rock. What if the pieces were made of soft, elastic rubber?

Add the following line to the end of `spawnSand()`:

```swift
sand.physicsBody!.restitution = 1.0
```

The `restitution` property describes how much energy the body loses when it bounces off of another body—a fancy way of saying "bounciness".

Values can range from `0.0`, where the body does not bounce at all, to `1.0`, where the body bounces with the same force with which it started the collision. The default value is `0.2`.

Oh my! The "sand" goes crazy:

![width=67%](<images/image065.png>)

> **Note**: Sprite Kit sets all properties of physics bodies to *reasonable* values by default. An object’s default weight is based on how big it looks onscreen; `restitution` and `friction` ("slipperiness") default to values matching the material of most everyday objects, and so forth.

One more thing: While valid `restitution` values must be from `0` to `1`, the compiler won’t complain if you supply values outside of that range. However, think about what it would mean for a body to have a `restitution` value greater than `1`, for example. The body would end a collision with *more* energy than it had initially. That’s not realistic behavior and it would quickly break your physics simulation, as the values would grow too large for the physics engine to calculate accurately. It’s not something I’d recommend in a real app, but give it a try if you want to have some fun.

Next, let's make the particles much more dense, so that they're effectively heavier than the other shapes. Given how bouncy they are now, it should be an interesting sight!

Add this line to the end of `spawnSand()`:

```swift
sand.physicsBody!.density = 20.0
```

Density is defined as mass per unit volume—in other words, the higher the density of an object, the heavier it will be for its size. Density defaults to 1.0, so here you set the sand to be 20x as dense as usual.

This results in the sand being heavier than any of the other shapes—in comparison, the other shapes behave as if they're made of styrofoam. After the simulation settles down, you'll end up with something like this onscreen:

![width=67%](<images/image067.png>)

The red particles literally throw their considerable weight around and push the bigger, but lighter, blue shapes aside. When you control the physics, size doesn’t necessarily matter!

Here’s a quick tour of the rest of the properties on a physics body:

- **friction**: This sets an object's “slipperiness”. Values can range from `0.0`, where the body slides smoothly along surfaces like an ice cube, to `1.0`, where the body quickly slows and stops when sliding along surfaces. The default value is `0.2`.

- **dynamic**: Sometimes you want to use physics bodies for collision detection, but move the node yourself with manual movement or actions. If this is what you want, simply set `dynamic` to `false`, and the physics engine will ignore all forces and impulses on the physics body and let you move the node yourself.

- **usesPreciseCollisionDetection**: By default, Sprite Kit doesn't perform precise collision detection, because it's often best to sacrifice some precision to achieve faster performance. However, this has a side effect: If an object is moving very quickly, like a bullet, it might pass through another object. If this ever happens, try turning this flag on to enable more accurate collision detection.

- **allowsRotation**: You might have a sprite you want the physics engine to simulate, but never rotate. If this is the case, simply set this flag to `false`.

- **linearDamping** and **angularDamping**: These values affect how much the linear velocity (translation) or angular velocity (rotation) decrease over time. Values can range from `0.0`, where the speed never decreases, to `1.0`, where the speed decreases immediately. The default value is `0.1`.

- **affectedByGravity**: All objects are affected by gravity by default, but you can turn this off for a body simply by setting this to `false`.

- **resting**: The physics engine has an optimization where objects that haven’t moved in a while are flagged as "resting" so the physics engine doesn't have to perform calculations on them any more. If you ever need to “wake up” a resting object manually, simply set this flag to `false`.

- **mass and area**: These are automatically calculated for you based on the shape and density of the physics body. However, if you ever need to manually override the `mass`, you can. The `area` is read-only.

- **node**: The physics body has a handy pointer back to the `SKNode` to which it belongs. This is a read-only property.

- **categoryBitMask**, **collisionBitMask**, **contactBitMask** and **joints**: You'll learn all about these in Chapter 9, "Intermediate Physics" and Chapter 10, "Advanced Physics".

## Applying an impulse

To wrap up this introduction to physics in Sprite Kit, you’re going to add a special effect to your test scene. Every now and then, you’ll apply an impulse to the particles, making them jump.

The effect will look like a seismic shock that throws everything into the air. Remember, impulses adjust an object’s momentum immediately, like a bullet firing from a gun.

To try it out, add this new method to your playground *before* your call to `delay(seconds:completion:)`:

```swift
func shake() {
  scene.enumerateChildNodesWithName("sand") { node, _ in
    node.physicsBody!.applyImpulse(
      CGVector(dx: 0, dy: random(min: 20, max: 40))
    )
  }
}
```

This function loops over all of the nodes in your scene with the name **sand** and applies an impulse to each of them. You apply an upward impulse by having the `x`-component always equal zero and having a random positive `y`-component between `20` and `40`.

You create the impulse as a `CGVector`, which is just like a `CGPoint` but named so that it's clear it's used as a vector. You then apply the impulse to the anchor point of each particle. Since the strengths of the impulses are random, the shake effect will look pretty realistic.

Of course, you need to call the function before you'll see the particles jump. Locate the call to `delay(seconds:completion:)` and replace it with this one:

```swift
delay(seconds: 2.0) {
  scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
  scene.runAction(
    SKAction.repeatAction(
      SKAction.sequence([
        SKAction.runBlock(spawnSand),
        SKAction.waitForDuration(0.1 )
        ]),
      count: 100)
  )
  delay(seconds: 12, completion: shake)
}
```

You call `shake()` after 12 seconds have passed, giving the scene time to settle down so you can observe the seismic shock.

It’s a bit odd that the shapes don't jump by themselves but are rather “lifted” by the sand particles. Add this code to your `shake()` function to make the shapes jump, too:

```swift
scene.enumerateChildNodesWithName("shape") { node, _ in
  node.physicsBody!.applyImpulse(
	CGVector(dx: random(min:20, max:60),
      dy: random(min:20, max:60))
  )
}

delay(seconds: 3, completion: shake)
```

First, you loop through all the shapes and apply a random vector impulse to each of them. Then, you call `delay(seconds:completion:)` and tell it to call `shake()` again in three seconds.

![width=67%](<images/image071.png>)

Don’t forget to replay those shakes using the scrubber—it’s pretty funny!

Well done. You've covered the basics of Sprite Kit's physics engine, and you're almost ready to put these concepts to use in a real game. But first, it’s time to push yourself to prove all that you've learned so far!

## Challenges

This chapter has two challenges that will get you ready to create your first physics game. You’ll learn about forces and create a dynamic sprite with collision detection.

As always, if you get stuck, you can find the solutions in the resources for this chapter—but do give it your best shot before peeking!

### Challenge 1: Forces

So far, you’ve learned how to make the sand move immediately by applying an impulse. But what if you wanted to make objects move more gradually, over time?

Your first challenge is to simulate a very windy day that will blow your objects back and forth across the screen. Below are some guidelines for how to accomplish this.

First, add these variables:

```swift 
var blowingRight = true
var windForce = CGVector(dx: 50, dy: 0)
```

$[=p=]

Then, add this stub implementation of `update()`:

```
extension SKScene {
  
  // 1
  func windWithTimer(timer: NSTimer) {
	// TODO: apply force to all bodies
  }

  // 2
  func switchWindDirection(timer: NSTimer) {
    blowingRight = !blowingRight
    windForce = CGVector(dx: blowingRight ? 50 : -50, dy: 0)
  }
}

//3
NSTimer.scheduledTimerWithTimeInterval(0.05, target: scene, selector: #selector(SKScene.windWithTimer), userInfo: nil, repeats: true)

NSTimer.scheduledTimerWithTimeInterval(3.0, target: scene, selector: #selector(SKScene.switchWindDirection), userInfo: nil, repeats: true)
```

Let’s go over this section by section:

1. Inside `windWithTimer(_:)`, you enumerate over all sand particles and shape bodies and apply the current `windForce` to each. Look up the method named `applyForce(_:)`, which works in a similar way to `applyImpulse(_:)`, which you already know.

2. Inside `switchWindDirections(_:)`, you simply toggle `blowingRight` and update `windForce`.

3. You declare two timers. The first fires 20 times per second and calls `windWithTimer(_:)` on your scene—this is where you'll apply force to all the bodies. The second timer fires once every three seconds and calls `switchWindDirection(_:)`, where you'll toggle `blowingRight` and adjust the `windForce` vector accordingly.

Remember the difference between forces and impulses: You apply a force every frame while the force is active, but you fire an impulse once and only once.

If you get this working, you'll see the objects slide back and forth across the screen as the wind changes direction:

![width=60% print](<images/image075.png>)
![width=67% screen](<images/image075.png>)

$[=s=]

### Challenge 2: Kinematic bodies

In your games, you might have some sprites you want to move with manual movement or custom actions, and others you want the physics engine to move. But you'll still want collision detection to work on all of these sprites, including the ones you move yourself.

As you learned earlier in this chapter, you can accomplish this by setting the `dynamic` flag on a physics body to `false`. Bodies that you move yourself, but that still have collision detection, are sometimes called **kinematic bodies**.

Your second challenge in this chapter is to try this out for yourself by making the circle sprite move not by the physics engine, but by an `SKAction`. Here are a few hints:

- Set the `dynamic` property of the circle’s physics body to `false` after creating it.

- Create an `SKAction` to move the circle horizontally back and forth across the screen, and make that action repeat forever.

If you get this working, you'll see that everything is affected by the gravity, wind and impulses, except for the circle. However, the objects still collide with the circle as usual:

![width=60% print](<images/image077.png>)
![width=67% screen](<images/image077.png>)

If you made it through both of these challenges, congratulations! You now have a firm grasp of the most important concepts of Sprite Kit's physics engine, and you're 100% ready to put these concepts to use in Cat Nap. Meow! 