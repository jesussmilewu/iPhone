#import <UIKit/UIKit.h>
#import "DiaryEntry.h"
#import "AudioPlayerController.h"
#import "AudioRecorderController.h"

@protocol ItemViewControllerDelegate;

@interface ItemViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AudioRecorderDelegate> {
@private
    IBOutlet UIImageView *imageView;
    IBOutlet UITextView *textView;
    
    IBOutlet UIBarButtonItem *cameraButton;
    IBOutlet UIBarButtonItem *photoLibraryButton;
    IBOutlet UIBarButtonItem *playButton;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIImagePickerController *imagePicker;
@property (nonatomic, retain) IBOutlet AudioRecorderController *audioRecorder;
@property (nonatomic, retain) IBOutlet AudioPlayerController *audioPlayer;
@property (nonatomic, retain) DiaryEntry *item;

- (IBAction)takePhoto:(id)inSender;
- (IBAction)takePhotoFromLibrary:(id)inSender;
- (IBAction)recordAudio:(id)inSender;
- (IBAction)playAudio:(id)inSender;

- (IBAction)saveText:(id)inSender;
- (IBAction)revertText:(id)inSender;

@end