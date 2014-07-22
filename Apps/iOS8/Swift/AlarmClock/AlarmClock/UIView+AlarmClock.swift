//
//  UIView+AlarmClock.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 08.07.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

var cPI: CGFloat { return CGFloat(M_PI) }
var fPI: Float { return Float(M_PI) }

extension UIView {
    var midPoint: CGPoint {
    let theBounds = self.bounds;
        
        return CGPoint(x:theBounds.midX, y:theBounds.midY)
    }
    
    func pointWithRadius(inRadius:CGFloat, angle inAngle:Float)->CGPoint {
        let theCenter = self.midPoint
        
        return CGPoint(x:theCenter.x + inRadius * CGFloat(sin(inAngle)), y:theCenter.y - inRadius * CGFloat(cos(inAngle)))
    }
    
    func angleWithPoint(inPoint: CGPoint) -> Float {
        let theCenter = self.midPoint
        let theX = Float(inPoint.x - theCenter.x)
        let theY = Float(inPoint.y - theCenter.y)
        let theAngle = atan2f(theX, -theY)
        
        return theAngle < 0.0 ? theAngle + 2.0 * Float(M_PI) : theAngle
    }
}
