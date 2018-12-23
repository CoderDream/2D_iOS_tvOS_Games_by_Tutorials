# Chapter 4: Scenes
```metadata
author: "By Ray Wenderlich"
number: "4"
title: "Chapter 4: Scenes"
section: 1
```

Zombie Conga is beginning to look like a real game. It has character movement, enemies, sounds, animation, collision detection—and if you finished the challenges from the last chapter, even its namesake: a conga line!
 
![iphone-landscape bordered](images/001_Conga.png)

However, right now all the action takes place in a single **scene** of the game: the default `GameScene` created for you by the Sprite Kit project template.

In Sprite Kit, you don’t have to place everything within the same scene. Instead, you can create multiple unique scenes, one for each “screen” of the app, much like how view controllers work in iOS development.

In this short chapter, you’ll add two new scenes: one for when the player wins or loses the game and another for the main menu. You’ll also learn a bit about using the cool transitions you saw in the ActionsCatalog demo from last chapter’s Challenge 1.

But first, you need to wrap up some gameplay logic so you can detect when the player should win or lose the game. Let’s get started!

$[===]

> **Note**: This chapter begins where the previous chapter's Challenge 3 left off. If you were unable to complete the challenges or skipped ahead from an earlier chapter, don’t worry—simply open the starter project from this chapter to pick up where the previous chapter left off.

## Win and lose conditions

Here’s how the player will win or lose Zombie Conga:

* **Win Condition**: If the player creates a conga line of 15 or more cats, the player wins!
* **Lose Condition**: The player will start with five lives. If the player spends all of his or her lives, the player loses.

Right now, when a crazy cat lady collides with the zombie, nothing bad happens—there’s only a sound. To make this game challenging, you’ll change this so collisions with a cat lady result in the following effects:

1. The zombie loses a life.
2. The zombie loses two cats from his conga line.

Let’s make it so. Inside **GameScene.swift**, add a new property to keep track of the zombie’s lives and another to keep track of whether the game is over:

```
var lives = 5
var gameOver = false
```

Next, add this new helper method to make the zombie lose two cats from his conga line:

```
func loseCats() {
  // 1
  var loseCount = 0
  enumerateChildNodesWithName("train") { node, stop in
    // 2
    var randomSpot = node.position
    randomSpot.x += CGFloat.random(min: -100, max: 100)
    randomSpot.y += CGFloat.random(min: -100, max: 100)
    // 3
    node.name = ""
    node.runAction(
      SKAction.sequence([
        SKAction.group([
          SKAction.rotateByAngle(π*4, duration: 1.0),
          SKAction.moveTo(randomSpot, duration: 1.0),
          SKAction.scaleTo(0, duration: 1.0)
        ]),
        SKAction.removeFromParent()
      ]))
    // 4
    loseCount += 1
    if loseCount >= 2 {
      stop.memory = true
    }
  }
}
```

Let’s go over this section by section:

1. Here, you set up a variable to track the number of cats you’ve removed from the conga line so far, then you enumerate through the conga line.
2. You find a random offset from the cat’s current position.
3. You run a little animation to make the cat move toward the random spot, spinning around and scaling to 0 along the way. Finally, the animation removes the cat from the scene. You also set the cat’s name to an empty string so it’s no longer considered a normal cat or a cat in the conga line.
4. You update the variable that's tracking the number of cats you’ve removed from the conga line. Once you’ve removed two or more, you set the `stop` Boolean to `true`, which causes Sprite Kit to stop enumerating the conga line.

Now that you have this helper method, call it in `zombieHitEnemy()`, right after playing the enemy collision sound, and add a line to subtract 1 from the `lives` counter:

```
loseCats()
lives -= 1
```

You’re ready to add the code that checks if the player should win or lose. Begin with the lose condition. Add this to the end of `update()`:

```
if lives <= 0 && !gameOver {
  gameOver = true
  print("You lose!")
}
```

Here, you check if the number of remaining lives is 0 or less, and you make sure the game isn’t already over. If both of these conditions are met, you set the game to be over and log out a message.

To check for the win condition, you’ll make a few modifications to `moveTrain()`. First, add this variable at the beginning of the method:

```
var trainCount = 0
```

You’ll use `trainCount` to keep track of the number of cats in the train. Increment this counter with the following line inside the `enumerateChildNodesWithName()` block, before the call to `hasActions()`:

```
trainCount += 1
```

Finally, add this code at the end of `moveTrain()`:

```
if trainCount >= 15 && !gameOver {
  gameOver = true
  print("You win!")
}
```

Here, you check if there are more than 15 cats in the train, and you make sure the game isn’t over already. If both of these conditions are met, you set the game to be over and log out a message.

Build and run, and see if you can collect 15 cats. 

![width=90%](images/002_Kittens.png)
 
When you do, you’ll see the following message in the console:

