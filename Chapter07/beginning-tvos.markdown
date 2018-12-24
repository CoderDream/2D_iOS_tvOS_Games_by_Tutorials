# Chapter 7: Beginning tvOS
```metadata
author: "By Ray Wenderlich"
number: "7"
title: "Chapter 7: Beginning tvOS"
section: 1
```

At this point, Zombie Conga is complete as a Universal app for iPhone and iPad.

"But wait a minute", you may be thinking. "This book is called *2D iOS & tvOS Games by Tutorials*—where in the heck is the tvOS part?!"

![width=65% print](images/001_Zombies.png)

Never fear, that's what this chapter is all about.

In this chapter, you'll port Zombie Conga to the Apple TV. By the time you're done, your game will be running on the big screen!

![bordered width=75% print](images/002_BigScreen.png)

Believe it or not, porting your game is easier than it seems. Sprite Kit works the same on tvOS as it does on iOS, so getting the game to work on tvOS requires only a few simple steps. 

So prepare to bring zombies into your living room—just have your shotgun ready.

> **Note**: This chapter begins where the previous chapter’s Challenge 1 left off. If you were unable to complete the challenge or skipped ahead from an earlier chapter, don’t worry—simply open the starter project from this chapter to pick up in the right place.

## tvOS user input

Before you begin to port Zombie Conga to tvOS, it's important to understand one way developing for tvOS is different from developing for iOS: **user input**.

* **On iOS devices**, you touch the screen directly. 
* **On tvOS devices**, you don't touch the screen directly—after all, we're too busy lazing on the couch! :] Instead, you move your finger on the remote's touchpad.

Since you aren't touching the screen itself on tvOS devices, your touch handlers can't receive exact coordinates of the touch location like they do on iOS. 

Instead, this is what happens on tvOS:

1. When you start touching the remote's touchpad, tvOS calls `touchesBegan()` with coordinates of the center of the scene, regardless of where you began to touch on the touchpad.
2. As you move your finger along the remote's touchpad, tvOS calls `touchesMoved()` with coordinates relative to the previous coordinates, based on how you move your finger. 

If this isn't clear yet, don't worry—the best way to understand how this works is with an example.

## Getting started

Open Xcode and go to **File\New\Project...**. Select the **tvOS\Application\Game** template and click **Next**.

![width=90% bordered](images/003_tvOSGameTemplate.png)

Enter **tvOSTouchTest** for **Product Name**, choose **Swift** for **Language** and choose **SpriteKit** for **Game Technology**. Then, click **Next**.

![width=90% bordered](images/004_tvOSSettings.png)

Choose a directory to save your project and click **Create**. 

You won't be using the Sprite Kit scene editor for this chapter, so delete **GameScene.sks** from your project and choose **Move to Trash**.

Next, open **GameViewController.swift** and replace its contents with the following:

```swift
import UIKit
import SpriteKit

class GameViewController: UIViewController {
  let gameScene = GameScene(size:CGSize(width: 2048, height: 1536))
  
  override func viewDidLoad() {        
    super.viewDidLoad()
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    gameScene.scaleMode = .AspectFill
    skView.presentScene(gameScene)
  }
}
```

This simply creates the `GameScene` of size 2048x1536 and adds it to the `SKView`, just as you did earlier for Zombie Conga.

Next, open `GameScene.swift` and replace its contents with the following:

```swift
import SpriteKit

class GameScene: SKScene {

  // 1
  let pressLabel = SKLabelNode(fontNamed: "Chalkduster")
  // 2
  let touchBox = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 100, height: 100))

  override func didMoveToView(view: SKView) {
    
    // 3
    pressLabel.text = "Move your finger!"
    pressLabel.fontSize = 200
    pressLabel.verticalAlignmentMode = .Center
    pressLabel.horizontalAlignmentMode = .Center
    pressLabel.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(pressLabel)
    
    // 4
    addChild(touchBox)
       
  }
  
  // 5
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      touchBox.position = location
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let location = touch.locationInNode(self)
      touchBox.position = location
    }
  }
}
```

Take a look at what you're doing with this code, section by section:

