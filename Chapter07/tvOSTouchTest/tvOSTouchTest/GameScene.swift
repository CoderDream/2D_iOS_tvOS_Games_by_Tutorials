//
//  GameScene.swift
//  tvOSTouchTest
//
//  Created by CoderDream on 2018/12/24.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // 1 初始化一个标签节点
    let pressLabel = SKLabelNode(fontNamed: "Chalkduster")
    // 2 一个简单色块的精灵节点
    let touchBox = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 100))
    
    override func didMove(to view: SKView) {
        // 3 设置文本内容及y大小、对齐方式、位置等信息
        pressLabel.text = "Move your finger!"
        pressLabel.fontSize = 200
        pressLabel.verticalAlignmentMode = .center
        pressLabel.horizontalAlignmentMode = .center
        pressLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(pressLabel)
        
        // 4
        addChild(touchBox)
    }
    
    // 5 处理程序所接收到的坐标
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchBox.position = location
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchBox.position = location
        }
    }
    
}
