#import "ItemViewController.h"
#import "AudioRecorder.h"
#import "DiaryEntry.h"
#import "Medium.h"
#import "UIImage+ImageTools.h"
#import "AudioPlayer.h"
#import "PhotoDiaryAppDelegate.h"

@interface ItemViewController()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)saveItem;

@end

@implementation ItemViewController

@synthesize managedObjectContext;
@synthesize toolbar;
@synthesize imagePicker;
@synthesize audioRecorder;
@synthesize item;
@synthesize audioPlayer;

- (void)dealloc {
    self.managedObjectContext = nil;
    self.toolbar = nil;
    self.imagePicker = nil;
    self.audioRecorder = nil;
    self.item = nil;
    self.audioPlayer = nil;
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
}

- (void)viewDidUnload {
    self.toolbar = nil;
    self.imagePicker = nil;
    self.audioRecorder = nil;
    self.audioPlayer = nil;
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
    textView.text = self.item.text;
    imageView.image = [UIImage imageWithData:theMedium.data];
    playButton.enabled = [self.item mediumForType:kMediumTypeAudio] != nil;
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    imageView.image = nil;
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
    CGRect theFrame = [textView.superview convertRect:[theValue CGRectValue] fromView:textView.window];
    
    theFrame = CGRectMake(0.0, 0.0, 
                          CGRectGetWidth(self.view.frame),
                          CGRectGetHeight(self.view.frame) - CGRectGetHeight(theFrame) + CGRectGetHeight(self.toolbar.frame));
    theFrame = [theView convertRect:theFrame toView:textView.superview];
    [UIView beginAnimations:nil context:nil];
    textView.frame = theFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillDisappear:(NSNotification *)inNotification {
    [UIView beginAnimations:nil context:nil];
    textView.frame = CGRectInset(textView.superview.bounds, 10.0, 10.0);
    [UIView commitAnimations];
}

- (void)showPickerWithSourceType:(UIImagePickerControllerSourceType)inSourceType {
    if([UIImagePickerController isSourceTypeAvailable:inSourceType]) {
        self.imagePicker.sourceType = inSourceType;
        [self presentModalViewController:self.imagePicker animated:YES];
    }
}

- (void)saveItem {
    NSError *theError = nil;

    if(![self.managedObjectContext save:&theError]) {
        NSLog(@"saveItem: %@", theError);
    }
}

- (IBAction)takePhoto:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)takePhotoFromLibrary:(id)inSender {
    [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    [self.item setValue:textView.text forKey:@"text"];
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
    CGSize theIconSize = [inImage sizeToAspectFitInSize:CGSizeMake(60.0, 60.0)];
    NSData *theData = UIImageJPEGRepresentation(inImage, 0.8);
    UIImage *theImage = [inImage scaledImageWithSize:theIconSize];

    self.item.icon = UIImageJPEGRepresentation(theImage, 0.8);
    NSLog(@"[+] saving image ...");
    
    // uploading file to server
    
    
    [self updateMediumData:theData withMediumType:kMediumTypeImage];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)inPicker 
didFinishPickingMediaWithInfo:(NSDictionary *)inInfo {
    UIImage *theImage = [inInfo valueForKey:UIImagePickerControllerEditedImage];
    
    [inPicker.parentViewController dismissModalViewControllerAnimated:YES];
    self.item.icon = nil;
    imageView.image = theImage;
    [self saveImage:theImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)inPicker {
    [inPicker.parentViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark AudioRecorderDelegate

-(void)audioRecorder:(AudioRecorder *)inRecorder didRecordToData:(NSData *)inData {
    [self updateMediumData:inData withMediumType:kMediumTypeAudio];
    playButton.enabled = inData.length > 0;
}

-(void)audioRecorderDidCancel:(AudioRecorder *)inRecorder {
}

#pragma mark SubviewControllerDelegate

- (void)subviewControllerWillAppear:(SubviewController *)inController {
    // [self.navigationController setToolbarHidden:YES animated:NO]; 
}

- (void)subviewControllerWillDisappear:(SubviewController *)inController {
    // [self.navigationController setToolbarHidden:NO animated:NO]; 
}

@end