1. Here you initialize a label node, just as you learned to do in the previous chapter.
2. In addition to creating sprite nodes from images, you can create a sprite node that's a simple color of a specified size. This is often handy for quick tests, like the one you're doing here. In this case, you initialize a sprite that's a 100x100 red box.
3. You set the text of the label to "Move your finger!" and center it on the screen. This is a review from the previous chapter.
4. In your touch handler methods, you simply move the red box to the location the touch handlers report. This will help you visualize what you're receiving for these methods.

Build and run on the Apple TV simulator, and you'll see the following:

![bordered width=70% print](images/005_MoveYourFinger.png)

Next, bring up the Apple TV remote by clicking **Hardware\Show Apple TV Remote** from the simulator's main menu. Click the remote to focus it, then move your mouse over the touchpad area, hold down **Option** and **drag**. You'll start to see a red box moving around the screen, representing the coordinates you're receiving in your touch handler:

![bordered width=70% print](images/006_MovingRemote.png)

> **Note**: If you don't see the red box appear and move around, be sure to hold down Option as you drag your mouse inside the Apple TV remote.

Play around for a bit to see with your own eyes how touches work. As a reminder, here's what's going on:

1. When you start touching the remote's touchpad, tvOS calls `touchesBegan()` with the coordinates of the center of the scene, regardless of where you begin to touch on the touchpad.
2. As you move your finger along the remote's touchpad, tvOS calls `touchesMoved()` with coordinates relative to the previous coordinates, based on how you move your finger. 

Once you're satisfied, keep reading to learn about one more difference in user input on tvOS.

> **Note**: You may have noticed that the input to your touch methods can go outside of the scene's coordinates. This is because the coordinates you receive aren't related to your view or scene, and instead only represent relative movement.

## Button presses

A second difference in user input on tvOS is that the remote has a lot more buttons you might want to use.

Again, the best way to understand this is through a little demo. 

Still in your **tvOSTouchTest** project, open **GameScene.swift** and implement these new methods at the bottom of the file:

```swift
// 1
override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
  for press in presses {
    // 2
    switch press.type {
      case .UpArrow:
        pressLabel.text = "Up arrow"
      case .DownArrow:
        pressLabel.text = "Down arrow"
      case .LeftArrow:
        pressLabel.text = "Left arrow"
      case .RightArrow:
        pressLabel.text = "Right arrow"
      case .Select:
        pressLabel.text = "Select"
      case .Menu:
        pressLabel.text = "Menu"
      case .PlayPause:
        pressLabel.text = "Play/Pause"
    }
  }
}

override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
  // 3
  self.removeAllActions()
  runAction(SKAction.sequence([
    SKAction.waitForDuration(1.0),
    SKAction.runBlock() {
      self.pressLabel.text = ""
    }
  ]))
}
```

Here's what you're doing, section by section:

1. To receive information about button presses in tvOS, you implement the `pressesBegan()` and `pressesEnded()` methods, which are called when you begin and stop pressing a button on the remote, respectively.
2. Each press has a `type` field that indicates which button the user is pressing. Based on the button, you update the label appropriately.
3. You want to clear the label after the user stops pressing a button, but you do so after a delay, giving the player time to see the button they pressed before you remove the label.

At the time of writing, these methods aren't called on an `SKScene` automatically, so you have to route the calls to your scene through your view controller. To do this, open **GameViewController.swift** and implement these two new methods:

```swift
override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {   
  gameScene.pressesBegan(presses, withEvent: event)
}

override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
  gameScene.pressesEnded(presses, withEvent: event)
}
```

These simply forward both calls to your `GameScene`.

Build and run, and tap the play/pause button on the remote to see the label update:

![width=80% bordered](images/007_PlayPause.png)

If you have an Apple TV, try running this app on the actual TV and try to get each type of touch to show up on the label. Here's what to do for each:

1. **Up/down/left/right**: Tap on the appropriate edge of the touchpad.
2. **Select**: Press down on the touchpad.
3. **Menu/PlayPause**: Press the appropriate button on the remote.

> **Note**: At the time of writing, pressing the menu button while debugging can confuse the Apple TV and create a state where you can't move around the main menu. If you have any trouble, just reset your Apple TV.

All right, now that you understand how user input works in tvOS, it's time to apply this to Zombie Conga.

