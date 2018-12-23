# Chapter 6: Labels
```metadata
author: "By Ray Wenderlich"
number: "6"
title: "Chapter 6: Labels"
section: 1
```

It's often useful in games to display text to keep your player informed. For example, currently in Zombie Conga, there's no indication of how many lives you have remaining—which can be quite frustrating if you die unexpectedly!

In this chapter, you'll learn how to display fonts and text within your game. Specifically, you'll add two labels to Zombie Conga: one to display your current lives and one to display your count of cats.

![width=70% bordered](images/001_Finished.png)

> **Note**: This chapter begins where the previous chapter’s Challenge 1 left off. If you were unable to complete the challenge or skipped ahead from an earlier chapter, don’t worry—simply open the starter project from this chapter to pick up where the previous chapter left off.

$[=s=]

## Built-in fonts and font families

In iOS, fonts are broken into sets named "families". A font "family" consists of variants of the same font—such as lighter or heavier versions of the font—which may be useful in different situations.

For example, the "Thonburi" font family contains of three fonts:

1. **Thonburi-Light**: A thin/light version of the font.
2. **Thonburi**: A standard version of the font.
3. **Thonburi-Bold**: A bold version of the font.

Some font families have even more variants; the "Avenir" family has 12!

iOS ships with a number of built-in font families and fonts, so before you start using labels, you need to know what's available to you. To find out, you'll create a simple Sprite Kit project that lets you see these different fonts at a glance.

Create a new project in Xcode by selecting **File\New\Project...** from the main menu. Select the **iOS\Application\Game** template and click **Next**.

Enter **AvailableFonts** for the Product Name, select **Swift** as the language, **SpriteKit** as the Game Technology, **Universal** for Devices and then click **Next**.

Select a location on your hard drive to store the project and click **Create**. You now have a simple Sprite Kit project open in Xcode that you'll use to list the font families and fonts available in iOS.

You want this app to run in portrait mode, so select the **AvailableFonts** project in the project navigator and then select the **AvailableFonts** target. Go to the General tab, check **Portrait** and uncheck all other orientations.

Just like in Zombie Conga, you'll be creating this scene programmatically rather than using the scene editor. To do this, select **GameScene.sks** and delete it from your project. Then, open **GameViewController.swift** and replace the contents with the following:

```swift
import UIKit
import SpriteKit

class GameViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let scene = 
      GameScene(size:CGSize(width: 2048, height: 1536))
    let skView = self.view as! SKView
    skView.showsFPS = false
    skView.showsNodeCount = false
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
  } 

  override func prefersStatusBarHidden() -> Bool  {
    return true
  }
}
```

This is the same code you used in Zombie Conga; it simply creates and presents `GameScene` to the screen.

It's time to add that code. Open **GameScene.swift** and replace its contents with the following:

```swift
import SpriteKit

class GameScene: SKScene {
  
  var familyIdx: Int = 0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(size: CGSize) {
    super.init(size: size)
    showCurrentFamily()
  }
  
  func showCurrentFamily() {
    // TODO: Coming soon...
  }
  
  override func touchesBegan(touches: Set<UITouch>,
    withEvent event: UIEvent?) {
      familyIdx++
      if familyIdx >= UIFont.familyNames().count {
        familyIdx = 0
      }
      showCurrentFamily()
  } 
}
```

You begin by displaying the font family with index 0. Every time the user taps, you advance to display the next font family name. In iOS, you can get a list of the built-in font family names by calling `UIFont.familyNames()`.

$[=p=]

The code to display the fonts in the current font family will be in `showCurrentFamily()`, so implement that now by placing the following code inside that method:

```swift
// 1
removeAllChildren()

// 2
let familyName = UIFont.familyNames()[familyIdx] 
print("Family: \(familyName)")

// 3
let fontNames = 
  UIFont.fontNamesForFamilyName(familyName) 
    
// 4
for (idx, fontName) in fontNames.enumerate() {
  let label = SKLabelNode(fontNamed: fontName)
  label.text = fontName
  label.position = CGPoint(
    x: size.width / 2,
    y: (size.height * (CGFloat(idx+1))) /
      (CGFloat(fontNames.count)+1))
  label.fontSize = 50
  label.verticalAlignmentMode = .Center
  addChild(label)
}
```

OK! Let's review this code section by section:

1. You remove all of the children from the scene so that you start with a blank slate.

2. You get the current family name based on the index that you increment with each tap. You also log out the family name, in case you're curious about it.

3. `UIFont` has another helper method to get the names of the fonts within a family, named `fontNamesForFamilyName()`. You call this here and store the results.

4. You then loop through the block and create a label using each font; the text of each label displays the name of the corresponding font. Since labels are the subject of this chapter, you'll review them in more detail next.

### Creating a label

Creating a label is easy: You simply call `SKLabelNode(fontNamed:)` and pass in the name of the font:

```swift
let label = SKLabelNode(fontNamed: fontName)
```

$[=p=]

The most important property to set is the text, because this is what you want the font to display.

```swift
label.text = fontName
```

You also usually want to set the font size (unless you want the default of 32 points).

```swift
label.fontSize = 50
```

Finally, just as with any other node, you position it and add it as a child of another node—in this case, the scene itself:

```swift
label.position = yourPosition
addChild(label)
```

For now, don't worry too much about the math you're using to position the labels. Also, don't worry about your use of `verticalAlignmentMode`—that’s simply a little code magic to space the labels evenly up and down the screen. You’ll learn more about alignment later in this chapter.

Build and run. Now, every time you tap the screen, you’ll see a different built-in font family:

![iphone bordered](images/002_AvenirNext.png)

Tap through to get an idea of what's available. Try to find the font named "Chalkduster"—you'll be using that shortly in Zombie Conga.

![iphone bordered print](images/003_Chalkduster.png)
![width=28% bordered screen](images/003_Chalkduster.png)


This app will also be a handy reference in the future, when you're wondering what font would be the perfect match for your game. 

## Adding a label to Zombie Conga

Now that you know a little more about the available fonts, it's time to use what you've learned to add a label to Zombie Conga. You'll start with a simple label to show the player's remaining lives.

Open your Zombie Conga project, using either your post-challenge project file from the previous chapter or the starter project for this chapter.

With the appropriate project loaded in Xcode, open **GameScene.swift** and add this line to the bottom of the list of properties:

```swift
let livesLabel = SKLabelNode(fontNamed: "Chalkduster")
```

Here, you create an `SKLabelNode`, passing in the "Chalkduster" font you discovered in AvailableFonts earlier.

$[=p=]

Next, add these lines to the bottom of `didMoveToView(_:)`:

```swift
livesLabel.text = "Lives: X"
livesLabel.fontColor = SKColor.blackColor()
livesLabel.fontSize = 100
livesLabel.zPosition = 100
livesLabel.position = CGPoint(x: size.width/2, y: size.height/2)
addChild(livesLabel)
```

$[=s=]

Here, you do the same sorts of things you've already learned about: set the text to a placeholder, set the position to the center of the screen, set the font size and then add the node as a child of the scene. You also set a new property, `fontColor`, to set the color of the text.

Build and run, and you'll see the label. But wait! It scrolls off the screen as the camera moves!

![width=60% bordered](images/004_ScrollingText.png)

It's because you added the label as a child of the scene; as you move the camera, it "looks at" different parts of the scene.

What you really want is for the label to stay in the same position, regardless of how the camera moves. To do this, you need to add the label as a child of the camera node instead.

To do this, change the last two lines to the following:

```swift
livesLabel.position = CGPoint.zero
cameraNode.addChild(livesLabel)
```

Remember, a node's position is relative to the center of its parent, so `CGPoint.zero` means the center of the camera. This is aside from the bug with the camera that was mentioned in the previous chapter, which you'll address with a workaround a little later. 

