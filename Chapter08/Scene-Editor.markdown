# Chapter 8 - Scene Editor
```metadata
author: "By Marin Todorov"
number: "8"
title: "Chapter 8: Scene Editor"
section: 2
```

In this chapter, you'll begin to build the second minigame in this book: a puzzle game called Cat Nap. Here’s what it will look like when you’re finished:

![iphone-landscape bordered](<images/image1.png>)

In Cat Nap, you take the role of a cat who’s had a long day and just wants to go to bed.

However, a thoughtless human has cluttered the cat’s bed with scrap materials from his recent home renovation. This silly human's bad choices are preventing the cat from falling asleep! Of course, since cats don't care much about—well, anything—he sits on top of the scrap anyway.

Your job is to destroy the blocks by tapping them so the cat can comfortably fall into place. Be careful, though: If you cause the cat to fall on the floor or tip onto his side, he’ll wake up and get really cranky.

The puzzle is to destroy the blocks in the correct order, so the cat falls straight down. One wrong choice and—queue evil music—you face the Wrath of Kitteh!

![width=67%](<images/image2.png>)

You’ll build this game across the next six chapters, in stages:

1. **Chapter 8, Scene Editor**: You are here! You’ll begin by creating the first level of the game, pictured above. By the end, you'll have a better understanding of Xcode's level designer, better known as the scene editor.

2. **Chapter 9, Beginning Physics**: In this chapter, you're going to make a little detour in order to learn the basics of creating physics simulations for your games. As a bonus, you'll learn how to prototype games inside an Xcode playground.

3. **Chapter 10, Intermediate Physics**: You’ll learn about physics-based collision detection and create custom classes for your Sprite Kit nodes.

4. **Chapter 11, Advanced Physics:** You’ll add two more levels to the game as you learn about interactive bodies, joints between bodies, composed bodies and more.

5. **Chapter 12, Crop, Video and Shape Nodes:** You’ll add special new blocks to Cat Nap while learning about additional types of nodes that allow you to do amazing things—like play videos, crop images and create dynamic shapes.

6. **Chapter 13, Intermediate tvOS:** In this last chapter you are going to bring Cat Nap to the silver screen. You are going to take the fully developed game and add support for tvOS so the player can relax on their couch and play the game using only the remote.

It's time to get started—there’s nothing worse (or perhaps funnier) than an impatient cat!

## Getting started

Start Xcode and select **File\\New\\Project…** from the main menu. Select the **iOS\\Application\\Game** template and click **Next**.

Enter **CatNap** for the Product Name, **Swift** for the Language, **Sprite Kit** for the Game Technology and **Universal** for the Devices. Click **Next**, then choose a place on your hard drive to save your project and click **Create**.

You want this app to run in landscape rather than portrait mode. Just like you did in Chapter 1, "Sprites", select the **CatNap** project in the project navigator and then select the **CatNap** target. Go to the **General** tab and verify that only the device orientations for **Landscape Left** and **Landscape Right** are checked.

You also need to modify this in one more spot. Open **Info.plist** and find the **Supported interface orientations (iPad)** entry. Delete the entries for **Portrait (bottom home button)** and **Portrait (top home button)** so that only the landscape options remain.

To get this game started on the right foot, or should we say paw, you need to set up an app icon. To do this, select **Assets.xassets** in the project navigator on the left and then select the **AppIcon** entry. Then, in the resources for this chapter, drag all of the files from the **Icons\\iOS** subfolder into the area on the right. You might need to drag a few individual files until Xcode matches all required icons. You'll see the following when you’re done:

![width=60%](<images/image3.png>)

There’s one final step. Open **GameViewController.swift** and modify the line that sets `skView.ignoresSiblingOrder` from `true` to `false`:

```swift
skView.ignoresSiblingOrder = false
```

This makes it so nodes with the same `zPosition` are drawn in the order in which they are added to the scene, which will make developing Cat Nap a bit simpler. Keep in mind, though, that there's a performance cost incurred by changing this setting to `false`. Luckily, for a simple game like this, it's not a problem.

Build and run the project on the **iPhone simulator**. You’ll see the “Hello, World!” message nicely positioned in the center of the screen, in landscape mode.

![width=90%](<images/image4.png>)

### Introducing texture atlases

