#import "ItemViewController.h"
#import "AudioRecorderController.h"
#import "DiaryEntry.h"
#import "Medium.h"
#import "UIImage+ImageTools.h"
#import "AudioPlayerController.h"
#import "PhotoDiaryAppDelegate.h"

@interface ItemViewController()

@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) IBOutlet UITextView *textView;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *photoLibraryButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *playButton;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)saveItem;

@end

@implementation ItemViewController

@synthesize imageView;
@synthesize textView;
@synthesize cameraButton;
@synthesize photoLibraryButton;
@synthesize playButton;

@synthesize toolbar;
@synthesize imagePicker;
@synthesize audioRecorder;
@synthesize item;
@synthesize audioPlayer;
@synthesize managedObjectContext;
@synthesize popoverController;

- (void)dealloc {
    self.managedObjectContext = nil;
    self.toolbar = nil;
    self.imagePicker = nil;
    self.audioRecorder = nil;
    self.item = nil;
    self.audioPlayer = nil;
    self.imageView = nil;
    self.textView = nil;
    self.cameraButton = nil;
    self.photoLibraryButton = nil;
    self.playButton = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    id theDelegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
    self.managedObjectContext.persistentStoreCoordinator = [theDelegate storeCoordinator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toolbarItems = self.toolbar.items;
    [self.audioRecorder addViewToViewController:self.navigationController];
    [self.audioPlayer addViewToViewController:self.navigationController];
    cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    photoLibraryButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePicker.delegate = self;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:self.imagePicker] autorelease];
    }
}

- (void)viewDidUnload {
    self.toolbarItems = nil;
    self.toolbar = nil;
    self.imagePicker = nil;
    self.audioRecorder = nil;
    self.audioPlayer = nil;
    self.popoverController = nil;
    self.imageView = nil;
    self.textView = nil;
    self.cameraButton = nil;
    self.photoLibraryButton = nil;
    self.playButton = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    if(self.item == nil) {
        self.item = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" 
                                                  inManagedObjectContext:self.managedObjectContext];
    }
    else if(self.item.managedObjectContext != self.managedObjectContext) {
        self.item = (DiaryEntry *) [self.managedObjectContext objectWithID:self.item.objectID];
    }
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    Medium *theMedium = [self.item mediumForType:kMediumTypeImage];
    
    [theCenter addObserver:self 
                  selector:@selector(keyboardWillAppear:) 
                      name:UIKeyboardWillShowNotification 
                    object:nil];
    [theCenter addObserver:self 
                  selector:@selector(keyboardWillDisappear:) 
                      name:UIKeyboardWillHideNotification 
                    object:nil];
    self.textView.text = self.item.text;
    self.imageView.image = [UIImage imageWithData:theMedium.data];
    self.playButton.enabled = [self.item mediumForType:kMediumTypeAudio] != nil;
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    self.imageView.image = nil;
    [theCenter removeObserver:theCenter];
    self.audioPlayer.visible = NO;
    self.audioRecorder.visible = NO;
    [self saveItem];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [super viewWillDisappear:inAnimated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return YES;
}

