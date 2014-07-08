//
//  ClockView.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 21.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

var kPI: CGFloat { return  }

extension UIView {
    var midPoint: CGPoint {
    let theBounds = bounds
        
        return CGPoint(x:theBounds.midX, y:theBounds.midY)
    }
    
    func pointWithRadius(inRadius:CGFloat, angle inAngle:CGFloat)->CGPoint {
        let theCenter = midPoint
        
        return CGPoint(x:theCenter.x + inRadius * CGFloat(sin(inAngle)), y:theCenter.y - inRadius * CGFloat(cos(inAngle)))
    }
    
    func angleWithPoint(inPoint: CGPoint) -> CGFloat {
        let theCenter = midPoint
        let theX = inPoint.x - theCenter.x
        let theY = inPoint.y - theCenter.y
        let theAngle = atan2f(theX, -theY)
        
        return theAngle < 0.0 ? theAngle + 2.0 * kPI : theAngle
    }
}

class ClockView: UIView {
    var time : NSDate = NSDate() {
    didSet {
        setNeedsDisplay()
    }
    }
    var calendar : NSCalendar = NSCalendar.currentCalendar()
    @IBInspectable var secondHandColor : UIColor?
    var timer : NSTimer?
    
    func startAnimation() {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:"updateTime", userInfo: nil, repeats: true)
        }
    }

    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTime() {
        time = NSDate()
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }
    
    override func drawRect(inRect: CGRect) {
        let theContext = UIGraphicsGetCurrentContext()
        let theBounds = bounds
        let theRadius = theBounds.width / 2
        
        CGContextSaveGState(theContext)
        CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0)
        CGContextAddEllipseInRect(theContext, theBounds)
        CGContextFillPath(theContext)
        CGContextAddEllipseInRect(theContext, theBounds)
        CGContextClip(theContext)
        CGContextSetStrokeColorWithColor(theContext, tintColor.CGColor)
        CGContextSetFillColorWithColor(theContext, tintColor.CGColor)
        CGContextSetLineWidth(theContext, theRadius / 20.0)
        CGContextSetLineCap(theContext, kCGLineCapRound)
        for i in 0..<60 {
            let theAngle = CGFloat(i) * kPI / 30.0
            
            if(i % 5 == 0) {
                let theInnerRadius = theRadius * (i % 15 == 0 ? 0.7 : 0.8)
                let theInnerPoint = pointWithRadius(theInnerRadius, angle: theAngle)
                let theOuterPoint = pointWithRadius(theRadius, angle:theAngle)
                
                CGContextMoveToPoint(theContext, theInnerPoint.x, theInnerPoint.y)
                CGContextAddLineToPoint(theContext, theOuterPoint.x, theOuterPoint.y)
                CGContextStrokePath(theContext)
            }
            else {
                let thePoint = pointWithRadius(theRadius * 0.95, angle:theAngle)
                
                CGContextAddArc(theContext, thePoint.x, thePoint.y, theRadius / 40.0, 0, CGFloat(2 * M_PI), 1)
                CGContextFillPath(theContext)
            }
        }
        drawClockHands()
        CGContextRestoreGState(theContext)
    }
    
    func drawClockHands() {
        let theContext = UIGraphicsGetCurrentContext()
        let theCenter = midPoint
        let theRadius = bounds.width / 2.0
        let theComponents = calendar.components(NSCalendarUnit.HourCalendarUnit |
            NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate:time)
        let theSecond = CGFloat(theComponents.second) * kPI / 30.0
        let theMinute = CGFloat(theComponents.minute) * kPI / 30.0
        let theHour = (CGFloat(theComponents.hour) + CGFloat(theComponents.minute) / 60.0) * kPI / 6.0
        // Stundenzeiger zeichnen
        var thePoint = pointWithRadius(theRadius * 0.7, angle:theHour)
        
        CGContextSetRGBStrokeColor(theContext, 0.25, 0.25, 0.25, 1.0)
        CGContextSetLineWidth(theContext, theRadius / 20.0)
        CGContextSetLineCap(theContext, kCGLineCapButt)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
        // Minutenzeiger zeichnen
        thePoint = pointWithRadius(theRadius * 0.9, angle:theMinute)
        CGContextSetLineWidth(theContext, theRadius / 40.0)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
        // Sekundenzeiger zeichnen
        let theColor = secondHandColor? ? secondHandColor! : UIColor.redColor()
        
        thePoint = pointWithRadius(theRadius * 0.95, angle:theSecond)
        CGContextSetLineWidth(theContext, theRadius / 80.0)
        CGContextSetStrokeColorWithColor(theContext, theColor.CGColor)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
    }
}

class ClockControl: UIControl {
    var savedAngle:CGFloat = 0.0
    var time : NSTimeInterval = 0.0 {
    didSet {
        setNeedsDisplay()
    }
    }
    var angle : CGFloat {
    get {
        return CGFloat(time * M_PI) / 21600.0
    }
    set {
        time = 21600.0 * NSTimeInterval(newValue) / NSTimeInterval(M_PI)
    }
    }
    
    override func pointInside(inPoint: CGPoint, withEvent inEvent: UIEvent!) -> Bool {
        let theAngle = angleWithPoint(inPoint)
        let theDelta = fabsf(theAngle - angle)
        
        return theDelta < 4.0 * kPI / 180.0
    }
    
    func updateAngleWithTouch(inTouch:UITouch!) {
        let thePoint = inTouch.locationInView(self)
        
        angle = angleWithPoint(thePoint)
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    override func beginTrackingWithTouch(inTouch: UITouch!, withEvent inEvent: UIEvent!) -> Bool {
        savedAngle = angle
        updateAngleWithTouch(inTouch)
        return true
    }
    
    override func continueTrackingWithTouch(inTouch: UITouch!, withEvent inEvent: UIEvent!) -> Bool {
        updateAngleWithTouch(inTouch)
        return true
    }
    
    override func endTrackingWithTouch(inTouch: UITouch!, withEvent inEvent: UIEvent!) {
        updateAngleWithTouch(inTouch)
    }
    
    override func cancelTrackingWithEvent(inEvent: UIEvent!) {
        angle = savedAngle
    }
    
    override func drawRect(inRect: CGRect) {
        let theContext = UIGraphicsGetCurrentContext()
        let theBounds = bounds
        let theCenter = midPoint
        let theRadius = theBounds.width / 2.0
        let thePoint = pointWithRadius(theRadius * 0.7, angle:CGFloat(time) * kPI / 21600.0)
        var theColor = tintColor
        
        if(tracking) {
            theColor = theColor.colorWithAlphaComponent(0.5)
        }
        CGContextSaveGState(theContext)
        CGContextSetStrokeColorWithColor(theContext, theColor.CGColor)
        CGContextSetLineWidth(theContext, 8.0)
        CGContextSetLineCap(theContext, kCGLineCapRound)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
        CGContextRestoreGState(theContext)
    }
}