Before you can add sprites to the scene, you need images for them, right? In the resources for this chapter, locate the **Resources** folder; this includes all the images, sounds and other files you'll need for Cat Nap. (It's the folder where the project icons were located.)

In Xcode, open **Assets.xcassets** and drag in all of the images from the **Resources\Images** folder. Also delete **Spaceship** from the asset catalog; this cat prefers both paws on the ground! At this point, your asset catalog should look like this:

![width=95% bordered](<images/image5b.png>)

Next, drag the **Resources\Sounds** into your project and make sure that **Copy items if needed**, **Create groups** and the **CatNap** target are all checked. At this point, your project navigator should look like this:

![width=40% bordered](<images/image5c.png>)

Woo-hoo! You’ve finished setting up your project. Now it's time to fire up the scene editor.

## Getting started with the scene editor

As mentioned previously, Cat Nap is a puzzle game in which players need to solve one level after another. This is the perfect reason to learn how to use the scene editor, a built-in Xcode tool designed to help you build levels without having to write everything in code.

The default Sprite Kit project template contains a scene file already. Look in the project navigator and you’ll see a file called **GameScene.sks**. Select that file and you’ll see a new editor panel that shows a gray background:

![width=75% bordered](<images/image7.png>)

Click the minus (**–**) button in the mid-right corner several times until you see a yellow rectangle appear—you might need to click it five or six times if you're on a laptop. This is the boundary of your scene. The default size for a new scene is 1024x768 points.

![width=75% bordered](<images/image8.png>)

Remember from Chapter 1, "Sprites", that the strategy we're taking for games in this book is to use a single set of images sized for a 2048x1536 scene, and let Sprite Kit downscale the images for all devices with smaller screen resolutions. Resizing the scene is straightforward.

So let's resize the scene to our preferred 2048x1536 size. To do this, make sure the utilities editor on the right-hand side is open; if it’s not, click **View\\Utilities\\Show Attributes Inspector**.

Within the **Attributes Inspector** for the scene, enter the new dimensions:

![width=40% bordered](<images/image10.png>)

Now the scene has established a suitable size for supporting all devices.

$[=s=]

### The Object Library

At the bottom of the utilities editor, if it's not already selected, select the **Object Library**:

![width=40% bordered](<images/image11.png>)

> **Note:** If the utilities editor on the right-hand side isn't open, click **View\\Utilities\\Show Object Library**.

The Object Library displays a list of objects that you can drop onto your scene and configure. When you load the scene file, those objects will appear in their correct positions based on the properties you set for them in the scene editor. That’s much better than writing code to position and adjust every game object one by one, isn’t it?

Here are some of the objects you can use:

* **Color sprite:** This is the object you use to put sprites onscreen and the one you’ll use most often throughout this chapter and the next.

* **Shape node:** These are special types of nodes in Sprite Kit that allow you to easily draw squares, circles and other shapes. You'll learn more about these in Chapter 12, “Crop, Video and Shape Nodes”.

* **Label:** You already know how to create labels programmatically, but with the scene editor, you can create them simply by dragging and dropping them onto the scene.

* **Emitter:** These are special types of nodes in Sprite Kit that allow you to create particle systems, which you can use for special effects like explosions, fire, or rain. You'll learn more about these in Chapter 16, "Particle Systems".

* **Light:** You can place a light node in your scene for a spotlight effect and have your scene objects cast shadows. 

The best thing about the scene editor is that it’s not just an editor—it also serves as a simulator, allowing you to easily preview scenes without running the app. You’ll see this later.

$[=p=]

### Adding and positioning sprites

Make sure the yellow frame of your scene is visible and that it fits into the editor window. Drag and drop a **color sprite** object into the editor area.

![width=60% bordered](<images/image12.png>)

With the sprite selected, which happens by default when you create it, you'll see the available properties listed in the Attributes Inspector.

![width=40% bordered](<images/image14.png>)

You may recognize a lot of these properties from before—you used many of them programmatically in your Zombie Conga project (such as `position` and `name`).

In the Attributes Inspector, you can set the sprite’s name, parent node and the image file you want to use as the texture. You can also set the sprite’s position, size and anchor point, either by hand or by dragging with the mouse.

Further down in the same panel, you’ll see the controls to adjust the sprite’s scale, z-axis position and z-axis rotation:

![width=40% bordered](<images/image16.png>)

But wait! There's more! Even further down, listed in a section called **Physics Definition**, you’ll find more properties you can set:

![width=40% bordered](<images/image17.png>)

Notice that your sprite doesn’t have a physics body, which means it is not taking part in a physics simulation. You'll be returning to this setting in future chapters, where you'll learn more about Sprite Kit physics.

In the meantime, let's begin by designing Cat Nap’s first level!

### Laying out your first scene

Select the sprite you just added to your scene and on the right-hand side, in the Attributes Inspector, set its properties to the following values:

* **Texture: background**
* **Position X: 1024**
* **Position Y: 768**

This should start you off nicely with the level’s background image:

![width=75% bordered](<images/image19.png>)

That was easy!

Next, you’re going to add the cat bed to the scene. Drag another **color sprite** onto the scene and set its properties as follows:

* **Name: bed**
* **Texture: cat\_bed**
* **Position: (1024, 272)** (enter X and Y into the respective boxes)

This will position the cat bed a bit off the bottom of the scene.

![width=75%](<images/image20.png>)

Now let’s move on to those wooden blocks that get in the cat’s way. There will be four blocks in total, but you'll add them two by two.

Drop two **color sprite** objects onto the scene. Edit their properties like so:

* **First block**: Texture **wood_vert1**, Position X **1024**, Position Y **330**
* **Second block**: Texture **wood_vert1**, Position X **1264**, Position Y **330**

Now you'll see this:

![width=75% bordered](<images/image21.png>)

Take a moment to appreciate how much easier it is to set objects onscreen via the scene editor instead of through code. Of course, that doesn't mean you shouldn't understand what goes on behind the scenes. In fact, knowing how to do both is a huge plus.

OK! It's time to add the horizontal blocks. Drop two more **color sprite** objects onto the scene and adjust their properties as follows:

* **First block**: Texture **wood_horiz1**, Position X **1050**, Position Y **580**
* **Second block**: Texture **wood_horiz1**, Position X **1050**, Position Y **740**

Your scene continues to develop, and all of the obstacles are present now. At this point, you’re only missing your main character:

![width=75% bordered](<images/image22.png>)

Drop one last **color sprite** object onto the scene. This will be the cat. Edit as follows:

* **Cat**: Texture **cat_sleepy**, Position X **1024**, Position Y **1036**

Finally, you've completed the basic setup of the first Cat Nap level:

![width=75% bordered](<images/image23.png>)

Build and run. Notice that your scene appears on the screen. Also notice the  “Hello, World” label from the template code in **GameScene.swift**—don't worry about that now:

![iphone-landscape bordered](<images/image25.png>)

These are the basic skills you need to design levels using the scene editor. Luckily, it's capable of much more than laying down sprites on a scene. In the next section, you'll build more complex stuff!

## File references

A cool feature (introduced in iOS 9) is that the scene editor allows you to reference content from other scene (.sks) files.

This means you can put together a bunch of sprites, add some effects like animations and then save those in a reusable .sks file. Then, you can reference the same content from multiple scenes, and they'll all dynamically load the same content from the reusable .sks file.

Now comes the best part: If you need to change the referenced content in _all_ scenes, you only need to edit the original content and you're good to go.

As you may have guessed, this is perfect for level-based games where you often have characters or other parts of the scene recurring throughout the game. In Cat Nap, such a recurring character is everybody's favorite kitten:

![width=25% print](<images/image26.png>)
![width=30% screen](<images/image26.png>)

In this section, you're going to extract the sleepy cat into its own .sks file and add more nodes and animations. Then you'll reference all of these as a bundle from within **GameScene.sks**.

First and foremost, since you're going to have more than one .sks file, it's time to organize them neatly. Control-click the yellow **CatNap** group and select **New Group**. Rename the group **Scenes**, and move **GameScene.sks** inside the newly created folder.

Once you're done, it should look like this:

![width=45% bordered](<images/image27.png>)

Next, control-click **Scenes** and from the pop-up menu, click **New File...**. Choose the **iOS/Resource/SpriteKit Scene** file template and then click **Next**. Call the new file **Cat.sks** and save it in the project folder.

Xcode automatically opens the newly created **Cat.sks** file and presents you with an empty, gray editor window. In exactly the same way as before, your task is to resize the scene to your needs and add some sprites.

