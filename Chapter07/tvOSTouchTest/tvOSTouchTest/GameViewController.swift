//
//  GameViewController.swift
//  tvOSTouchTest
//
//  Created by CoderDream on 2018/12/24.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let gameScene = GameScene.init(size: CGSize(width: 2048, height: 1536))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        gameScene.pressesBegan(presses, with: event)
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        gameScene.pressesEnded(presses, with: event)
    }

}
