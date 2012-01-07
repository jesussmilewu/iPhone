#import <UIKit/UIKit.h>

/** Diese Klasse erstellt das Ziffernblatt und die Zeiger des Weckers.
 
 Alle Operationen zum Zeichnen der Zeiger erfolgen über CoreGraphic.
 
 */

@interface ClockControl : UIControl

@property (nonatomic) NSTimeInterval time;
@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat savedAngle;

/**---------------------------------------------------------------------------------------
 * @name angleWithPoint:
 *  ---------------------------------------------------------------------------------------
 */

/** This is the first super-awesome method.
 
 You can also add lists, but have to keep an empty line between these blocks.
 
 - One
 - Two
 - Three
 
 @param string A parameter that is passed in.
 @return Whatever it returns.
 */
- (CGFloat)angleWithPoint:(CGPoint)inPoint;

@end