$[=p=]

Build and run, and you'll see the label is now in a fixed position near the center of the screen:

![iphone-landscape bordered](images/005_CenterText.png)

This looks good, except for Zombie Conga, it would look better if this label were aligned to the bottom-left of the playable area. For you to understand how to do this, I'd like to introduce you to the concept of **alignment modes**.

## Alignment modes

So far, you know you can place a label by setting its position, but how can you control the placement of the text in relation to the position?

Unlike `SKSpriteNode`, `SKLabelNode` doesn’t have an `anchorPoint` property. In its place, you can use the `verticalAlignmentMode` and `horizontalAlignmentMode` properties.

The `verticalAlignmentMode` controls the text’s vertical placement in relation to the label’s position, and the `horizontalAlignmentMode` controls the text’s horizontal placement. You can see this visually in the following diagram:

![width=100%](images/006_AlignmentModes.png)

The red and blue points in the diagram show, for the different alignment modes, where each label’s bounding box will be rendered in relation to the label’s position. There are two things worth noting here:

* The default alignment modes of `SKLabelNode` are `Center` for horizontal and `Baseline` for vertical.
* `Baseline` uses the actual font’s baseline, which you can think of as the “line” on which you would draw a font, if you were writing on ruled paper. For example, the tails of letters such as **g** and **y** will hang below the defined position.

To align the lives label to the bottom-left of the screen, you want to set the alignment modes to `Left` for horizontal and `Bottom` for vertical. This way, you can simply set the position to the bottom-left of the playable area.

It's time to try this out. Delete the line that sets the label's position and replace it with the following:

```swift
livesLabel.horizontalAlignmentMode = .Left
livesLabel.verticalAlignmentMode = .Bottom
livesLabel.position = CGPoint(x: -playableRect.size.width/2 + CGFloat(20),
  y: -playableRect.size.height/2 + CGFloat(20) + overlapAmount()/2)
```

Here you set the alignment modes as discussed, and then set the position to the bottom-left of the playable area. Here's a diagram to help you visualize this:

![width=75% print](images/007_LabelAlignment.jpg)
![width=100% screen](images/007_LabelAlignment.jpg)

You subtract the width and height of the playable area to get to the bottom-left corner, and then you add a 20-point margin to provide a little space between the label and the edges.

> **Note:** As a workaround to resolve the camera behavior bug mentioned in the previous chapter, you also add `overlapAmount()/2` to the y-axis; the diagram does not show this.

Build and run, and now you'll see the label correctly positioned in the bottom-left of the playable area.

![iphone-landscape bordered](images/008_LabelBottomLeft.png)

## Loading custom fonts

While the list of built-in fonts is large, there will be times you want to use fonts that aren’t included by default. 

For example, in Zombie Conga, it would be nice to switch to a font that's less intrusive in the game, but none of the fonts included by default are going to meet your needs. Luckily, Apple has made it super simple to use a **True Type Font** (TTF) in your project.