```objc
You win!
```

That’s great, but when the player wins the game, you want something a bit more dramatic to happen. Let’s create a proper game over scene.

## Creating a new scene

To create a new scene, you simply create a new class that derives from `SKScene`. You can then implement `init(size:)`, `update()`, `touchesBegan(withEvent:)` or any of the other methods you overrode in `GameScene` to implement the behavior you want.

For now, you’re going to keep things simple with a bare-bones new scene. In Xcode’s main menu, select **File\New\File...**, select the **iOS\Source\Swift File** template and click **Next**. 

![bordered width=75% print](images/003_SwiftFile.png)
![bordered width=95% screen](images/003_SwiftFile.png)
 
Enter **GameOverScene.swift** for **Save As**, make sure the **ZombieConga** target is checked and click **Create**.

Open **GameOverScene.swift** and replace its contents with some bare-bones code for the new class:

```
import Foundation
import SpriteKit

class GameOverScene: SKScene {
}
```

With this, you’ve created an empty class, derived from `SKScene`, which defaults to a blank screen when presented. Later in this chapter, you’ll return to this scene to add artwork and logic.

Now, how do you get to this new scene from your original scene?

## Transitioning to a scene

There are three steps to transition from one scene to another:

1. **Create the new scene**. First, you create an instance of the new scene itself. Typically, you’d use the default `init(size:)` initializer, although you can always choose to create your own custom initializer if you want to be able to pass in extra parameters. Later in this chapter, you’ll do just that.
2. **Create a transition object**. Next, you create a transition object to specify the type of animation you’d like to use to display the new scene. For example, there are crossfade transitions, flip transitions, door-opening transitions and many more. 
3. **Call the SKView’s presentScene(transition:) method**. In iOS, `SKView` is the `UIView` that displays Sprite Kit content on the screen. You can get access to this via a property on the scene: `view`. You can then call `presentScene(transition:)` to animate to the passed-in scene (created in step 1) with the passed-in transition (created in step 2).

It's time to give this a try.

Open **GameScene.swift** and add the following lines in `moveTrain()`, right after the code that logs “You Win!” to the console (within the `if` statement):

```
// 1
let gameOverScene = GameOverScene(size: size)
gameOverScene.scaleMode = scaleMode
// 2
let reveal = SKTransition.flipHorizontalWithDuration(0.5)
// 3
view?.presentScene(gameOverScene, transition: reveal)
```

These three lines correspond exactly to the three steps above. 

Notice that after creating the game over scene, you set its scale mode to the same as the current scene’s scale mode to make sure the new scene behaves the same way across different devices.

Also notice that to create a transition, there are various constructors on `SKTransition`, just as there are various constructors for actions on `SKAction`. Here, you choose a flip horizontal animation, which flips up the scene into view from the bottom of the screen. For a demo of all the transitions, refer to ActionsCatalog, as discussed in the previous chapter’s challenges.

Now add the exact same lines as above to `update()`, right after the code that logs “You lose!” to the console (again, within the `if` statement):

```
// 1
let gameOverScene = GameOverScene(size: size)
gameOverScene.scaleMode = scaleMode
// 2
let reveal = SKTransition.flipHorizontalWithDuration(0.5)
// 3
view?.presentScene(gameOverScene, transition: reveal)
```

Build and run, and either win or lose the game. Feel free to cheat and change the number of cats to win to less than 15—after all, you’re the developer! 

Whether you win or lose, when you do, you’ll see the scene transition to a new blank scene:

![iphone-landscape bordered](images/004_BlankScene.png)
 
That’s really all there is to scene transitions! Now that you have a new scene, you can do whatever you like in it, just as you did in `GameScene`.

For Zombie Conga, you’ll modify this new scene to show either a “You Win” or a “You Lose” background. To make this possible, you need to create a custom scene initializer to pass in either the win or lose condition.

## Creating a custom scene initializer

Open **GameOverScene.swift** and modify `GameOverScene` as follows:

```
class GameOverScene: SKScene {
  let won:Bool

  init(size: CGSize, won: Bool) {
    self.won = won
    super.init(size: size)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
```

Here, you add a custom initializer that takes just one extra parameter: a Boolean that should be `true` if the player won and `false` if the player lost. You store this value in a property named `won`.

Next, implement `didMoveToView()` to configure the scene when it's added to the view hierarchy:

```
override func didMoveToView(view: SKView) {

  var background: SKSpriteNode
  if (won) {
    background = SKSpriteNode(imageNamed: "YouWin")
    runAction(SKAction.sequence([
      SKAction.waitForDuration(0.1),
      SKAction.playSoundFileNamed("win.wav", 
        waitForCompletion: false)
    ]))
  } else {
    background = SKSpriteNode(imageNamed: "YouLose")
    runAction(SKAction.sequence([
      SKAction.waitForDuration(0.1),
      SKAction.playSoundFileNamed("lose.wav", 
        waitForCompletion: false)
    ]))
  }
  
  background.position = 
    CGPoint(x: self.size.width/2, y: self.size.height/2)
  self.addChild(background)
  
  // More here...
}
```

