#import "ItemViewController.h"
#import "AudioRecorderController.h"
#import "DiaryEntry.h"
#import "Medium.h"
#import "UIImage+ImageTools.h"
#import "AudioPlayerController.h"
#import "PhotoDiaryAppDelegate.h"

@interface ItemViewController()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) DiaryEntry *item;

- (void)applyItem;
- (BOOL)saveItem;
- (UIViewController *)mainViewController;

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
@synthesize audioPlayer;
@synthesize item;
@synthesize indexPath;
@synthesize managedObjectContext;
@synthesize popoverController;

- (void)dealloc {
    self.managedObjectContext = nil;
    self.toolbar = nil;
    self.imagePicker = nil;
    self.audioRecorder = nil;
    self.audioPlayer = nil;
    self.item = nil;
    self.indexPath = nil;
    self.imageView = nil;
    self.textView = nil;
    self.cameraButton = nil;
    self.photoLibraryButton = nil;
    self.playButton = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.audioRecorder addViewToViewController:self.mainViewController];
    [self.audioPlayer addViewToViewController:self.mainViewController];
    self.cameraButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    self.photoLibraryButton.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.imagePicker.delegate = self;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:self.imagePicker] autorelease];
    }
    if(self.splitViewController == nil) {
        self.toolbarItems = self.toolbar.items;        
    }
    else {
        CGRect theBounds = self.view.bounds;
        CGRect theFrame = self.toolbar.frame;
        CGFloat theHeight = CGRectGetHeight(theFrame);
        
        theFrame.size.width = CGRectGetWidth(theBounds);
        theFrame.origin.y = CGRectGetHeight(theBounds) - theHeight;
        self.toolbar.frame = theFrame;
        [self.view addSubview:self.toolbar];
        theFrame = theBounds;
        theFrame.size.height = CGRectGetHeight(theBounds) - theHeight;
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

- (void)setupNavigationController {
    UINavigationController *theController = self.navigationController;
    
    if(theController != self.parentViewController) {
        [theController.toolbar setItems:self.toolbarItems animated:NO];
    }    
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self applyItem];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    [self setupNavigationController];
    [theCenter addObserver:self 
                  selector:@selector(keyboardWillAppear:) 
                      name:UIKeyboardWillShowNotification 
                    object:nil];
    [theCenter addObserver:self 
                  selector:@selector(keyboardWillDisappear:) 
                      name:UIKeyboardWillHideNotification 
                    object:nil];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    self.imageView.image = nil;
    [theCenter removeObserver:theCenter];
    self.audioPlayer.visible = NO;
    self.audioRecorder.visible = NO;
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

- (NSManagedObjectContext *)managedObjectContext {
    if(managedObjectContext == nil) {
        id theDelegate = [[UIApplication sharedApplication] delegate];
        
        self.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        self.managedObjectContext.persistentStoreCoordinator = [theDelegate storeCoordinator];
    }
    return managedObjectContext;
}

- (DiaryEntry *)diaryEntry {
    return self.item;
}

- (void)setDiaryEntry:(DiaryEntry *)inDiaryEntry {
    [self.managedObjectContext reset];
    if(inDiaryEntry == nil) {
        self.item = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" 
                                                  inManagedObjectContext:self.managedObjectContext];
    }
    else {
        self.item = inDiaryEntry;
    }
}

- (void)setItem:(DiaryEntry *)inItem {
    if(item != inItem) {
        [item release];
        if(inItem.managedObjectContext == self.managedObjectContext) {
            item = [inItem retain];
        }
        else if(inItem != nil){
            item = [[self.managedObjectContext objectWithID:inItem.objectID] retain];
        }
        [self applyItem];
    }
}

- (void)applyItem {
    Medium *theMedium;
    
    if(self.item == nil) {
        self.diaryEntry = nil;
    }
    self.textView.text = self.item.text;
    theMedium = [self.item mediumForType:kMediumTypeImage];
    self.imageView.image = [UIImage imageWithData:theMedium.data];
    self.playButton.enabled = [self.item mediumForType:kMediumTypeAudio] != nil;
}

- (BOOL)saveItem {
    BOOL theResult = NO;
    
    if(self.item.hasContent) {
        NSError *theError = nil;

        theResult = [self.managedObjectContext save:&theError];
        if(!theResult) {
            NSLog(@"saveItem: %@", theError);
        }
    }
    return theResult;
}

- (UIViewController *)mainViewController {
    UIViewController *theController = self.navigationController;
    
    return theController == nil ? self.splitViewController : theController;
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
    self.item.text = self.textView.text;
    [self saveItem];
}

- (IBAction)revertText:(id)inSender {
    [self.view endEditing:YES];
    [self applyItem];
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
        [inPicker dismissModalViewControllerAnimated:YES];
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
