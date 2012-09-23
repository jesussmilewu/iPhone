//
//  PhotoUploadViewController.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 23.09.12.
//
//

#import "PhotoUploadViewController.h"

@interface PhotoUploadViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation PhotoUploadViewController

@synthesize photoView;
@synthesize result;
@synthesize uploadButton;
@synthesize activity;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoView.image = nil;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    self.result.text = @"";
    self.uploadButton.enabled = self.photoView.image != nil;
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    self.photoView.image = nil;
    [super viewWillDisappear:inAnimated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)showCamera {
    UIImagePickerController *theController = [[UIImagePickerController alloc] init];
    
    theController.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ?
    UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    theController.delegate = self;
    [self presentViewController:theController animated:YES completion:NULL];
}

- (IBAction)upload {
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)inPicker didFinishPickingMediaWithInfo:(NSDictionary *)inInfo {
    self.photoView.image = [inInfo objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"size = %@", NSStringFromCGSize(self.photoView.image.size));
    [inPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)inPicker {
    [inPicker dismissViewControllerAnimated:YES completion:NULL];
}

@end
