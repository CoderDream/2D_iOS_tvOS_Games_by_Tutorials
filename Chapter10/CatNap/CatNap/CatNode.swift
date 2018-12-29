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
    
    // 10.8.2 失败场景
    func wakeUp() {
        // 1 遍历小猫所有的子节点，即小猫的各个”部分“，并且将其从小猫的身体中删除
        for child in children {
            child.removeFromParent()
        }
        // 材质设置为nil
        texture = nil
        // 背景为透明色
        color = SKColor.clear
        
        // 2 加载 CatWakeUp.sks 并且传递名为 cat_awake 的场景子节点
        let catAwake = SKSpriteNode(fileNamed: "CatWakeUp")!.childNode(withName: "cat_awake")
        
        // 3 修改 CatWakeUp.sks 场景中精灵的修改父节点为 CatNode，并且设置节点的位置
        catAwake?.move(toParent: self)
        catAwake?.position = CGPoint(x: -30, y: 100)
    }
}
