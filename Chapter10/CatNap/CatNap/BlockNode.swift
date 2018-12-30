//
//  BlockNode.swift
//  CatNap
//
//  Created by coderdream on 2018/12/28.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = false
        
        // 销毁木头，并且将其从场景中移除
        run(SKAction.sequence([
                SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
                SKAction.scale(to: 0.8, duration: 0.1),
                SKAction.removeFromParent()
            ]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("destroy block")
        interact()
    }
}

