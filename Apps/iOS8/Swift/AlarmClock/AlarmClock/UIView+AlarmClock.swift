//
//  UIView+AlarmClock.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 08.07.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

extension UIView {
    var midPoint: CGPoint {
    let theBounds = self.bounds;
        
        return CGPoint(x:theBounds.midX, y:theBounds.midY)
    }
    
    func pointWithRadius(inRadius:CGFloat, angle inAngle:Double)->CGPoint {
        let theCenter = self.midPoint
        
        return CGPoint(x:theCenter.x + inRadius * CGFloat(sin(inAngle)), y:theCenter.y - inRadius * CGFloat(cos(inAngle)))
    }
    
    func angleWithPoint(inPoint: CGPoint) -> CGFloat {
        let theCenter = self.midPoint
        let theX = inPoint.x - theCenter.x
        let theY = inPoint.y - theCenter.y
        let theAngle = atan2f(theX, -theY);
        
        return theAngle < 0.0 ? theAngle + 2.0 * CGFloat(M_PI) : theAngle;
    }
}