Set the scene size to **380x440** points (the size of the cat) and since you have that particular pane open, set the Anchor Point to **(0.5, 0.5)**. Doing so lets you position the nodes inside the scene relative to the scene center; this is slightly easier placing them relative to the lower left, as most nodes will be centered either horizontally or vertically:

![width=50% bordered](<images/image29.png>)

Now that the scene is ready for prime time, you need to add all of the cat's elements. First you'll add the torso. Drag in two **color sprite** nodes from the Object Library and set their properties like so:

* **Cat Body**: Name **cat_body**, Texture **cat_body**, Position X **22**, Position Y **-112**
* **Cat Head**: Name **cat_head**, Parent **cat_body**, Texture **cat_head**, Position X **18**, Position Y **192**

Note you set the cat body as the parent of the cat head. Since each Sprite Kit node can have as many sub-nodes as needed, sometimes it's handy to have one of your nodes act as the root node—that is, as a parent to other nodes. This way, if you need to copy or move all nodes, you only need to work with the root node, and the rest will move along with it.

Now your cat's body and head are nicely positioned within the scene while leaving space on the left for the big, fluffy tail that you're adding next.

Speaking of big, fluffy tails, drag in a **color sprite** from the Object Library and set its properties like so:

* **Tail**: Name **tail**, Texture **cat_tail**, Parent **cat_body**, Anchor Point **(0, 0)**, Position **(-206, -70)**, Z Position **-1**

Later in this chapter, you'll animate the tail so it rotates gently along its (0, 0) position. This will make it appear as if the cat is swinging its tail slowly in the air, giving him that cat swagger.

So far the cat scene looks like this:

![width=40% bordered](<images/image30.png>)

Now it's time to add the rest of the cat parts. Add two **color sprite** objects to the scene and adjust their properties like so:

* **Cat mouth**: Name **mouth**, Parent **cat_head**, Texture **cat_mouth**, Position X **6**, Position Y **-67**
* **Cat eyes**: Name **eyes**, Parent **cat_head**, Texture **cat_eyes**, Position X **6**, Position Y **2**

This completes the cat, and your scene will look like this:

![width=40% bordered](<images/image32.png>)

Now you will remove the static cat image from **GameScene.sks** and use your newly designed cat scene.

To do this, open **GameScene.sks** and delete the static cat sprite. In its place, drop a **reference node** from the Object Library:

![width=40% bordered](<images/image33.png>)

The empty reference node appears like a hollow, dashed rectangle:

![width=40% bordered](<images/image34.png>)

$[=p=]

Set the following property values for the selected reference node:

* **Name: cat\_shared**
* **Reference:** select **Cat.sks** from the drop-down menu
* **Position: (1030, 1045)**
* **Z-Position: 10**

Here, you're loading the content of the file **Cat.sks** and positioning it where the static cat image used to be. Additionally, you're setting a higher z-position to make sure the contents of **Cat.sks** appear above the level's background image.

With this done, you've successfully created a reusable piece of content that you can use throughout your game. Nice job!

![width=67% bordered](<images/image34_1.png>)

> **Note:** Due to a bug in Xcode 7 you might not see the cat appear on the scene when you add the reference. To solve this just close Xcode and start it again - this time around your reference will show the cat just like on the screenshot above.

There's one problem with your cat—it doesn't do anything interesting. It's just a bunch of nodes stuck together!

It's time to correct that by creating what's called an "idle animation". This will help to make the scene come alive.

## Animations and action references

So far, you've been creating node actions using code. As you saw in the previous chapters, with only a few lines of code, you can create an `SKAction` to move a sprite along the screen, rotate it and scale it. But sometimes it's nice to do that visually, especially when prototyping animations or level design.

In this section, you're going to learn how to add actions to the nodes in your scene. Later, you'll learn how to extract those actions into their own .sks files and reuse them to animate different sprites.

### Adding actions to nodes

Open **Cat.sks** and find this arrow button towards the bottom of Xcode's window:

![width=45% bordered](<images/image35.png>)

If the arrow on the button points upward, like in the screenshot above, click it to open the **action editor**:

![width=80% bordered](<images/image36.png>)

The action editor displays all the nodes in the scene and a timeline with rows corresponding to each node. If you've ever worked with animation or video software, you might be familiar with this type of user interface.

