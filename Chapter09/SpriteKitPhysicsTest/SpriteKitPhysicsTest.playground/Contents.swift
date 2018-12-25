//import PlaygroundSupport
//import SpriteKit
//
//// You can change the view's size to whatever size you'd like,
//// everything will dynamically adjust to the dimensions
//let viewSize = CGSize(width: 480, height: 320)
//
//let sceneView = SKView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: viewSize))
//sceneView.showsFPS = true
//sceneView.ignoresSiblingOrder = true
//let gameScene = SKScene(size: CGSize(width: 480, height: 320))
////gameScene.backgroundColor = .clear
//sceneView.presentScene(gameScene)
//
//PlaygroundPage.current.liveView = sceneView
//PlaygroundPage.current.needsIndefiniteExecution = true

//import PlaygroundSupport
//import SpriteKit
//
//// Draw the scene view and present the Bohr Model
//let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 480, height: 320))
//sceneView.ignoresSiblingOrder = true
//sceneView.backgroundColor = .clear
//sceneView.showsFPS = true
//
//// Create the Bohr Model scene
//let scene = SKScene(size: CGSize(width: 480, height: 320))
//scene.name = "BohrModelScene"
////scene.atomicNumberForModel = 50
////
////scene.verboseLogging = false
////scene.scaleMode = .aspectFill
//
//// Present the scene
//sceneView.presentScene(scene)
//
//// Get this playground rolling!
//PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true


import UIKit
import SpriteKit
import PlaygroundSupport
// import XCPlayground

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))
// sceneView.backgroundColor = UIColor.blue

let scene = SKScene(size: CGSize(width: 480, height: 320))
sceneView.showsFPS = true

// sceneView.showsPhysics = true

sceneView.presentScene(scene)
// 'needsIndefiniteExecution' is deprecated: Use 'PlaygroundPage.current.needsIndefiniteExecution' from the 'PlaygroundSupport' module instead
//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
PlaygroundPage.current.needsIndefiniteExecution = true
// 'liveView' is deprecated: Use 'PlaygroundPage.current.liveView' from the 'PlaygroundSupport' module instead
//XCPlaygroundPage.currentPage.liveView = sceneView
PlaygroundPage.current.liveView = sceneView

//let redRectView = UIView(frame: CGRect(x: 10, y: 20, width: 100, height: 100))
//redRectView.backgroundColor = UIColor.red
//scene.addChild(redRectView)

let square = SKSpriteNode(imageNamed: "square")
square.name = "shape"
square.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.50)

let circle = SKSpriteNode(imageNamed: "circle")
circle.name = "shape"
circle.position = CGPoint(x: scene.size.width * 0.50, y: scene.size.height * 0.50)

let triangle = SKSpriteNode(imageNamed: "triangle")
triangle.name = "shape"
triangle.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.50)

scene.addChild(square)
scene.addChild(circle)
scene.addChild(triangle)


//var str = "Hello, playground"
//
//let number = 0.4
//let string = "Sprite Kit is #\(5-4)"
//let numbers = Array(1...5)
//
//var j = 0
//for i in 1 ..< 10 {
//    j += i * 2
//}