## Adding a tvOS target

Open your ZombieConga project from after you completed the previous chapter's challenge.

Click on your **ZombieConga** project in the project navigator and make sure the **General** tab is selected:

![width=80% bordered](images/008_ZombieCongaProject.png)

So far, there's only one target listed for your project: **ZombieConga**, which builds the project for iOS. To build this project for tvOS, you need to add a tvOS.

> **Note**: If you don't see the list of targets in the left sidebar, click the button just to the left of the General tab to reveal them.

$[=p=]

To add a new target, click the plus (+) button at the bottom-left of the list of targets:

![width=80% bordered](images/009_NewTarget.png)

Just as you did before, select the **tvOS\Application\Game** template and click **Next**:

![width=80% bordered](images/010_tvOSGameTemplate2.png)

Enter **ZombieCongaTV** for **Product Name**, select **Swift** for **Language** and select **Sprite Kit** for **Game Technology**. Then, click **Finish**:

![bordered width=60% print](images/011_tvOSSettings2.png)

You'll see a new target appear in the list, along with a set of files that belong to that target in the project navigator:

![bordered width=85% screen](images/012_TwoTargets.png)

Your goal is to reuse the files from your ZombieConga target in your ZombieCongaTV target. To do this, right-click your ZombieConga project located in the project navigator—it's the blue one at the very top, not the yellow folder—and select **New Group**. Name the group **Shared** and drag the following files from your yellow **ZombieConga** group to Shared:

1. **GLIMSTIC.TTF**
2. The entire **Sounds** group
3. **MainMenuScene.swift**
4. **GameSene.swift**
5. **GameOverScene.swift**
6. **Assets.xcassets**
7. **MyUtils.swift**

$[=p=]

Next, rename **Shared\Assets.xcassets** to **Shared\Game.xcassets**. You need to do this so there's not a name conflict when you share this file with the ZombieCongaTV project.

Now, select all of the files you just added to Shared, including the files in the Sounds group, but not the group itself. Then, in the File Inspector on the right sidebar, click the checkbox for the **ZombieCongaTV** target:

![width=80% bordered](images/013_SharingFiles.png)

This effectively includes all of these files in both targets.

There's just a little cleanup left to do. In your **ZombieCongaTV** group, delete **GameScene.sks**, **GameScene.swift** and **Game.xcassets**, since you either don't need them, or they're already included in the shared files. You can move them to the trash.

Then, open **ZombieCongaTV\Info.plist** and add the same **Fonts provided by application** entry for **GLIMSTIC.TTF** as you did in the previous chapter:

![width=70% bordered](images/014_Glimstic.png)

Finally, open **ZombieCongaTV\GameViewController.swift** and replace the contents with the following:

```swift
import UIKit
import SpriteKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let scene =
      MainMenuScene(size:CGSize(width: 2048, height: 1536))
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
  }
}
```

This is the same initialization code you're using in the iOS version of Zombie Conga.

$[=p=]

In the upper left of Xcode, switch to the **ZombieCongaTV\tvOS Simulator**:

![width=50% bordered](images/015_tvOSSim.png)

That's it—build and run, and enjoy Zombie Conga on the big screen!

![bordered width=70% print](images/016_ZombieCongaTV.png)

Are you wondering how the game works seamlessly with the tvOS resolution? Recall from Chapter 1 that your strategy was to make the art at the biggest possible size and aspect ratio, and downscale it for other devices using Aspect Fill. The Apple TV renders at 1920x1080, so Aspect Fill will scale a 2048x1152 viewable scene size by 0.93 to fit the 1920x1080 screen size. This is the same as the iPhone 6 Plus. :]

> **Note**: At the time of writing this chapter, if you leave Zombie Conga by hitting the home menu on your game then return to the game, sometimes the background sprites will disappear. This appears to be a bug in Sprite Kit on tvOS.

## Fixing the touch handling

At first glance, the controls for Zombie Conga seem to work out-of-the-box. But after playing for awhile, you might notice strange problems with the controls.

To see what I mean, add your old friend, the red touch box, from tvOSTouchTest into Zombie Conga.

Open **GameScene.swift** and add this new property:

```swift
let touchBox = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 100, height: 100))
```

Then, add these lines to the bottom of `didMoveToView()` to add it to the scene:

```swift
touchBox.zPosition = 1000
addChild(touchBox)
```

Finally, add this line to the end of `touchesBegan()`:

```swift
touchBox.position = touchLocation
```

Also, add that same line to the end of `touchesMoved()`:

```swift
touchBox.position = touchLocation
```

Build and run, and try moving around. 

You'll notice that every time you start a new touch, the touch location always reverts back to the center of the screen, which can sometimes make the zombie backtrack or move in unexpected directions.

Since tvOS touches don't map directly to scene coordinates, the best way to fix this is to set the zombie's velocity based on the recent direction of movement of the user's touches.

First, add a new property to `GameScene`:

```swift
var priorTouch: CGPoint = CGPoint.zero
```

$[=s=]

Then, update `touchesBegan()` as follows:

```swift
override func touchesBegan(touches: Set<UITouch>,
  withEvent event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let touchLocation = touch.locationInNode(self)
    touchBox.position = touchLocation
    #if os (tvOS)
      priorTouch = touchLocation
    #else
      sceneTouched(touchLocation)
    #endif
}
```

$[=p=]

This makes it so that on tvOS, rather than calling the old `sceneTouched()` method, you simply store the touch location—that is, the center of the scene, where it begins—in `priorTouch`.

Next, update `touchesMoved()` as follows:

```swift
override func touchesMoved(touches: Set<UITouch>,
  withEvent event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let touchLocation = touch.locationInNode(self)
    #if os (tvOS)
      // 1
      let offset = touchLocation - priorTouch
      let direction = offset.normalized()
      velocity = direction * zombieMovePointsPerSec
      
      // 2
      priorTouch = (priorTouch * 0.75) + (touchLocation * 0.25)
      
      // 3
      touchBox.position = zombie.position + (direction*200)        
    #else
      touchBox.position = touchLocation
      sceneTouched(touchLocation)
    #endif
}
```

Once again, let's review this section by section:

1. This sets the velocity based on the direction between the current touch and `priorTouch`, rather than trying to move toward a particular point on the screen.
2. You don't want to set `priorTouch` to `touchLocation` directly, because you'd get a lot of noise from minute finger movements. Instead, use a blend: 75% of the previous `priorTouch` and 25% of the new `touchLocation`. 
3. Update the touchBox to help visualize the current direction of movement.

Build and run, and you'll see the zombie's movement is much improved!

![width=80%](images/017_UnderCommand.png)

$[=p=]

Now that this is working, turn off the red box by adding this to the end of `didMoveToView()`:

```swift
touchBox.hidden = true
```

## Top-shelf image and 3D icons

The gameplay for Zombie Conga is complete, so it's time to polish it up by adding a tvOS top-shelf image, launch image and 3D icon.

Open **ZombieCongaTV\Assets.xcassets** and expand the **Launch Image**.

In the resources for this chapter, you'll find a folder named **LaunchImage**; copy the image from this folder into this slot.

Still in **Assets.xcassets**, expand the **Top Shelf Image** and drag the file from the **resources\Top Shelf Image** into this slot. 

Next, open **App Icon - Large** in **Assets.xcassets** and make sure the Attributes Inspector is open. In the Layers box, click the **+** button two more times so there are five layers in total:

![width=90% bordered](images/018_5Layers.png)

The layers are ordered from frontmost to backmost. Drag the files from **resources\App Icon - Large** into each slot from top to bottom:

![width=90% bordered](images/019_3DImage.png)

You can drag your mouse around and see a preview of the 3D image—cool!

Repeat this same process to set up the **App Icon - Small**.

Finally, open **ZombieCongaTV\Info.plist** and set the **Bundle name** to **Zombie Conga** so that it looks nice on the home screen of the Apple TV.

Build and run, and press the menu button to see the Apple TV home screen. Now Zombie Conga's got style!

![width=90% bordered](images/020_Style.png)

Congratulations, you've made your first complete iOS and tvOS game! There's no challenge this time, so you can take a well-deserved break.

When you come back, there are new iOS and tvOS games waiting for you to make! :]