You're going to use the action editor to animate the cat's tail.

Grab a **RotateToAngle action** object from the Object Library and drop it onto the timeline track for the **tail** node. While dragging the action over the tail track, a new strip will open and show you a live preview where the new action will appear when dropped.

Drop the action and position it at the beginning of the timeline—that is, at the 0:00 time mark:

![width=100% bordered](<images/image37.png>)

Cool! You've just added a rotate action to the tail sprite. You only need to polish the action a bit before giving it a try. In the **Attributes Inspector**, set the following two values: 

* **Duration: 2**
* **Degrees: 5**

![width=50% bordered](<images/image38.png>)

While you're at it, add one more action just after the first one.

Drag another **RotateToAngle action** object to the **tail** node and snap it to the end of the first one; set its properties as follows:

* **Start Time: 2**
* **Duration: 1.5**
* **Degrees: 0**

This action will swing the cat's tail back to its initial position. The timeline will now look like so:

![width=85% bordered](<images/image39.png>)

The best thing about the scene editor is that you don't need to run your game in the simulator or on a device in order to test your scenes. 

Find the **Animate** button at the top of the action editor and click it; the scene editor will play the actions you just added. This allows you to quickly find any issues you may have with your animations. 

![width=85% bordered](<images/image39b.png>)

If you want more control over the playback, you can simply grab the timeline scrubber and move it back and forth:

![width=85% bordered](<images/image40.png>)

Notice how the **Animate** button turns into a **Layout** button. This indicates that you're currently animating the scene. If you'd like to work again on the layout, click on **Layout** to switch back to that mode.

When you click **Layout**, the timeline position resets, and you can again move sprites around and edit their properties.

## More about the timeline

**Timeline** is very powerful when it comes to designing complex scenes and animations. Before moving on you will go on a quick tour.

To the right of the Animate button you will see a Playback Speed control. While you are playing back your actions you can choose the speed of replay. This makes sense since when you are loading those animations from code you can tell Sprite Kit the speed you want to use for the animations.

Change the playback speed to **2x**.

![width=40% bordered](<images/image40a.png>)

Click **Animate** and notice how the tail moves two times faster than before. This feature is very useful when you are prototyping animations in scene editor - if you are not really sure about the duration of some of your actions you can easily experiment by just changing the playback speed until you are satisfied.

Reset the playback speed to **1x** before moving on.

The timeline lists all views in your scene in the order you added them to the scene. You started with the cat body and added the eyes last and you see the nodes in that exact order too:

![width=67% bordered](<images/images40d.png>)

As you can imagine the more complex a scene is the more fields you will have in this list. Once you have so many nodes that you have to scroll continuously up and down to find the one you're looking for you will feel the need to navigate the list in a more convenient way.

You have two ways to filter the timeline node list. First in the top left corner just under Animate you will see a drop list menu:

![width=40%](<images/image40e.png>)

The item selected by default is All Nodes but you can choose from two more:

 * __Nodes with Actions__: Filters the node list to show you only the nodes that already have actions attached. Using this option is useful when you want to modify an existing action and you want to see only the nodes that possibly the action runs on.
 
 * __Selected Nodes__: This option will dynamically show you only the nodes you have currently selected in scene editor. This is a powerful mode as it shows you only the timeline for the selected scene items.

The second control allowing you to filter the node list is the search field at the bottom left corner:

![width=50% bordered](<images/image40c.png>)

This field allows you to quickly filter the node list to only those nodes whose names contain the given search term. This comes very handy in the cases when you want to work with a given node and you have its name off the top of your head.

Last but not least in the bottom right corner there is a slider that allows you to scale up or down the timeline so you can see more or less actions without having to scroll through:

![width=67% bordered](<images/image40d.png>)

### Repeating actions 

You're almost done, but there's one more thing you need to do - make the cat's tail wave continuously. This cat refuses to sit still! 

Making an action repeat a set number of times, or indefinitely, is easy to do using the action editor. For your tail animation, you'll first need to group the two actions you just created, and then repeat that action group so the tail can continuously swing back and forth.

First, select both actions in the action editor's timeline while pressing the **Command** key; if you do this properly, you'll see both actions appear highlighted:

![width=65% bordered](<images/image41a.png>)

