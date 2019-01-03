//
//  GameScene.swift
//  CatNap
//
//  Created by CoderDream on 2018/12/25.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol CustomNodeEvents {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let None:    UInt32 = 0
    static let Cat:     UInt32 = 0b1        // 1
    static let Block:   UInt32 = 0b10       // 2
    static let Bed:     UInt32 = 0b100      // 4
    static let Edge:    UInt32 = 0b1000     // 8
    static let Label:   UInt32 = 0b10000    // 16
}

// 10.7.3 检测实体之间的碰撞
class GameScene: SKScene, SKPhysicsContactDelegate {
    // 10.3 将精灵连接到变量
    var bedNode : BedNode!
    var catNode : CatNode!
    // 10.8.2 失败场景
    var playable = true
    // 11.3 加载关卡
    // 1
    var currentLevel : Int = 0
    
    // 2
    class func level(levelNum : Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel  = levelNum
        scene.scaleMode = .aspectFill
        return scene
    }
    
    override func didMove(to view: SKView) {
        // 10.1 开始
        // Calculate playable margin
        let maxAspectRatio : CGFloat = 16.0 / 9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin : CGFloat = (size.height - maxAspectRatioHeight) / 2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        
        // 10.7.3 检测实体之间的碰撞
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        // 10.2 定制节点类
        enumerateChildNodes(withName: "//*", using: {
            node, _ in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
            }
        })
        
        // 10.3 将精灵连接到变量
        //Could not cast value of type 'SKSpriteNode' (0x23ab88660) to 'CatNap.BedNode' (0x10101f1c8).
        //2018-12-29 14:57:18.598642+0800 CatNap[21462:2364977] Could not cast value of type 'SKSpriteNode' (0x23ab88660) to 'CatNap.BedNode' (0x10101f1c8).
        // Treating a forced downcast to 'BedNode' as optional will never produce 'nil'
        bedNode = childNode(withName: "bed") as? BedNode
        catNode = childNode(withName: "//cat_body") as? CatNode
        print("bedNode & catNode")
        print(bedNode)
        print(catNode)
        print("Done")
//        bedNode.setScale(1.5)
//        catNode.setScale(1.5)
        // 10.6 背景音乐
        SKTAudio.sharedInstance().playBackgroundMusic(filename: "backgroundMusic.mp3")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 挑战1：统计弹跳次数
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Label | PhysicsCategory.Edge {
            let labelNode = (contact.bodyA.categoryBitMask == PhysicsCategory.Label) ? contact.bodyA.node : contact.bodyB.node
            
            if let message = labelNode as? MessageNode {
                message.didBounce()
            }
        }
        
        // 防止多次成功地接触
        if !playable {
            return
        }
        
        // let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
//        print("1   Cat: \(PhysicsCategory.Cat)")
//        print("2   Bed: \(PhysicsCategory.Bed )")
//        print("3  Edge: \(PhysicsCategory.Edge)")
//        print("4 bodyA: \(contact.bodyA.categoryBitMask)")
//        print("5 bodyB: \(contact.bodyB.categoryBitMask)")
//        print("6      : \(collision)")
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
            print("SUCCESS")
            // 10.8.4 获胜场景
            win()
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
            print("FAIL")
            // 10.8.2 失败场景
            lose()
        }
    }
    
    // 显示消息
    func inGameMessage(text : String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    // 重新启动当前关卡
    @objc func newGame() {
//        let scene = GameScene(fileNamed: "GameScene")
//        // 场景的缩放模式不变
//        scene!.scaleMode = scaleMode
//        // 删除当前的场景并传入新场景
//        view!.presentScene(scene)
        view!.presentScene(GameScene.level(levelNum: currentLevel))
    }
    
    // 游戏失败
    func lose() {
        playable = false
        // 1 播放音乐
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        run(SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false))
        
        // 2 生成消息
        inGameMessage(text: "Try again...")
        
        // 3 等候5秒，重新开始游戏
        perform(#selector(newGame), with: nil, afterDelay: 5)
        
        // 10.8.3 播放动画，叫醒小猫
        catNode.wakeUp()
    }
    
    // 游戏获胜
    func win() {
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        run(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))
        
        inGameMessage(text: "Nice job!")
        
        perform(#selector(newGame), with: nil, afterDelay: 3)
        
        // 10.8.4 获胜场景
        // 小猫蜷缩休息
        catNode.curlAt(scenePoint: bedNode.position)
    }
    
    override func didSimulatePhysics() {
        if playable {
            // 检测小猫是否向某一边倾斜超过了25度
            print(abs(catNode.parent!.zRotation))
            if abs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
                lose()
            }
        }
    }
}
