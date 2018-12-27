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
    }
}
