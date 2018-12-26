import UIKit
import SpriteKit
import PlaygroundSupport

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))

let scene = SKScene(size: CGSize(width: 480, height: 320))
sceneView.showsFPS = true

// 关闭重力作用
scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)

// 9.6 边缘闭合实体
// 当圆形碰到了屏幕的底部的时候，它会停止下来，甚至会向回反弹一点点。
scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
sceneView.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = sceneView

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

// 9.5 圆形实体
circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width / 2)

// 延时2秒后恢复重力作用
DispatchAfter(after: 2.0) {
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
}
