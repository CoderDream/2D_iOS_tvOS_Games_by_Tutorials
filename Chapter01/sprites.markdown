# Chapter 1: Sprites
```metadata
author: "By Ray Wenderlich"
number: "1"
title: "Chapter 1: Sprites"
section: 1
```

Now that you know what Sprite Kit is and why you should use it, it’s time to try it out for yourself!

The first minigame you will build in this book is called Zombie Conga. Here’s what it will look like when you’re finished:
![width=80%](/images/001_FinalGame.png)

In Zombie Conga, you take the role of a happy-go-lucky zombie who wants to party! 

Luckily, the beach town you occupy has an overly abundant cat population. You simply need to bite them and they’ll join your zombie conga line.

But watch out for crazy cat ladies! These wizened warriors in red dresses won’t take kindly to anyone stealing their beloved cats and will do their best to make the zombie rest in peace—permanently. 

You will build this game across the next seven chapters, in stages:

1. **Chapter 1, Sprites**: You are here! Get started by adding your first sprites to the game: the background and the zombie. 

2. **Chapter 2, Manual Movement**: You’ll make the zombie follow your touches around the screen and get a crash-course in basic 2D vector math.

3. **Chapter 3, Actions**: You’ll add cats and crazy cat ladies to the game, as well as basic collision detection and gameplay.

4. **Chapter 4, Scenes**: You’ll add a main menu to the game, as well as win and lose scenes.

5. **Chapter 5, Camera**: You’ll make the game scroll from left to right, and finally, add the conga line itself.

6. **Chapter 6, Labels**: You'll add a label to show the zombie's lives and the number of cats in his conga line.

7. **Chapter 7, Beginning tvOS**: You'll get Zombie Conga working on tvOS, in just a few simple steps!

Let’s get this conga started!

## Getting started

Start Xcode and select **File\New\Project...** from the main menu. Select the **iOS\Application\Game** template and click **Next**.

![bordered width=60% print](/images/002_NewProject.png)
![bordered width=80% screen](/images/002_NewProject.png)

Enter **ZombieConga** for the Product Name, choose **Swift** for Language, **SpriteKit** for Game Technology, **Universal** for Devices and click **Next**. 

![bordered width=60% print](/images/003_Options.png)
![bordered width=80% screen](/images/003_Options.png)


Select somewhere on your hard drive to save your project and click **Create**. At this point, Xcode will generate a simple Sprite Kit starter project for you. 

Take a look at what Sprite Kit made. In Xcode’s toolbar, select the iPhone 6 and click **Play**.
![width=70% bordered](/images/004_Play.png)

After a brief splash screen, you’ll see a single label that says, “Hello, World!” When you click on the screen, a rotating space ship will appear.
![iphone bordered](/images/005_HelloWorld.png)

In Sprite Kit, a single object called a scene controls each “screen” of your app. A scene is a subclass of Sprite Kit’s `SKScene` class.

Right now this app just has a single scene, `GameScene`. Open **GameScene.swift** and you’ll see the code that displays the label and the rotating space ship. It’s not important to understand this code quite yet—you’re going to remove it all and build your game one step at a time.

For now, delete everything in **GameScene.swift** and replace it with the following:

```swift
import SpriteKit

class GameScene: SKScene {
  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.blackColor()
  }
}
```

`didMoveToView()` is the method that Sprite Kit calls before it presents your scene in a view; it’s a good place to do some initial setup of your scene’s contents. Here, you simply set the background color to black.

Zombie Conga is designed to run in landscape mode, so let’s configure the app for this. Select the **ZombieConga** project in the project navigator and then select the **ZombieConga** target. Go to the **General** tab and make sure only **Landscape Left** and **Landscape Right** are checked:
![width=95% bordered](/images/006_Landscape.png)

You also need to modify this in one more spot. Open **Info.plist** and find the **Supported interface orientations (iPad)** entry. Delete the entries for **Portrait (bottom home button)** and **Portrait (top home button)** that you see there, so only the landscape options remain.
![width=95% bordered](/images/007_Landscape2.png)

The Sprite Kit template automatically creates a file named **GameScene.sks**. You can edit this file with Xcode’s built-in scene editor to lay out your game scene visually. Think of the scene editor as a simple Interface Builder for Sprite Kit.

You’ll learn all about the scene editor in Chapter 7, “Scene Editor”, but you won’t be using it for Zombie Conga, as it will be easier and more instructive to create the sprites programmatically instead. 

So, control-click **GameScene.sks**, select **Delete** and then select **Move to Trash**. Since you’re no longer using this file, you’ll have to modify the template code appropriately.

