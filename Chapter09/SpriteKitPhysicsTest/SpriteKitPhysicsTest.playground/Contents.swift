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

// 9.7 矩形实体
square.physicsBody = SKPhysicsBody(rectangleOf: square.frame.size)

// 9.8 定制形状的实体
// 创建虚线绘制路径
var trianglePath = CGMutablePath()

// http://www.cocoachina.com/bbs/read.php?tid-1698108.html
// 将“虚拟画笔”移动到三角形的第一个点上（左下角）
trianglePath.move(to: CGPoint(x: -triangle.size.width / 2, y: -triangle.size.height / 2))
// 绘制3条线
trianglePath.addLine(to: CGPoint(x: triangle.size.width / 2, y: -triangle.size.height / 2))
trianglePath.addLine(to: CGPoint(x: 0, y: triangle.size.height / 2))
trianglePath.addLine(to: CGPoint(x: -triangle.size.width / 2, y: -triangle.size.height / 2))
// 创建三角形实体
triangle.physicsBody = SKPhysicsBody(polygonFrom: trianglePath)

// 延时2秒后恢复重力作用
DispatchAfter(after: 2.0) {
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
}
