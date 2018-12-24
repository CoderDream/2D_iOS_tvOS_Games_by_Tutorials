//
//  GameViewController.swift
//  AvailableFonts
//
//  Created by CoderDream on 2018/12/24.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let scene = GameScene.init(size: CGSize(width: 1920, height: 1080))
        let scene = GameScene.init(size: CGSize(width: 1920, height: 1080))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
