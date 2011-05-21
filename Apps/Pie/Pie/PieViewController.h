#import <UIKit/UIKit.h>
#import "PieView.h"

@interface PieViewController : UIViewController {
    @private
}

@property (nonatomic, retain) IBOutlet PieView *pieView;

- (IBAction)sliderValueChanged:(id)inSender;
- (IBAction)sliderDidFinish:(id)inSender;

@end