Open **GameViewController.swift** and replace the contents with the following:

```swift
import UIKit
import SpriteKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let scene = 
      GameScene(size:CGSize(width: 2048, height: 1536))
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
  } 
  override func prefersStatusBarHidden() -> Bool  {
    return true
  }
}
```

Previously, the view controller loaded the scene from **GameScene.sks**, but now it creates the scene by calling an initializer on `GameScene` instead.

Notice that when you create the scene, you pass in a hardcoded size of **2048x1536** and set the scale mode to `AspectFill`. This is a good time for a quick discussion about how this game is designed to work as a universal app.

### Universal app support

> **Note**: This section is optional and for those who are especially curious. If you’re eager to get coding as soon as possible, feel free to skip to the next section, “Adding the art”.

We’ve designed all the games in this book as universal apps, which means they will work on the iPhone and the iPad. 

The scenes for the games in this book have been designed with a base size of 2048x1536, or reversed for portrait orientation, with the scale mode set to aspect fill. Aspect fill instructs Sprite Kit to scale the scene’s content to fill the entire screen, even if Sprite Kit needs to cut off some of the content to do so.  

This results in your scene appearing as-is on the iPad Retina, which has a resolution of 2048x1536, but as scaled/cropped on the iPhone to fit the phone’s smaller size and different aspect ratio.

Here are a few examples of how the games in this book will look in landscape orientation on different devices, moving from smallest to largest aspect ratio: 
![width=100%](/images/008_SceneSizes.jpg)

* **iPad Retina [4:3 or 1.33]**: Displayed as-is to fit the 2048x1536 screen size.
* **iPad Non-Retina [4:3 or 1.33]**: Aspect fill will scale a 2048x1536 visible area by 0.5 to fit the 1024x768 screen.
* **iPhone 4S [3:2 or 1.5]**: Aspect fill will scale a 2048x1366 visible area by 0.47 to fit the 960x640 screen.
* **iPhone 5 [16:9 or 1.77]**: Aspect fill will scale a 2048x1152 visible area by 0.56 to fit the 1136x640 screen.
* **iPhone 6 [16:9 or 1.77]**: Aspect fill will scale a 2048x1152 visible area by 0.64 to fit the 1334x750 screen. 
* **iPhone 6 Plus [16:9 or 1.77]**: Aspect fill will scale a 2048x1152 visible area by 0.93 to fit the 1920x1080 screen.

Since aspect fill will crop the scene on the top and bottom for iPhones, we’ve designed the games in this book to have a main “playable area” that is guaranteed to be visible on all devices. Basically, the games will have a 192-pixel margin on the top/bottom in landscape and the left/right in portrait, in which you should avoid putting essential content. We’ll show you how to visualize this later in the book.

Note that you need only one set of art for this to work: the art to fit the maximum screen size, 2048x1536. The art will be downscaled on devices other than the iPad Retina.

> **Note**: The con of this approach is that the art will be bigger than necessary for some devices, such as the iPhone 4s, thereby wasting texture memory and space. The pro of this approach is that the game stays nice and simple and works well on all devices.
>
> An alternate approach would be to add different images for each device and scale factor (i.e. iPad @1x, iPad @2x, iPhone@2x, iPhone @3x), leveraging the power of Apple's asset catalogs. However, at the time of writing this chapter, Sprite Kit does not properly load the correct image from the asset catalog based on device and scale factor in all cases, so we will stay with this simple route for now.

### Adding the art

Next, you need to add the game art to the project.

In Xcode, open **Assets.xcassets**, select the **Spaceship** entry and press your delete key to remove it— unfortunately, this is not a game about space zombies! ☺ At this point, only **AppIcon** will remain:

![width=100% bordered](/images/009_NoSpaceship.png)

$[=p=]

With **AppIcon** selected, drag the appropriate icon from **starter\resources\icons** into each slot:

![width=80% bordered](/images/010_Icons.png)

Then drag all of the files from **starter\resources\images** into the left sidebar:
![width=80% bordered](/images/011_DraggingImages.png)

By including your images in the asset catalog, behind the scenes Xcode will build **texture atlases** containing these images and use them in your game, which will automatically increase performance. 

$[===]

### Launch screen

> **Note**: This is another optional section, as it won’t have any impact on gameplay; you'll simply add a “nice-to-have” feature that you’d typically want in a game. If you'd rather get straight to coding, feel free to skip to the next section, “Displaying a sprite”.

There's one last thing you should do to get this game started on the right foot: configure the launch screen.

