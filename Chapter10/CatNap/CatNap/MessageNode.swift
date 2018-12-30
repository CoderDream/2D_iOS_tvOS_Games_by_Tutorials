//
//  MessageNode.swift
//  CatNap
//
//  Created by CoderDream on 2018/12/29.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import SpriteKit

class MessageNode : SKLabelNode {
    convenience init(message : String) {
        self.init(fontNamed: "AvenirNext-Regular")
        
        text = message
        fontSize = 256.0
        fontColor = SKColor.gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.collisionBitMask = PhysicsCategory.Edge
        physicsBody!.categoryBitMask = PhysicsCategory.Label
        physicsBody!.restitution = 0.7
    }
    
    
    // 挑战1：统计弹跳次数
    // 记录弹跳的次数
    private var bounceCount = 0
    
    // 增加计数器，在第4次弹跳的时候从父节点中删除该节点
    func didBounce() {
        bounceCount += 1
        if bounceCount >= 4 {
            removeFromParent()
        }
    }
}
