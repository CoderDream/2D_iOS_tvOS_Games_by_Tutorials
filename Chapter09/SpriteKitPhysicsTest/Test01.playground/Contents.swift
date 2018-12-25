//import UIKit
//import SpriteKit
//import PlaygroundSupport
//
//let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: 480, height: 320))
//let scene = SKScene(size: CGSize(width: 480, height: 320))
//sceneView.showsFPS = true
//sceneView.presentScene(scene)
//
//PlaygroundPage.current.needsIndefiniteExecution = true
//PlaygroundPage.current.liveView = sceneView


// 1
import UIKit
import XCPlayground

import PlaygroundSupport

// 2
class Responder: NSObject {
    
    @objc func tap() {
        print("Button pressed")
    }
}
let responder = Responder()

@objc func tap() {
    print("Button pressed")
}

func tap2() {
    print("Button pressed")
}
// 3
let button = UIButton(type: .system)
button.setTitle("Button", for: .normal)
// Use of string literal for Objective-C selectors is deprecated; use '#selector' instead
button.addTarget(responder, action: #selector(tap()), for: .touchUpInside)
//button.addTarget(responder, action: "tap", forControlEvents: .touchUpInside)
button.sizeToFit()
button.center = CGPoint(x: 50, y: 25)

// 4
let frame = CGRect(x: 0, y: 0, width: 100, height: 50)
let view = UIView(frame: frame)
view.addSubview(button)
//XCPlaygroundPage.currentPage.liveView = view

PlaygroundPage.current.liveView = view
