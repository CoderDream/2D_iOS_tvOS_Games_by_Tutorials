//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by coderdream on 2018/12/23.
//  Copyright © 2018 coderdream. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        // background.scaleMode = .aspectFill
        self.addChild(background)
        print("self.size: \(self.size)")
    }
    
    func sceneTapped() {
        let myScene = GameScene(size: self.size)
        myScene.scaleMode = self.scaleMode
        let reveal = SKTransition.flipHorizontal(withDuration: 1.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTapped()
    }
}
