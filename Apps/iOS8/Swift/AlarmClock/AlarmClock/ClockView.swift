//
//  ClockView.swift
//  AlarmClock
//
//  Created by Clemens Wagner on 21.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

import UIKit

extension UIView {
    var midPoint: CGPoint {
    let theBounds = self.bounds;
        return CGPointMake(theBounds.midX, theBounds.midY)
    }
    
    func pointWithRadius(inRadius:CGFloat, angle inAngle:Double)->CGPoint {
        let theCenter = self.midPoint;
        
        return CGPointMake(theCenter.x + inRadius * CGFloat(sin(inAngle)), theCenter.y - inRadius * CGFloat(cos(inAngle)));
    }
    
    func angleWithPoint(inPoint: CGPoint) -> Double {
        let theCenter = self.midPoint;
        let theX: Double = Double(inPoint.x - theCenter.x);
        let theY: Double = Double(inPoint.y - theCenter.y);
        let theAngle: Double = atan2(theX, -theY);
        
        return theAngle < 0.0 ? theAngle + 2.0 * M_PI : theAngle;
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
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setNeedsDisplay()
    }
    
    func startAnimation() {
        if self.timer == nil {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector:"updateTime", userInfo: nil, repeats: true)
        }
    }

    func stopAnimation() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func updateTime() {
        self.time = NSDate()
    }

    override func drawRect(inRect: CGRect) {
        let theContext = UIGraphicsGetCurrentContext()
        let theBounds = self.bounds
        let theRadius = theBounds.width / 2
        
        CGContextSaveGState(theContext)
        CGContextSetRGBFillColor(theContext, 1.0, 1.0, 1.0, 1.0)
        CGContextAddEllipseInRect(theContext, theBounds)
        CGContextFillPath(theContext)
        CGContextAddEllipseInRect(theContext, theBounds)
        CGContextClip(theContext)
        CGContextSetStrokeColorWithColor(theContext, self.tintColor.CGColor)
        CGContextSetFillColorWithColor(theContext, self.tintColor.CGColor)
        CGContextSetLineWidth(theContext, theRadius / 20.0)
        CGContextSetLineCap(theContext, kCGLineCapRound)
        for i in 0..60 {
            let theAngle = Double(i) * M_PI / 30.0
            
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
        self.drawClockHands()
        CGContextRestoreGState(theContext)
    }
    
    func drawClockHands() {
        let theContext = UIGraphicsGetCurrentContext()
        let theCenter = self.midPoint
        let theRadius = self.bounds.width / 2.0
        let theComponents = self.calendar.components(NSCalendarUnit.HourCalendarUnit |
            NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate:self.time)
        let theSecond = Double(theComponents.second) * M_PI / 30.0
        let theMinute = Double(theComponents.minute) * M_PI / 30.0
        let theHour = (Double(theComponents.hour) + Double(theComponents.minute) / 60.0) * M_PI / 6.0
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
        let theColor = self.secondHandColor? ? self.secondHandColor! : UIColor.redColor()
        
        thePoint = pointWithRadius(theRadius * 0.95, angle:theSecond)
        CGContextSetLineWidth(theContext, theRadius / 80.0)
        CGContextSetStrokeColorWithColor(theContext, theColor.CGColor)
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y)
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y)
        CGContextStrokePath(theContext)
    }
}

class ClockControl: UIControl {
    var savedAngle:Double = 0.0
    var time : NSTimeInterval = 0.0 {
    didSet {
        setNeedsDisplay()
    }
    }
    var angle : Double {
    get {
        return time * M_PI / 21600.0
    }
    set {
        time = 21600.0 * newValue / M_PI;
    }
    }
    
    override func pointInside(inPoint: CGPoint, withEvent inEvent: UIEvent!) -> Bool {
        let theAngle = self.angleWithPoint(inPoint)
        let theDelta = fabs(theAngle - self.angle);
        
        return theDelta < 4.0 * M_PI / 180.0;
    }
    
    func updateAngleWithTouch(inTouch:UITouch!) {
        let thePoint = inTouch.locationInView(self)
        
        self.angle = angleWithPoint(thePoint)
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    override func beginTrackingWithTouch(inTouch: UITouch!, withEvent inEvent: UIEvent!) -> Bool {
        self.savedAngle = self.angle
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
        self.angle = self.savedAngle;
    }
    
    override func drawRect(inRect: CGRect) {
        let theContext = UIGraphicsGetCurrentContext()
        let theBounds = self.bounds;
        let theCenter = self.midPoint
        let theRadius = theBounds.width / 2.0
        let thePoint = pointWithRadius(theRadius * 0.7, angle: self.time * M_PI / 21600.0)
        var theColor = self.tintColor
        
        if(self.tracking) {
            theColor = theColor.colorWithAlphaComponent(0.5)
        }
        CGContextSaveGState(theContext);
        CGContextSetStrokeColorWithColor(theContext, theColor.CGColor);
        CGContextSetLineWidth(theContext, 8.0);
        CGContextSetLineCap(theContext, kCGLineCapRound);
        CGContextMoveToPoint(theContext, theCenter.x, theCenter.y);
        CGContextAddLineToPoint(theContext, thePoint.x, thePoint.y);
        CGContextStrokePath(theContext);
        CGContextRestoreGState(theContext);
    }
}