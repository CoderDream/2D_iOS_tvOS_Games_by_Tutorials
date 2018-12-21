//
//  MyUtils.swift
//  ZombieConga
//
//  Created by coderdream on 2018/12/20.
//  Copyright © 2018 coderdream. All rights reserved.
//

import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (left: inout CGPoint, right: CGPoint) {
    left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (left: inout CGPoint, right: CGPoint) {
    left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (point: inout CGPoint, scalar: CGFloat) {
    point = point / scalar
}

#if !(arch(x86_64) || arch(arm64))
func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
    return CGFloat(atan(atan2f(Float(y), Float(x))))
}

func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif


extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }
    func normalized() -> CGPoint {
        return self / length()
    }
    var angle : CGFloat {
        return atan2(y, x)
    }
}

// 定义常量PI
let π = CGFloat(Double.pi)

// 两个角之间的最短角度
// 求得两个角度之差，去掉任何比360度大的部分，然后确定是向右旋转还是向左旋转
func shortestAngleBetween(angle1 : CGFloat, angle2 : CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    // %' is unavailable: Use truncatingRemainder instead
    // 使用 truncatingRemainder 方法进行浮点数取余
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoπ)
    // 之差大于360°
    if (angle >= π) {
        angle = angle - twoπ
    }
    // 之差小于-360°
    if (angle <= -π) {
        angle = angle + twoπ
    }
    
    return angle
}

extension CGFloat {
    // 大于0，正向；小于0，逆向
    func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }
    
    // 生成0到1之间的随机数
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    // 给出指定的最小值和最大值之间的一个随机数
    static func random(min : CGFloat, max : CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}

