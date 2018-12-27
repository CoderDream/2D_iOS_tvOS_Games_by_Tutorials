//
//  BedNode.swift
//  CatNap
//
//  Created by coderdream on 2018/12/27.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import SpriteKit

class BedNode : SKSpriteNode, CustomNodeEvents {
    func didMoveToScene() {
        print("bed added to scene")
        
        // 10.4.3 用代码创建简单实体
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody!.isDynamic = false
    }
}
