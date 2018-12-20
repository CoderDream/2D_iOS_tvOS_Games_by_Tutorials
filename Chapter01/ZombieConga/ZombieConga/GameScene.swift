//
//  GameScene.swift
//  ZombieConga
//
//  Created by coderdream on 2018/12/17.
//  Copyright © 2018 coderdream. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // 创建精灵
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    // 上次更新时间
    var lastUpdateTime: TimeInterval = 0
    // 时间增量
    var dt : TimeInterval = 0
    // 偏移向量
    let zombieMovePointsPerSec : CGFloat = 4800.0
    // 移动速度，初始速度为0
    var velocity  = CGPoint.zero
    // 游戏区域
    let playableRect : CGRect
    
    override init(size : CGSize) {
        let maxAspectRatio : CGFloat = 16.0 / 9.0                           // 1
        let playableHeight = size.width / maxAspectRatio                    // 2
        let playableMargin = (size.height - playableHeight) / 2.0           // 3
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)   // 4
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init (coder:) has not benn implemented") // 6
    }
    
    //
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        // 创建精灵
        let background = SKSpriteNode(imageNamed: "background3")
        // 把精灵加到场景
        addChild(background)
        // 定位精灵
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        // 设置精灵的锚点
        //background.anchorPoint = CGPoint.zero
        //background.position = CGPoint.zero
        
        background.anchorPoint =  CGPoint(x: 0.5, y: 0.5) // default
        // 旋转精灵
        // background.zRotation = CGFloat(Double.pi) / 8
        // 获取精灵的大小
        let mySize = background.size
        print("Size: \(mySize)")
        // 节点和z位置
        background.zPosition = -1
        
        // zombie.size = CGSize(width: 314, height: 204)
        // 把精灵加到场景
        addChild(zombie)
        // 定位精灵
        zombie.position = CGPoint(x: 400, y: 400)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // zombie.position = CGPoint(x: zombie.position.x + 8, y: zombie.position.y)
        // moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
        moveSprite(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt * 1000) milliseconds since last update")
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        // 1
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        // 2
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    func moveZombieToward(location: CGPoint) {
        // 获得偏移向量
        let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
        // 获得偏移向量的长度
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        // 设置偏移向量的长度
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
    }
    
    // 连续触摸事件
    func sceneTouched(touchLocaction:CGPoint) {
        moveZombieToward(location: touchLocaction)
    }
    
    // 边界检测
    func boundsCheckZombie() {
        // 左下角
        let bottomLeft = CGPoint.zero
        // 右上角
        let topRight = CGPoint(x: size.width, y: size.height)
        
        // 如果x轴到达最左边
        if zombie.position.x <= bottomLeft.x {
            // x 轴停止向左移动
            zombie.position.x = bottomLeft.x
            // x 轴速度取反
            velocity.x = -velocity.x
        }
        
        // 如果x轴到达最右边
        if zombie.position.x >= topRight.x {
            // x 轴停止向右移动
            zombie.position.x = topRight.x
            // x 轴速度取反
            velocity.x = -velocity.x
        }
        
        // 如果y轴到达最下边
        if zombie.position.y <= bottomLeft.y {
            // y 轴停止向下移动
            zombie.position.y = bottomLeft.y
            // y 轴速度取反
            velocity.y = -velocity.y
        }
        
        // 如果y轴到达最上边
        if zombie.position.y >= topRight.y {
            // y 轴停止向上移动
            zombie.position.y = topRight.y
            // y 轴速度取反
            velocity.y = -velocity.y
        }
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath.init()
        // var transform = CGAffineTransform.init(translationX:0, y: -20)
        // Nil is not compatible with expected argument type 'UnsafePointer<CGAffineTransform>'
        // CGPathAddRect(path, transform, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//
//    override func didMove(to view: SKView) {
//
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//
//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocaction: touchLocation)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocaction: touchLocation)
    }

//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//

}
