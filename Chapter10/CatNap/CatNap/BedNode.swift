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
    }
}