The launch screen is what iOS displays when your app is first loading, which usually takes a few seconds. A launch image gives the player the impression that your app is starting quickly—the default black screen, needless to say, does not. For Zombie Conga, you’ll show a splash screen with the name of the game.

Your app actually has a launch screen already. When you launched your app earlier, you may have noticed a brief, blank white screen. That was it! 

In iOS, apps have a special **launch screen** file; this is basically a storyboard, LaunchScreen.storyboard in this project, that you can configure to present something onscreen while your app is loading. The advantage of this over the old method of just displaying an image is that you can use Auto Layout to have much finer control of how this screen looks on different devices.

Let’s try this out. Open **LaunchScreen.storyboard**. You'll see the following:
![width=50%](/images/012_LaunchScreen.png)

$[=p=]

In the Object Library on the right sidebar, drag an image view into the view and resize it to fill the entire area:
![width=80% bordered](/images/013_ImageView.png)

Next, you need to set the image view so that it always has the same width and height as its containing view. To do this, make sure the image view is selected and then click the **Pin** button in the lower right—it looks like a tie fighter. In the Add New Constraints screen, click the four light-red lines so that the image view is pinned to each edge. Make sure that **Constrain to margins** isn't checked and that all values are set to 0, then click **Add 4 Constraints**:
![width=40% bordered](/images/014_NewConstraints.png)

With the image view still selected, make sure the Attributes Inspector is selected—it's the fourth tab on the right. Set the **Image** to **MainMenu** and set the **View Mode** to **Aspect Fill**: 
![width=95% bordered](/images/015_AspectFill.png)

Build and run your app again. This time, you'll see a brief Zombie Conga splash screen:
![iphone-landscape bordered](/images/016_SplashScreen.png)

Which is quickly followed by a (mostly) blank, black screen:
![iphone-landscape bordered](/images/017_60FPS.png)

This may not look like much, but you now have a starting point upon which to build your first Sprite Kit game.

Let’s move on to the next task, which also happens to be one of the most important and common when making games: displaying an image on the screen.

## Displaying a sprite

When making a 2D game, you usually put images on the screen representing your game’s various elements: the hero, enemies, bullets and so on. Each of these images is called a **sprite**.
![width=100%](/images/018_Sprites.png)

Sprite Kit has a special class called `SKSpriteNode` that makes it easy to create and work with sprites. This is what you’ll use to add all your sprites to the game. Let’s give it a try.

### Creating a sprite

Open **GameScene.swift** and add this line to `didMoveToView()`, right after you set the background color:

```swift
let background = SKSpriteNode(imageNamed: "background1")
```

You don’t need to pass the image’s extension, as Sprite Kit will automatically determine that for you.

Build and run, ignoring the warning for now. Ah, you thought it was simple, but at this point you still see a blank screen—what gives?

$[=p=]

### Adding a sprite to the scene

It actually is simple. It’s just that a sprite won't show up onscreen until you add it as a child of the scene, or as one of the scene’s descendent **nodes**.

To do this, add this line of code right after the previous line:

```swift
addChild(background)
```

You’ll learn about nodes and scenes later. For now, build and run again, and you’ll see part of the background appear in the bottom left of the screen:
![iphone-landscape bordered](/images/019_BottomLeft.png)

Obviously, that’s not quite what you want. To get the background in the correct spot, you have to set its position.

### Positioning a sprite

By default, Sprite Kit positions sprites at (0, 0), which in Sprite Kit represents the bottom left. Note that this is different from the UIKit coordinate system in iOS, where (0, 0) represents the top left.

Try positioning the background somewhere else by setting the position property. Add this line of code right before calling `addChild(background)`:

```swift
background.position = CGPoint(x: size.width/2, y: size.height/2)
```

Here you set the background to the center of the screen. Even though this is a single line of code, there are four important things to understand:

1. The type of the position property is `CGPoint`, which is a simple structure that has `x` and `y` components:

```
struct CGPoint {
  var x: CGFloat
  var y: CGFloat
}
```

2. You can easily create a new `CGPoint` with the initializer shown above. 

3. Since you’re writing this code in an `SKScene` subclass, you can access the size of the scene at any time with the `size` property. The `size` property’s type is `CGSize`, which is a simple structure like `CGPoint` that has width and height components.

```
struct CGSize {
  var width: CGFloat
  var height: CGFloat
}
```

4. A sprite’s position is within the coordinate space of its parent node, which in this case is the scene itself. You’ll learn more about this in Chapter 5, “Camera”.

Build and run, and now your background is fully visible:
![iphone-landscape bordered](/images/020_Background.png)