While both actions are selected, right-click on one of them and select **Create Loop** from the pop-up menu. 


In the popover menu, select the infinity symbol **∞** to indicate that you want this action to repeat continuously (the button will remain selected to show you your current looping preference):

![width=50% bordered](<images/image41b.png>)

The timeline shows you the currently selected loop in blue and all of the repeats in an orange tint so you can easily see, which one is the "original" and its repetitions.

![width=90%](<images/image41c.png>)

Besides an indefinitely repeating loop you can choose from three more options. 

When you clicked **Create Loop** in first place Xcode created a loop that plays once and repeats one more time. So if you wanted an action that plays a total of two times - you would not have had to do anything more.

The popup menu gives you few more options to control the repeat count of the loop:

![width=40% bordered](<images/image46.png>)

* **∞** loops the action forever;
* **+** adds one more repeat;
* **-** removes one repeat;
* **X** removes all repeats from the action.

For your tail-rotation action, you chose **∞** to make the cat gently swing its tail throughout the whole game.

> **Note:** It's natural to think that the X button closes the popup. In this case however it removes the looping from your animation instead. To close the popup window simply click somewhere outside of it and it will automatically go away.

That's pretty cool! And even cooler is that you've got a little content hierarchy going on in your game to maximize resource reuse:

1. **Cat.sks** contains sprites and actions, and configures the looping and duration of the actions.

2. **GameScene.sks** contains a complete level setup, and it also references the cat character from **Cat.sks**.

This setup allows you to load the cat with all its body parts and attached to them actions from any level in your game. In fact - you are going to load the cat in **each** level in your game!

Further you are going to create more .sks files containing different cat animations, which you are going to load and use in different stages of the game.

> **Note:** The original Sprite Kit feature list introduced with iOS 9 includes the ability to also create actions in their own .sks file and re-use those actions for different nodes in different scenes. This is pretty cool because it alows you to use one more level of resource abstraction.
>
> However this feature does not work on 32bit systems - i.e. if your game load actions from .sks files that runs on iPhone6, iPhone 6s, and newer but crashes on iPhone5, iPhone 4s and earlier. This bug is present in Xcode 7 and is not fixed in Xcode 7.1 so this chapter does not cover it.

Now build and run your project to see how far you've come:

![width=50% bordered](<images/image47.png>)

Look at that cat swinging its tail like a boss.

This is a pretty long chapter, and you're probably a bit tired. If so, take a five minute break to fool around. Better yet, why not drag more reference nodes from the Object Library and load up the scene with more cats?

![width=67% bordered](<images/image48.png>)

Good fun! Just make sure you remove all of the extra cats before going further. :]

In this chapter you have learned how to find your way around scene editor, how to plan and design game scenes, add and edit nodes and run basic actions on them. The interface of scene editor is fairly simple but it allows you to achieve quite a lot.

So far you have designed the very first Cat Nap level, which is not that complex but you will keep applying your new skills throughout the two chapters that follow and create a number of additional levels, which will get progressively more complex.

The next chapters, in which you get to work on Cat Nap, focus more on creating sprites and actions from code. It's important for you to know how to design and fine tune your game's levels both from within Scene Editor and your code so you can always use the best approach for your current project.

With that being said make sure that you really got a good command of the Scene Editor interface before moving on. The two challenges that follow are a perfect opportunity to exercise your newly acquired Scene Editor skills.

Once you are finished working through the challenges and you have your cat fully animated you will be ready to move on to getting to know the ropes of physics simulation in SpriteKit.

## Challenges

There are two challenges this time, to get you some additional practice with the scene editor; creating actions and laying out levels.

As always, if you get stuck, you can find the solution sin the resources for this chapter—but give it your best shot first!

### Challenge 1: Creating further cat actions

You've constructed the cat using a few nodes, like its body, head, tail, eyes and, of course, its gorgeous smile. So far, you've animated the tail by using a repeating sequence of two rotate actions.

In this challenge, you'll use additional types of actions to complete the cat's idle animation.

Follow the general steps below to create a new action inside **Cat.sks**. Add the actions listed below to the cat's mouth node, setting their properties like so:

* **Move Action**: Start Time **5**, Duration **0.75**, Timing **Ease Out**, Offset **(0, 5)**
* **Move Action**: Start Time **5.75**, Duration **0.75**, Timing **Ease In**, Offset **(0, -5)**
* **PlaySoundFileNamed Action**: Start Time **5.25**, Duration **1**

