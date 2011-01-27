#import <UIKit/UIKit.h>

@class ClockView;

@interface ClockViewController : UIViewController {
	@private
    IBOutlet ClockView *clockView;
    IBOutlet UIButton *switchButton;
}
- (IBAction)switchAnimation:(UIButton *)inSender;

@end