> **Note**: You may notice you can’t see the entire background on iPhone devices—parts of it overlap on the top and bottom. This is by design, so the game works on both the iPad and the iPhone, as discussed in the "Universal app support" section earlier in this chapter.

### Setting a sprite’s anchor point

Setting the position of the background sprite means setting the *center* of the sprite to that position. 

This explains why you could only see the upper half of the sprite earlier. Before you set the position, it defaulted to (0, 0), which placed the center of the sprite in the lower-left corner of the screen, so you could only see the top half.

You can change this behavior by setting a sprite’s anchor point. Think of the anchor point as “the spot within a sprite that you pin to a particular position”. Here's an illustration showing a sprite positioned at the center of the screen, but with different anchor points:
![width=100%](/images/021_AnchorPoints.png)
 
To see how this works, find the line that sets the background’s position to the center of the screen and replace it with the following:

```swift
background.anchorPoint = CGPoint.zero
background.position = CGPoint.zero
```

`CGPoint.zero` is a handy shortcut for (0, 0). Here, you set the anchor point of the sprite to (0, 0) to pin the lower-left corner of the sprite to whatever position you set—in this case, also (0, 0).

Build and run, and the image is still in the right spot:
![iphone-landscape bordered](/images/020_Background.png)

This works because now you're pinning the lower-left corner of the background image to the lower-left corner of the scene. 

Here you changed the anchor point of the background for learning purposes. However, usually you can leave the anchor point at its default of (0.5, 0.5), unless you have a specific need to rotate the sprite around a particular point—an example of which is described in the next section.

So, in short: when you set the position of a sprite, by default you are positioning the center of the sprite.

$[===]

### Rotating a sprite

To rotate a sprite, you simply set its `zRotation` property. Try it out on the background sprite by adding this line right before the call to `addChild()`:

```swift
background.zRotation = CGFloat(M_PI) / 8
```

Rotation values are in radians, which are units used to measure angles. This example rotates the sprite `π` / 8 radians, which is equal to 22.5 degrees. Also notice that you convert `M_PI`, which is a `Double`, into a `CGFloat`. You do this because `zRotation` requires a `CGFloat` and Swift doesn’t automatically convert between types like some other languages do.

> Note: I don’t know about you, but I find it easier to think about rotations in degrees rather than in radians. Later in the book, you’ll create helper routines to convert between degrees and radians.

Build and run, and check out your rotated background sprite:
![iphone-landscape bordered](/images/022_RotatedBg.png)

This demonstrates an important point: Sprites are rotated about their anchor points. Since you set this sprite’s anchor point to (0, 0), it rotates around its bottom-left corner.

> Note: Remember that on the iPhone, the bottom-left of this image is actually offscreen! If you’re not sure why this is, refer back to the "Universal app support" section earlier in this chapter.

Try rotating the sprite around the center instead. Replace the lines that set the position and anchor point with these:

```swift
background.position = CGPoint(x: size.width/2, y: size.height/2)
background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
```

Build and run, and this time the background sprite will have rotated about the center:
![iphone-landscape bordered](/images/023_RotatedBg2.png)
 
This is all good to know! But for Zombie Conga, you don’t want a rotated background, so comment out that line:

```swift
// background.zRotation = CGFloat(M_PI) / 8
```

If you’re wondering when you might want to change the anchor point in a game, imagine you’re creating a character’s body out of different sprites—one each for the head, torso, left arm, right arm, left leg and right leg:

![width=70%](/images/024_Mouse.png)
 
If you wanted to rotate these body parts at their joints, you’d have to modify the anchor point for each sprite, as shown in the diagram above.

But again, usually you should leave the anchor point at default unless you have a specific need, like the one shown here.

$[=p=]

### Getting the size of a sprite

Sometimes when you’re working with a sprite, you want to know how big it is. A sprite’s size defaults to the size of the image. In Sprite Kit, the class representing this image is called a texture.

Add these lines after the call to `addChild()` to get the size of the background and log it to the console:

```swift
let mySize = background.size
print("Size: \(mySize)")
```

Build and run, and in your console output, you'll see something like this:

```
Size: (2048.0, 1536.0)
```

Sometimes it’s useful to get the size of a sprite programmatically, as you do above, instead of hard-coding numbers. Your code will be much more robust and adaptable for it.

### Sprites and nodes

Earlier, you learned that to make a sprite appear onscreen, you need to add it as a child of the scene, or as one of the scene’s descendent **nodes**. This section will delve more deeply into the concept of nodes.

