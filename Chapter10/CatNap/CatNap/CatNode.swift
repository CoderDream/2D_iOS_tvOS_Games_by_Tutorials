//
//  CatNode.swift
//  CatNap
//
//  Created by coderdream on 2018/12/27.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import SpriteKit

class CatNode : SKSpriteNode, CustomNodeEvents {
    func didMoveToScene() {
        print("cat added to scene")
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())
        // 10.7 控制实体
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.Cat
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge
        // 10.7.4 检测实体之间的接触
        // 使用 categoryBitMask 设置物理实体的分类
        // 使用 collisionBitMask 设置物理实体的碰撞分类
        // 使用 cantackTestBitMask 检测一个物理实体和指定的对象分类之间的接触
        parent!.physicsBody!.contactTestBitMask = PhysicsCategory.Bed | PhysicsCategory.Edge        
    }
}
