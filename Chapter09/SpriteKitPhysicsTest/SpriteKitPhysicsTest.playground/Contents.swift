import UIKit
import SpriteKit
import PlaygroundSupport

let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))

let scene = SKScene(size: CGSize(width: 480, height: 320))
sceneView.showsFPS = true

// 显示物体轮廓
sceneView.showsPhysics = true

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

// 9.10 复杂形状的实体
let l = SKSpriteNode(imageNamed: "L")
l.name = "shape"
l.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.75)
l.physicsBody = SKPhysicsBody(texture: l.texture!, size: l.size)
scene.addChild(l)

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

// 9.9 可视化实体
// 生成沙子粒子，位置随机
func spawnSand() {
    let sand = SKSpriteNode(imageNamed: "sand")
    sand.position = CGPoint(x: random(min: 0.0, max: scene.size.width), y: scene.size.height - sand.size.height)
    sand.physicsBody = SKPhysicsBody(circleOfRadius: sand.size.width / 2)
    sand.name = "sand"
    scene.addChild(sand)
    // 9.11 物理实体的属性
    // 弹跳性：0.0（实体不会反弹）-> 1.0 （实体以碰撞开始时相同的力量弹回）。默认值为0.2
    sand.physicsBody!.restitution = 0.9
    // 单位体积的质量
    sand.physicsBody!.density = 20.0
}

// 9.12 应用冲击
func shake() {
    scene.enumerateChildNodes(withName: "sand") {
        node, _ in
        node.physicsBody!.applyImpulse(CGVector(dx: random(min: 20, max: 60), dy: random(min: 20, max: 60)))
    }
    DispatchAfter(after: 3.0) {
        shake()
    }
}

// 延时2秒后恢复重力作用
DispatchAfter(after: 2.0) {
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    // 调用spawnSand，然后等待0.1秒钟，执行100次该序列动作
    scene.run(SKAction.repeat(SKAction.sequence([SKAction.run(spawnSand), SKAction.wait(forDuration: 0.1)]), count: 100))
    //
    DispatchAfter(after: 12.0) {
        shake()
    }
}

// 挑战1：力量
var blowingRight = true
var windForce = CGVector(dx: 50, dy: 0)

extension SKScene {
    // 1 遍历所有的沙子粒子和形状实体，并对每一个粒子和实体都应用当前的windForce
    @objc func windWithTimer(timer: Timer) {
        // TODO: apply force to all bodies
        enumerateChildNodes(withName: "sand") {
            node, _ in
            node.physicsBody!.applyForce(windForce)
        }
        enumerateChildNodes(withName: "shape") {
            node, _ in
            node.physicsBody!.applyForce(windForce)
        }
    }
    
    // 2 直接切换 blowingRight 并更新 windForce
    @objc func switchWindDirection(timer: Timer) {
        blowingRight = !blowingRight
        windForce = CGVector(dx: blowingRight ? 50 : -50, dy: 0)
    }
}

// 3 两个定时器，第一个每秒触发20次，第二个3秒触发一次。
Timer.scheduledTimer(timeInterval: 0.05, target: scene, selector: #selector(SKScene.windWithTimer), userInfo: nil, repeats: true)
Timer.scheduledTimer(timeInterval: 3.0, target: scene, selector: #selector(SKScene.switchWindDirection), userInfo: nil, repeats: true)