Everything that appears on the screen in Sprite Kit derives from a class called `SKNode`. Both the scene class (`SKScene`) and the sprite class (`SKSpriteNode`) derive from `SKNode`. 
![width=50%](images/025_NodeHierarchy.png)
 
`SKSpriteNode` inherits a lot of its capabilities from `SKNode`. It turns out that the position and rotation properties are derived from `SKNode` rather than being particular to `SKSpriteNode`. This means that, just as you can set the position or rotation of a sprite, you can do the same thing with the scene itself or with anything else that derives from `SKNode`. 

You can think of everything that appears on the screen together as a graph of nodes, often referred to as a **scene graph**. Here’s an example of what such a graph might look like for Zombie Conga if there were one zombie, two cats and one crazy cat lady in the game:
![width=100%](images/026_SceneGraph.png)

You’ll learn more about nodes and the neat things you can do with them in Chapter 5, "Camera”. For now, you’ll add your sprites as direct children of the scene.

### Nodes and z-position

Every node has a property you can set called `zPosition`, which defaults to 0. Each node draws its child nodes in the order of their z-position, from lowest to highest.

Earlier in this chapter, you added this line to **GameViewController.swift**:

```swift
skView.ignoresSiblingOrder = true
```

* **If ignoresSiblingOrder is true**, Sprite Kit makes no guarantees as to the order in which it draws each node’s children with the same `zPosition`. 
* **If ignoresSiblingOrder is false**, Sprite Kit will draw each node’s children with the same `zPosition` in the order in which they were added to their parent. 

In general, it’s good to set this property to true, because it allows Sprite Kit to perform optimizations under the hood to make your game run faster.

However, setting this property to `true` can cause problems if you’re not careful. For example, if you were to add a zombie to this scene at the same `zPosition` as the background—which would happen if you left them at the default position of 0—Sprite Kit might draw the background on top of the zombie, covering the zombie from the player’s view. And if zombies are scary, just imagine invisible ones!

To avoid this, you’ll set the background’s `zPosition` to -1. This way, Sprite Kit will draw it before anything else you add to the scene, which will default to a `zPosition` of 0. 

In **GameScene.swift**, add this line right before the call to `addChild()`:

```swift
background.zPosition = -1
```

Phew! No invisible zombies.

### Finishing touches

That’s it for this chapter! As you can see, adding a sprite to a scene takes only three or four lines of code:

1. Create the sprite.
2. Position the sprite.
3. Optionally set its z-position.
4. Add the sprite to the scene graph.

Now it’s time for you to test your newfound knowledge by adding the zombie to the scene.

## Challenges

It’s important for you to practice what you’ve learned, on your own, so each chapter in this book has one to three challenges, progressing from easy to hard.

I highly recommend giving all the challenges a try, because while following a step-by-step tutorial is educational, you’ll learn a lot more by solving a problem by yourself. In addition, each chapter will continue where the previous chapter’s challenges left off, so you'll want to stay in the loop!

If you get stuck, you can find solutions in the resources for this chapter—but to get the most from this book, give these your best shot before you look!

### Challenge 1: Adding the zombie

Right now, your game has a nice background, but it’s missing the star of the show. As your first challenge, you can give your zombie a grand entrance.

Here are a few hints:

* Inside `GameScene`, add a constant property named `zombie` of type `SKSpriteNode`. Initialize it with the image named **zombie1**. 
* Inside `didMoveToView()`, position the zombie sprite at (400, 400).
* Also inside `didMoveToView()`, add the zombie to the scene.

If you’ve got it right, you'll see the zombie appear onscreen like so:
![iphone-landscape bordered](/images/027_Zombie.png)
 
Run your game on the iPad Air 2 simulator to prove it works there, as well—just with a bigger viewable area! 
![ipad-landscape bordered](/images/028_iPad.png)
 
### Challenge 2: Further documentation

This chapter covers everything you need to know about sprites and nodes to keep working on the game.

However, it’s good to know where to find more information in case you ever have questions or get stuck. I highly recommend you check out Apple’s *SKNode Class Reference* and *SKSpriteNode Class Reference*, as these cover the two classes you’ll use most often in Sprite Kit, and it’s good to have a basic familiarity with the properties and methods they contain.

You can find the references in Xcode by selecting **Help\Documentation and API Reference** from the main menu and searching for `SKNode` or `SKSpriteNode`. 
![width=95% bordered](/images/029_Documentation.png)

And now for your second challenge: Use the information in these docs to double (scale to 2x) the zombie’s size. Answer this question: Did you use a method of `SKSpriteNode` or `SKNode` to do this?