First, you need to find the font you want to use. One excellent source of fonts is [http://www.dafont.com](http://www.dafont.com). Open your browser of choice and enter the URL. You’ll see there’s a large selection of categories from which to choose, including one named **Fancy/Cartoon**. 

Click on that category, and you’ll see a huge list of fonts with example text. Some people could spend hours looking through these fonts just for fun, so take as much time as you like to see what’s available.

![width=50%](images/009_MuchLater2.jpg)

Now that you’re back, the font you’re going to use is named **Glimstick** by Uddi Uddi. Type that name into the search bar on the dafont.com website. A font preview will appear:

![width=100%](images/010_Glimstick.png)
 
This fun cartoony font is a perfect fit for the minigame you’re creating. Click the **Download** button. Once the download is complete, unzip the package and find the file named **GLIMSTIC.TTF**. The resources for this chapter also include a copy of this font, in case you have trouble downloading it.

> **Note**: It’s important to check the license for any fonts you want to use in your project. Some fonts require permission or a license before you can use them, so checking now could save a lot of headache and cost later. 

> You can see just above the download button that the Glimstick font you’re using is marked as **Free**, but to be sure, always check the license information included in the downloaded zip file. 

Now that you have your font, drag **GLIMSTIC.TTF** into your Zombie Conga project. Make sure that **Copy items if needed** and the **ZombieConga** target are checked, and click **Finish**.

![bordered width=60% print](images/011_AddFile.png)
![bordered width=75% screen](images/011_AddFile.png)

At this point, you should double check that the font has been added into the correct build phase for your project. To check this, select **ZombieConga** in the project navigator, select the **ZombieConga** target, select **Build Phases**, expand the **Copy Bundle Resources** area and check that **GLIMSTIC.TTF** is listed there. If not, click the **+** button and select it manually.

![bordered width=90% print](images/GlimsticResources.png)
![bordered width=100% screen](images/GlimsticResources.png)

Next, open **Info.plist** and click on the last entry in the list, and you’ll see plus (+) and minus (-) buttons appear next to that title.

![width=75% bordered](images/012_InfoPlist.png)

Click the plus button and a new entry will appear in the table, along with a drop-down list of options:

![width=50% bordered](images/013_Options.png)
 
In the drop-down box, type **Fonts**, making sure to use a capital **F**. The first option that comes up will be **Fonts provided by application**. Press **Return** to select that option.

Click the triangle to the left of the new entry to expand it, and double-click inside the value field. 

Inside the textbox that appears, type **GLIMSTIC.TTF**. This is the name of the font file you downloaded and the one you’re going to use in the game. Be sure to spell it correctly or your app won’t be able to load it.

![width=75% bordered](images/014_FontAdded.png)
 
Now, to try out this font! Open **GameScene.swift** and replace your line that declares the `livesLabel` property with the following:

```swift
let livesLabel = SKLabelNode(fontNamed: "Glimstick")
```

> **Note**: Notice how the font filename (i.e. "GLIMSTIC.TTF") does not necessarily have to match the actual name of the font (i.e. "Glimstick"). You can find the actual name of the font by double clicking the .TTF file.

Build and run, and you'll see your new font appear:

![iphone-landscape bordered](images/015_NewFont.png)

## Updating the label text

One last thing: The label is still showing the placeholder text. To update the text, simply add this line to the bottom of `moveTrain()`:

```swift
livesLabel.text = "Lives: \(lives)"
```

Build and run, and now your lives will properly update!

![iphone-landscape bordered](images/016_UpdatedText.png)

$[=s=]

## Challenges

This is your final challenge for Zombie Conga. Your game is 99% complete, so don’t leave it hanging! 

As always, if you get stuck, you can find the solutions in the resources for this chapter—but give it your best shot first!

### Challenge 1: A cat count

Your challenge is to add a second label to the game to keep track of the count of cats in your conga train. This label should be in the bottom-right of the playable area.

![iphone-landscape bordered](images/017_Challenge.png)

Here are a few hints:

* Create a property named `catsLabel` like you did for the `livesLabel`.
* In `didMoveToView()`, configure the `catsLabel` similarly to the `livesLabel`. However, you'll have to change the `text`, `horizontalAlignmentMode` and `position`. 
* For the `position`, refer to the diagram earlier in the chapter if you get stuck.
* Finally, in `moveTrain`, update the `catsLabel.text` based on `trainCount`.

If you’ve made it this far, a huge congratulations—you’ve completed your first Sprite Kit minigame, from scratch! Think of all you’ve learned to do:

* Add sprites to a game;
* Move them around manually;
* Move them around with actions;
* Create multiple scenes in a game;
* Make it a scrolling game with a camera;
* Add labels to the game.

Believe it or not, this knowledge is sufficient to make 90% of Sprite Kit games. The rest is just icing on the cake! :]

![width=50%](images/018_Cake.png)
