//
//  GameViewController.swift
//  ZombieConga
//
//  Created by coderdream on 2018/12/17.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let scene = GameScene.init(size: CGSize(width: 1920, height: 1080))
        let scene = MainMenuScene.init(size: CGSize(width: 1920, height: 1080))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
