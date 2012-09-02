#import <UIKit/UIKit.h>
#import "PieView.h"

@interface PieViewController : UIViewController

@property (nonatomic, weak) IBOutlet PieView *pieView;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UISwitch *animationSwitch;

- (IBAction)sliderValueChanged:(id)inSender;
- (IBAction)sliderDidFinish:(id)inSender;

@end
