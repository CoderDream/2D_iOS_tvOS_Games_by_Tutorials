import PlaygroundSupport
import Foundation
import SpriteKit
// import TiledKit

//let level = Level(fromFile: "Dungeon", using: [], for: SpriteKit.self)

let scene = SKScene(size: CGSize(width: 320, height: 256))
scene.backgroundColor = UIColor.cyan
scene.scaleMode = .aspectFill

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 320, height: 256))
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
