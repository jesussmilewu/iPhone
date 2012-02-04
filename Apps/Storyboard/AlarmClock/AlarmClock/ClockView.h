#import <UIKit/UIKit.h>

/** View-Klasse für die Anzeige des Ziffernblatts
 
 Alle Operationen zum Zeichnen der Zeiger erfolgen über CoreGraphic.
 
 */

typedef enum {
    PartitionOfDialNone = 0,
    PartitionOfDialHours,
    PartitionOfDialMinutes
} PartitionOfDial;

@interface ClockView : UIView

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong, readonly) NSCalendar *calendar;
@property (nonatomic) BOOL showDigits;
@property (nonatomic) PartitionOfDial partitionOfDial;

- (void)startAnimation;
- (void)stopAnimation;

@end
