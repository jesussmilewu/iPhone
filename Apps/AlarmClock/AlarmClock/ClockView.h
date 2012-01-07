#import <UIKit/UIKit.h>

/** View-Klasse für die Anzeige des Ziffernblatts
 
 Alle Operationen zum Zeichnen der Zeiger erfolgen über CoreGraphic.
 
 */

@interface ClockView : UIView

@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain, readonly) NSCalendar *calendar;
/**---------------------------------------------------------------------------------------
 * @name Name unter Task
 *  ---------------------------------------------------------------------------------------
 */

/** Starten der Zeiger-Animation.
 
 @param none
 @return none
 */
- (void)startAnimation;
/**---------------------------------------------------------------------------------------
 * @name Name unter Task
 *  ---------------------------------------------------------------------------------------
 */

/** Anhalten der Zeiger-Animation.
 
 @param none
 @return none
 */
- (void)stopAnimation;

@end
