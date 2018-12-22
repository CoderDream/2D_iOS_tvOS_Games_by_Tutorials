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
    // 僵尸的动画动作
    let zombieAnimation : SKAction
    // 提前创建声音动作，避免声音暂停
    let catCollisionSound : SKAction = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    let enemyCollisionSound : SKAction = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    // 僵尸是否处于受保护的状态
    var invincible = false
    // 3.18 挑战3：康茄舞队
    // 小猫每秒钟的移动点数
    let catMovePointsPerSec : CGFloat = 480.0
    // 4.1 获胜或失败的条件
    // 僵尸的命的数目
    var lives = 5
    // 游戏是否结束
    var gameOver = false
    
    override init(size : CGSize) {
        let maxAspectRatio : CGFloat = 16.0 / 9.0                           // 1
        let playableHeight = size.width / maxAspectRatio                    // 2
        let playableMargin = (size.height - playableHeight) / 2.0           // 3
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)   // 4
        // 1 创建一个数组，存储在动画中运行的所有材质
        var textures : [SKTexture] = []
        // 2 新增zombie1、2、3、4
        for i in 1 ... 4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        // 3 添加第3帧和第2帧，这样得到序列1、2、3、4、3、2
        textures.append(textures[2])
        textures.append(textures[1])
        // 4
        zombieAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
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
        // let mySize = background.size
        // print("Size: \(mySize)")
        // 节点和z位置
        background.zPosition = -1
        
        // zombie.size = CGSize(width: 314, height: 204)
        // 定位精灵
        zombie.position = CGPoint(x: 400, y: 400)
        // 3.18 挑战3：康茄舞队
        // 把僵尸的zPosition设置为100，这会让僵尸出现在其他精灵之上。较大的z值会跑到屏幕之外，较小的值则会“陷入屏幕之中”，默认的z值为0
        zombie.zPosition = 100
        // 把精灵加到场景
        addChild(zombie)
        // 3.9 动画动作
        // zombie.run(SKAction.repeatForever(zombieAnimation))
        // 生成敌人
        // spawnEnemy()
        // 3.7 定期生成
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnEnemy), SKAction.wait(forDuration: 2.0)])))
        // 3.11 缩放动画，生成小猫
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnCat), SKAction.wait(forDuration: 1.0)])))
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
                // 3.10 停止动作
                stopZombieAnimation()
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
        // 3.14 碰撞检测
        //checkCollisions()
        // 3.18 挑战3：康茄舞队
        moveTrain()
        // 4.1 获胜或失败的条件
        if lives <= 0 && !gameOver {
            gameOver = true
            print("You lost!")
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    // 移动精灵
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
    
    // 僵尸向前运动
    func moveZombieToward(location: CGPoint) {
        // 3.10 开始动作
        startZombieAnimation()
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
    
    // 触摸事件
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
    
    
    // 开始僵尸动画
    func startZombieAnimation() {
        if zombie.action(forKey: "animation") == nil {
            zombie.run(SKAction.repeatForever(zombieAnimation), withKey: "animation")
        }
    }
    
    // 停止僵尸动画
    func stopZombieAnimation() {
        zombie.removeAction(forKey: "animation")
    }
    
    // 生成敌人
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        // 为节点设置名称
        enemy.name = "enemy"
        // 将其垂直居中地放在屏幕上，刚好在视图之外的右边
        //enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: size.height / 2)
        // 3.7 定期生成
        enemy.position = CGPoint(x: size.width + enemy.size.width / 2, y: CGFloat.random(
            min: playableRect.minY + enemy.size.height / 2,
            max: playableRect.maxY - enemy.size.height / 2))
        addChild(enemy)
        
        // 沿着 x 轴向左移动，2秒钟之内移到刚好在屏幕的左边之外
        // let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: enemy.position.y), duration: 2.0)
        // enemy.run(actionMove)
        
        // 3.2 连续动作
        // 1 先移动到中间底部
        // let actionMidMove =  SKAction.move(to: CGPoint(x: size.width / 2, y: playableRect.minY + enemy.size.height / 2), duration: 1.0)
//        let actionMidMove = SKAction.moveBy(x: -size.width / 2 - enemy.size.width / 2, y: -playableRect.height / 2 + enemy.size.height / 2, duration: 1.0)
//        // 2 再移动到最左边
//        //let actionMove = SKAction.move(to: CGPoint(x: -enemy.size.width / 2, y: enemy.position.y), duration: 1.0)
//        let actionMove = SKAction.moveBy(x: -size.width / 2 - enemy.size.width / 2, y: playableRect.height / 2 - enemy.size.height / 2, duration: 1.0)
//        // 等待动作
//        let wait = SKAction.wait(forDuration: 0.25)
//        // 3.4 运行代码块动作
//        let logMessage = SKAction.run {
//            print("Reached bottom!")
//        }
//        // actionMidMove 的反向动作
//        let reverseMid = actionMidMove.reversed()
//        // reverseMove 的方向动作
//        let reverseMove = actionMove.reversed()
//        // 3 构造动作序列
//        let sequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove, reverseMove, logMessage, wait, reverseMid])
//        let halfSquence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove])
//        let sequence = SKAction.sequence([halfSquence, halfSquence.reversed()])
//        // 4 连续动作
//        // enemy.run(sequence)
//        // 3.6 重复动作
//        let repeatAction = SKAction.repeatForever(sequence)
//        enemy.run(repeatAction)
        let actionMove = SKAction.moveTo(x: -enemy.size.width / 2, duration: 2.0)
        enemy.run(actionMove)
        // 3.8 从父节点删除动作
        let actionRemove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    // 生成小猫
    func spawnCat() {
        // 1 生成小猫，位置随机，缩放级别为0，使得小猫不可见
        let cat = SKSpriteNode(imageNamed: "cat")
        // 为节点设置名称
        cat.name = "cat"
        cat.position = CGPoint(
            x: CGFloat.random(min: playableRect.minX,
                              max: playableRect.maxX),
            y: CGFloat.random(min: playableRect.minY,
                              max: playableRect.maxY))
        cat.setScale(0)
        addChild(cat)
        // 2 创建一个动作，调用scale(to:duration)来把小猫放大到正常大小，这个动作不是反向的，所以再创建一个类似的动作，将小猫缩放级别变回到0
        // 在动作序列中，小猫先出现，等待一会儿，消失，然后将其从父节点中删除
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        // let wait = SKAction.wait(forDuration: 10.0)
        // 3.12 旋转操作
        // 初始位置先逆时针旋转11.25°
        cat.zRotation = -π / 16.0
        // 0.5秒逆时针旋转22.5°
        let leftWiggle = SKAction.rotate(byAngle: π / 8.0, duration: 0.5)
        // 0.5秒顺时针旋转22.5°，这个完整的摇摆一共用了1秒钟时间
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        // let wiggleWait = SKAction.repeat(fullWiggle, count: 10)
        // 3.13 组动作
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        // let actions = [appear, wait, disappear, removeFromParent]
        // let actions = [appear, wiggleWait, disappear, removeFromParent]
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
    
    func zombieHitCat(cat: SKSpriteNode) {
        // cat.removeFromParent()
        // 3.18 挑战3：康茄舞队
        // 1. 把小猫的名字设置为 train
        cat.name = "train"
        // 2. 停止当前的小猫上运行的所有动作
        cat.removeAllActions()
        // 3. 将小猫的缩放级别设置为1，将其旋转设置为0
        cat.setScale(1.0)
        cat.zPosition = 0
        // 4. 小猫0.2秒变绿
        let turnGreen = SKAction.colorize(with: SKColor.green, colorBlendFactor: 1.0, duration: 0.2)
        cat.run(turnGreen)
        
        // 3.16 动作声音
        // run(SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false))
        run(catCollisionSound)
    }
    
    func zombieHitEnemy(enemy : SKSpriteNode) {
        enemy.removeFromParent()
        // 3.16 动作声音
        // run(SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false))        
        run(enemyCollisionSound)
        // 4.1 获胜或失败的条件
        lostCats()
        lives -= 1
        // 定制闪烁动作
        invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        // 如果僵尸和一个猫女士碰撞，不要从场景中删除猫女士。相反，把僵尸设置为受保护的状态。
        // 接下来，运行一个连续动作，首先让僵尸在3秒钟之内闪烁10次。
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder =  Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        // 把僵尸的 hidden 设置为 false，以确保不管怎样它都是可见的，并且不再受保护
        let setHidden = SKAction.run {
            self.zombie.isHidden = false
            self.invincible = false
        }
        zombie.run(SKAction.sequence([blinkAction, setHidden]))
    }
    
    func checkCollisions() {
        var hitCats : [SKSpriteNode] = []
        enumerateChildNodes(withName: "cat") { node, _ in
            let cat = node as! SKSpriteNode
            // CGRect.intersects
            if cat.frame.intersects(self.zombie.frame) {
                hitCats.append(cat)
            }
        }
        for cat in hitCats {
            zombieHitCat(cat: cat)
        }
        
        var hitEnemies : [SKSpriteNode] = []
        enumerateChildNodes(withName: "enemy") { node, _ in
            let enemy = node as! SKSpriteNode
            if enemy.frame.insetBy(dx: 20, dy: 20).intersects(self.zombie.frame) {
                hitEnemies.append(enemy)
            }
        }
        
        for enemy in hitEnemies {
            zombieHitEnemy(enemy: enemy)
        }
    }
    
    // 创建康茄舞队
    func moveTrain() {
        // 4.1 获胜或失败的条件
        var trainCount = 0
        
        var targetPosition = zombie.position
        
        enumerateChildNodes(withName: "train") {
            node, _ in
            // 4.1 获胜或失败的条件
            trainCount += 1
            if !node.hasActions() {
                let actionDuration = 0.3
                // 计算小猫的当前位置和目标位置之间的偏移量
                let offset = targetPosition - node.position
                // 计算出x指向偏移方向的一个单位向量
                let direction = offset.normalized()
                // 得到指向偏移的方向的一个向量，其长度为小猫每秒钟移动的点数
                let amountToMovePerSec = direction * self.catMovePointsPerSec
                // 小猫在接下来的actionDuration秒内应该移动的偏移量。（需要强制转换成CGFloat）
                let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
                // 根据amountToMove把小猫移动一个相对的量
                let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
                node.run(moveAction)
            }
            targetPosition = node.position
        }
        
        // 4.1 获胜或失败的条件
        if trainCount >= 15 && !gameOver {
            gameOver = true
            print("You win!")
        }
    }
    
    // 减少小猫
    func lostCats() {
        // 1 设置一个变量来记录到目前为止从康茄舞队中删除的小猫的数目，然后遍历康茄舞队
        var lostCount = 0
        enumerateChildNodes(withName: "train") {
            (node, stop) in
            // 2 return CGPoint 根据小猫的当前位置求得一个随机偏移量
            var randomSpot = node.position
            randomSpot.x += CGFloat.random(min: -100, max: 100)
            randomSpot.y += CGFloat.random(min: -100, max: 100)
            // 3 运行一个动画，让小猫朝着一个随机的位置移动，一路上旋转并且缩放到0.最后，该动画将小猫从场景中删除。
            // 这里还将小猫的名字设置为一个空的字符串，以便不再将其看作是一只正常的猫或者是康茄舞队中的一只猫。
            node.name = ""
            node.run(
                SKAction.sequence([
                        SKAction.group([
                            SKAction.rotate(byAngle: π * 4, duration: 1.0),
                            SKAction.move(to: randomSpot, duration: 1.0),
                            SKAction.scale(to: 0, duration: 1.0)
                            ]),
                        SKAction.removeFromParent()
                    ]))
            // 4 更新小猫的数量，一旦删除>=2只小猫，停止遍历
            lostCount += 1
            if lostCount >= 2 {
                // Value of type 'UnsafeMutablePointer<ObjCBool>' has no member 'memory'
                //stop.memory = true
                //stop
                //break
                stop.initialize(to: true)
                print("stop.initialize(to:)")
            }
        }
    }
    
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

}
