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
    let zombieMovePointsPerSec : CGFloat = 480.0
    // 移动速度，初始速度为0
    var velocity  = CGPoint.zero
    // 游戏区域
    let playableRect : CGRect
    // 最后触摸位置
    var lastTouchLocation :CGPoint?
    // 僵尸每秒应该旋转的弧度数
    let zombieRotateRadiansPerSec : CGFloat = 4.0 * π
    
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
        // 生成敌人
        spawnEnemy()
        // 定位精灵
        zombie.position = CGPoint(x: 400, y: 400)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // zombie.position = CGPoint(x: zombie.position.x + 8, y: zombie.position.y)
        // moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
        // moveSprite(sprite: zombie, velocity: velocity)
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        // print("\(dt * 1000) milliseconds since last update")
        
        if let lastTouchLocation = lastTouchLocation {
            
            // print("lastTouchLocation \(lastTouchLocation) ")
            let diff = lastTouchLocation - zombie.position
            
            // print("diff  \(diff) ")
            // 如果这个距离小于或等于僵尸将要在当前帧中移动的距离，那么就把僵尸的位置设置为最近一次触摸的位置，并将其速度设置为0
            if diff.length() <= zombieMovePointsPerSec * CGFloat(dt) {
                zombie.position = lastTouchLocation
                velocity = CGPoint.zero
            } else {
                // 移动精灵
                moveSprite(sprite: zombie, velocity: velocity)
                // 旋转僵尸
                rotateSprite(sprite: zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
            }
        }
        
        // 旋转僵尸
       // rotateSprite(sprite: zombie, direction: velocity)
        // 检查边界
        boundsCheckZombie()
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        // 1
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        // print("Amount to move: \(amountToMove)")
        // 2
        // sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        // 使用工具类
        sprite.position += amountToMove
        if sprite.position.y > 1080 {
            print("##### \(sprite.position.y)")
        }
    }
    
    func moveZombieToward(location: CGPoint) {
        // 获得偏移向量
        //let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
        let offset = location - zombie.position
        // 获得偏移向量的长度
        //let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        
        // 设置偏移向量的长度
        //let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
        // 正规化
        let direction = offset.normalized()
        //velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
        velocity = direction * zombieMovePointsPerSec
    }
    
    // 连续触摸事件
    func sceneTouched(touchLocaction:CGPoint) {
        // 点击时设置lastTouchLocation
        lastTouchLocation = touchLocaction
        moveZombieToward(location: touchLocaction)
    }
    
    // 边界检测
    func boundsCheckZombie() {
        // 左下角
        //let bottomLeft = CGPoint.zero
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        
        // 右上角
        //let topRight = CGPoint(x: size.width, y: size.height)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        //print(bottomLeft)
        //print(bottomLeft2)
        //print(topRight)
        //print(topRight2)
        
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
    
    // 画矩形
//    func debugDrawPlayableArea() {
//        let shape = SKShapeNode()
//        let path = CGMutablePath.init()
//        // var transform = CGAffineTransform.init(translationX:0, y: -20)
//        // TODO: Nil is not compatible with expected argument type 'UnsafePointer<CGAffineTransform>'
//        // CGPathAddRect(path, nil, playableRect)
//        shape.path = path
//        shape.strokeColor = SKColor.red
//        shape.lineWidth = 4.0
//        addChild(shape)
//    }
    
    // 旋转僵尸（新增参数：每秒旋转的角度）
    func rotateSprite(sprite: SKSpriteNode, direction : CGPoint, rotateRadiansPerSec : CGFloat) {
        sprite.zRotation = CGFloat(atan2(Double(direction.y), Double(direction.x)))
        // sprite.zPosition = direction.angle
        
        // 1.找出当前角与目标角之间的距离，称之为 shortest
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        // 2.计算这一帧要旋转的量，称之为 amountToRotate
        var amountToRotate = rotateRadiansPerSec * CGFloat(dt)
        // 3.如果 shortest 的绝对值小于 amountToRotate， 使用 shortest 来代替它
        amountToRotate = min(amountToRotate, abs(shortest))
        // 4.将amountToRotate 加到精灵的 zRotation 中，但是先将其与 sign() 相乘，以便可以朝着正确的方向旋转
        sprite.zRotation += shortest.sign() * amountToRotate
    }
    
    // 生成敌人
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        // 将其垂直居中地放在屏幕上，刚好在视图之外的右边
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: size.height / 2)
        addChild(enemy)
        
        // 沿着 x 轴向左移动，2秒钟之内移到刚好在屏幕的左边之外
        // let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: enemy.position.y), duration: 2.0)
        // enemy.run(actionMove)
        
        // 3.2 连续动作
        // 1 先移动到中间底部
        // let actionMidMove =  SKAction.move(to: CGPoint(x: size.width / 2, y: playableRect.minY + enemy.size.height / 2), duration: 1.0)
        let actionMidMove = SKAction.moveBy(x: -size.width / 2 - enemy.size.width / 2, y: -playableRect.height / 2 + enemy.size.height / 2, duration: 1.0)
        // 2 再移动到最左边
        //let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: enemy.position.y), duration: 1.0)
        let actionMove = SKAction.moveBy(x: -size.width / 2 - enemy.size.width / 2, y: playableRect.height / 2 - enemy.size.height / 2, duration: 1.0)
        // 等待动作
        let wait = SKAction.wait(forDuration: 0.25)
        // 3.4 运行代码块动作
        let logMessage = SKAction.run {
            print("Reached bottom!")
        }
//        // actionMidMove 的反向动作
//        let reverseMid = actionMidMove.reversed()
//        // reverseMove 的方向动作
//        let reverseMove = actionMove.reversed()
//        // 3 构造动作序列
//        let sequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove, reverseMove, logMessage, wait, reverseMid])
        let halfSquence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove])
        let sequence = SKAction.sequence([halfSquence, halfSquence.reversed()])
        // 4 连续动作
        enemy.run(sequence)
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
