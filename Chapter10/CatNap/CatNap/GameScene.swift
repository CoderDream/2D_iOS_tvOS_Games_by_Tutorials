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

class GameScene: SKScene {
    // 10.3 将精灵连接到变量
    var bedNode : BedNode!
    var catNode : CatNode!
    
    override func didMove(to view: SKView) {
        // 10.1 开始
        // Calculate playable margin
        let maxAspectRatio : CGFloat = 16.0 / 9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin : CGFloat = (size.height - maxAspectRatioHeight) / 2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - maxAspectRatioHeight * 2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        
        // 10.2 定制节点类
        enumerateChildNodes(withName: "//*", using: {
            node, _ in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
            }
        })
        
        // 10.3 将精灵连接到变量
        // Treating a forced downcast to 'BedNode' as optional will never produce 'nil'
        bedNode = childNode(withName: "bed") as? BedNode
        catNode = childNode(withName: "//cat_body") as? CatNode
        
        bedNode.setScale(1.5)
        catNode.setScale(1.5)
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