For the filename of the sound action, select **mrreow.mp3** from the drop-down menu.

If you're wondering how you can make the actions overlap on the timeline, here's a hint for you. The final result looks like this:

![width=60% bordered](<images/image49.png>)

Since you would like the actions to repeat including the 5 seconds of waiting time you need to do a little trick.

Add one more action at the beginning of the timeline for the mouth node:

* **Move Action**: Start Time **0**, Duration **1**, Offset **(0, 0)**

Then select all four actions and create a loop of them like you did earlier in this chapter. You should see the four actions grouped in a loop like so:

![width=75% bordered](<images/image49a.png>)

> **Note:** Once more - this loop could have been easier to create without a *cheat* node had Sprite Kit not been crashing on 32bit systems.

While you're at it, create one more action and drop it on the eyes node in the scene timeline. Drag in an **AnimateWithTextures Action** and set the Start Time to **6.5** and the Duration to **0.75**. 

Then, in the fourth tab in the bottom right (the Media Library), drag **cat_eyes**, **cat_eyes1**, and **cat_eyes2** onto the Textures list of your newly created action. 

Finally, click the loop button on your action to add one more repetition. Keep in mind that sometimes, depending on the timeline zooming, your actions are too small to accommodate the button - if you don't see it when hovering with your mouse over an action, try zooming in on that action by using the slider in the bottom-right corner of the timeline pane.

![width=50% bordered](<images/image49b.png>)

Also, tick the **Restore** checkbox; this way when the animation completes, it will go back to its initial frame.

The final setup should look like this:

![width=67% bordered](<images/image50.png>)

Once more, in order to trick Sprite Kit to include the initial 6.5 seconds of waiting time in your loop, add a *cheat* action:

* **Move Action**: Start Time **0**, Duration **1**, Offset **(0, 0)**

Select both actions you added to the cat eyes and create a loop that repeats forever.

Well done so far! Your complete timeline should now look like this:

![width=90% bordered](<images/image51.png>)

Build and run to enjoy the fruits of your labour. Watch as the cat sits quietly waving its tail, and every now and again, sleepily blinks and purrs. Neat, huh?

### Challenge 2: Creating further cat scenes

In this challenge, you'll create two more .sks files, which you'll use later to load the cat's "win" and "lose" animations.

Create a new **CatCurl.sks** file and set the scene size to (380, 440). Add one **color sprite** object with the following properties:

* **Cat Curl**: Name **cat_curl**, Texture **cat_curlup1**, Position **(190, 220)**, Size **(380, 440)**

In the actions editor, add one action to the **cat_curl** sprite node as follows:

* **AnimateWithTextures Action**: Start Time **0**, Duration **1**

Make sure Restore is **not** checked. For Textures, drag in the following files from the Media Library:

* **cat\_curlup1.png** 
* **cat\_curlup2.png** 
* **cat\_curlup3.png**

You can scrub the timeline view to preview this animation; later you will load and run this when the player successfully solves a level in Cat Nap:

![width=67% bordered](<images/image52.png>)

There's one more scene left to create: the animation to play when your player fails to solve a level. The process is similar to creating the winning sequence.

Create a new **CatWakeUp.sks** file and set the scene size to (380, 440). Add one **color sprite** object with the following properties:

* **Cat Awake**: Name **cat_awake**, Texture **cat_awake**, Position **(190, 220)**, Size **(380, 440)**

In the actions editor, add one action to the **cat_awake** sprite node with the following properties:

* **AnimateWithTextures Action**: Start Time **0**, Duration **0.5**

$[=p=]

Make sure Restore is **not** checked. For Textures, drag in the following files from the Media library:

* **cat\_awake.png**
* **cat\_sleepy.png**

Make the action repeat indefinitely.

You can scrub the timeline view to preview this animation; later you will load and run this scene when the cat falls off a wooden block and onto the ground, causing the player to fail the level:

![width=67% bordered](<images/image53.png>)

Who ever said cats always land on their feet?

Phew! That was a long chapter with lots of instructions. If you need to take another break, no one will blame you. However, the next chapter introduces you to the world of actions, collisions and crazy physics experiments, so don't wait too long to turn the page.