This looks at the `won` Boolean and chooses the proper background image to set and sound effect to play.

In Zombie Conga, you want to display the game over scene for a few seconds and then automatically transition back to the main scene. To do this, add these lines of code right after the “More here...” comment:

```
let wait = SKAction.waitForDuration(3.0)
let block = SKAction.runBlock {
  let myScene = GameScene(size: self.size)
  myScene.scaleMode = self.scaleMode
  let reveal = SKTransition.flipHorizontalWithDuration(0.5)
  self.view?.presentScene(myScene, transition: reveal)
}
self.runAction(SKAction.sequence([wait, block]))
```

By now, this is all review for you. The code runs a sequence of actions on the scene, first waiting for three seconds and then calling a block of code. The block of code creates a new instance of `GameScene` and transitions to that with a flip animation.

One last step: You need to modify your code in `GameScene` to use this new custom initializer. Open **GameScene.swift** and inside `update()`, change the line that creates the `GameOverScene` to indicate that this is the lose condition:

```
let gameOverScene = GameOverScene(size: size, won: false)
```

Inside `moveTrain()`, change the same line, but indicate that this is the win condition:

```
let gameOverScene = GameOverScene(size: size, won: true)
```

Build and run, and play until you win the game. When you do, you’ll see the win scene, which will then flip back to a new game after a few seconds:

![iphone-landscape bordered](images/005_YouWin.png)
 
Now that your game is close to done, it’s a good time to turn off the debug drawing for the playable rectangle. Comment out this line in `didMoveToView()`:

```
// debugDrawPlayableArea()
```

## Background music

You almost have a complete game, but you’re missing one thing: awesome background music!

Luckily, we’ve got you covered. Open **MyUtils.swift** and add the following to the bottom of the file:

```
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String) {
  let resourceUrl = NSBundle.mainBundle().URLForResource(
    filename, withExtension: nil)
  guard let url = resourceUrl else {
    print("Could not find file: \(filename)")
    return
  }

  do {
    try backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url)
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
  } catch {
    print("Could not create audio player!")
    return
  }
}
```

Sprite Kit has no built-in way to play background music, so you’ll have to fall back on other iOS APIs to do it. One easy way to play music in iOS is to use the `AVAudioPlayer` class inside the AVFoundation framework. The above helper code uses an `AVAudioPlayer` to play some background music in an endless loop.

Back in **GameScene.swift**, try it out by adding this line to the top of `didMoveToView()`:

```
playBackgroundMusic("backgroundMusic.mp3")
```

Here, you make the game play the background music when the scene first loads. 

Finally, you need to stop the background music when the player switches scenes, so they can hear the “you win” or “you lose” sound effects. To do this, add this line right after the “You Win!” log line in `moveTrain()`:

```
backgroundMusicPlayer.stop()
```

Also add that same line right after the “You Lose!” log line in `update()`:

```
backgroundMusicPlayer.stop()
```

Build and run, and enjoy your groovy tunes!

## Challenges

This was a short and sweet chapter, and the challenges will be equally so. With only one challenge for this chapter, it's time to add a main menu scene to the game.

As always, if you get stuck, you can find the solution in the resources for this chapter—but give it your best shot first!

### Challenge 1: Main menu scene

Usually, it’s best to start a game with an opening or main menu scene, rather than throw the player right into the middle of the action. The main menu often includes options to start a new game, continue a game, access game options and so on.

Zombie Conga’s main menu scene will be very simple: It will show an image and allow the player to tap to continue straight to a new game. This will effectively be the same as the splash screen, except it will allow the player more time to get his or her bearings.

Your challenge is to implement a main menu scene that shows the **MainMenu.png** image as a background and upon a screen tap, uses a “doorway” transition over 1.5 seconds to transition to the main action scene.

$[=s=]

Here are a few hints for how to accomplish this:

1. Create a new class that derives from `SKScene` named `MainMenuScene`.
2. Implement `didMoveToView()` on `MainMenuScene` to display **MainMenu.png** in the center of the scene.
3. Inside **GameViewController.swift**, edit `viewDidLoad()` to make it start with `MainMenuScene` instead of `GameScene`.
4. Build and run, and make sure the main menu image appears. So far, so good!
5. Finally, implement `touchesBegan(_:withEvent:)` in `MainMenuScene` to call a helper method, `sceneTapped()`. `sceneTapped()` should transition to `GameScene` using a “doorway” transition over 1.5 seconds. 

If you’ve gotten this working, congratulations! You now have a firm understanding of how to create and transition between multiple scenes in Sprite Kit.
