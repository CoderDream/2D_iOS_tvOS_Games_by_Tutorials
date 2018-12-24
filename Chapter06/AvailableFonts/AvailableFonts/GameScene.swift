//
//  GameScene.swift
//  AvailableFonts
//
//  Created by CoderDream on 2018/12/24.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var familyIdx : Int = 0
    
    override init(size : CGSize) {
        super.init(size : size)
        showCurrentFamily()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    func showCurrentFamily() {
        // 1
        removeAllChildren()
        
        // 2
        let familyName = UIFont.familyNames[familyIdx]
        print("familyName: \(familyName)")
        
        // 3
        let fontNames = UIFont.fontNames(forFamilyName: familyName)
        
        // 4
        for (idx, fontName) in fontNames.enumerated() {
            let label = SKLabelNode(fontNamed: fontName)
            label.text = fontName
            label.position = CGPoint(
                x: size.width / 2,
                y: (size.height * (CGFloat(idx + 1))) / (CGFloat(fontNames.count) + 1))
            label.fontSize = 32
            label.verticalAlignmentMode = .center
            addChild(label)
        }
     
//        let fys = UIFont.familyNames
//
//        for fy in fys {
//            let fts = UIFont.fontNames(forFamilyName: fy)
//            for ft in fts {
//                print(ft)
//            }
//        }
//
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        familyIdx += 1
        if familyIdx >= UIFont.familyNames.count {
            familyIdx = 0
        }
        showCurrentFamily()
    }
    
   
}

