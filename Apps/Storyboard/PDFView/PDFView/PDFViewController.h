//
//  PDFViewController.h
//  PDFView
//
//  Created by Clemens Wagner on 25.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFView.h"

@interface PDFViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PDFView *pdfView;

- (IBAction)zoomIn:(UITapGestureRecognizer *)inSender;

@end