- (void)keyboardWillAppear:(NSNotification *)inNotification {
    NSValue *theValue = [inNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    UIView *theView = self.view;
    CGRect theFrame = [theView.window convertRect:[theValue CGRectValue] toView:theView];
    
    theFrame = CGRectMake(0.0, 0.0, 
                          CGRectGetWidth(self.view.frame),
                          CGRectGetMinY(theFrame));
    theFrame = [theView convertRect:theFrame toView:textView.superview];
    [UIView beginAnimations:nil context:nil];
    self.textView.frame = theFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillDisappear:(NSNotification *)inNotification {
    [UIView beginAnimations:nil context:nil];
    self.textView.frame = CGRectInset(textView.superview.bounds, 10.0, 10.0);
    [UIView commitAnimations];
}

- (void)showPickerWithSourceType:(UIImagePickerControllerSourceType)inSourceType barButtonItem:(UIBarButtonItem *)inItem {
    if([UIImagePickerController isSourceTypeAvailable:inSourceType]) {
        self.imagePicker.sourceType = inSourceType;
        if(self.popoverController == nil) {
            [self presentModalViewController:self.imagePicker animated:YES];            
        }
        else if(!self.popoverController.popoverVisible) {
            [self.popoverController presentPopoverFromBarButtonItem:inItem 
                                           permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                           animated:YES];
        }
    }
}

- (void)saveItem {
    NSError *theError = nil;

    if(![self.managedObjectContext save:&theError]) {
        NSLog(@"saveItem: %@", theError);
    }
    NSLog(@"%@, %@", self.item.creationTime, self.item.updateTime);
}

- (IBAction)takePhoto:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera barButtonItem:inSender];
}

- (IBAction)takePhotoFromLibrary:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary barButtonItem:inSender];
}

- (IBAction)recordAudio:(id)inSender {
    [self.audioRecorder setVisible:YES animated:YES];
}

- (IBAction)playAudio:(id)inSender {
    Medium *theAudio = [self.item mediumForType:kMediumTypeAudio];
    
    self.audioPlayer.audioMedium = theAudio;
    [self.audioPlayer setVisible:YES animated:YES];
}

- (IBAction)saveText:(id)inSender {
    [self.view endEditing:YES];
    [self.item setValue:self.textView.text forKey:@"text"];
}

- (IBAction)revertText:(id)inSender {
    [self.view endEditing:YES];
}

- (void)updateMediumData:(NSData *)inData withMediumType:(NSString *)inType {
    if(inData.length == 0) {
        [self.item removeMediumForType:inType];
    }
    else {
        Medium *theMedium = [NSEntityDescription insertNewObjectForEntityForName:@"Medium" 
                                                          inManagedObjectContext:self.managedObjectContext];
        
        theMedium.type = inType;
        theMedium.data = inData;
        [self.item addMedium:theMedium];
    }
    [self saveItem];
}

- (void)saveImage:(UIImage *)inImage {
    NSData *theData = UIImageJPEGRepresentation(inImage, 0.8);
    CGSize theIconSize = [inImage sizeToAspectFitInSize:CGSizeMake(60.0, 60.0)];
    UIImage *theImage = [inImage scaledImageWithSize:theIconSize];

    self.item.icon = UIImageJPEGRepresentation(theImage, 0.8);
    [self updateMediumData:theData withMediumType:kMediumTypeImage];
}

- (void)dismissImagePickerController:(UIImagePickerController *)inPicker {
    if(self.popoverController == nil) {
        [inPicker.parentViewController dismissModalViewControllerAnimated:YES];
    }    
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)inPicker 
didFinishPickingMediaWithInfo:(NSDictionary *)inInfo {
    UIImage *theImage = [inInfo valueForKey:UIImagePickerControllerEditedImage];
    
    [self dismissImagePickerController:inPicker];
    self.item.icon = nil;
    self.imageView.image = theImage;
    [self saveImage:theImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)inPicker {
    [self dismissImagePickerController:inPicker];
}

#pragma mark AudioRecorderDelegate

-(void)audioRecorder:(AudioRecorderController *)inRecorder didRecordToData:(NSData *)inData {
    [self updateMediumData:inData withMediumType:kMediumTypeAudio];
    self.playButton.enabled = inData.length > 0;
}

-(void)audioRecorderDidCancel:(AudioRecorderController *)inRecorder {
}

#pragma mark SubviewControllerDelegate

- (void)subviewControllerWillAppear:(SubviewController *)inController {
    // [self.navigationController setToolbarHidden:YES animated:NO]; 
}

- (void)subviewControllerWillDisappear:(SubviewController *)inController {
    // [self.navigationController setToolbarHidden:NO animated:NO]; 
}

@end
