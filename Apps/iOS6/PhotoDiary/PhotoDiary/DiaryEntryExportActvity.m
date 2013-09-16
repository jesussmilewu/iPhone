//
//  ExportActvity.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 15.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "DiaryEntryExportActvity.h"
#import "ExportViewController.h"
#import "Model.h"

NSString * const kActivityTypeExport = @"kActivityTypeExport";

@interface DiaryEntryExportActvity()

@property (nonatomic, strong) IBOutlet UIViewController *activityViewController;
@property (nonatomic, weak) IBOutlet ExportViewController *exportViewController;

@end


@implementation DiaryEntryExportActvity

- (NSString *)activityType {
    return kActivityTypeExport;
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Export", @"Activity Title");
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"export"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)inItems {
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"ANY items isKindOfClass:%@", [DiaryEntry class]];

    return [thePredicate evaluateWithObject:@{ @"items":inItems }];
}

- (void)prepareWithActivityItems:(NSArray *)inItems {
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@", [DiaryEntry class]];
    NSArray *theEntries = [inItems filteredArrayUsingPredicate:thePredicate];

    [[NSBundle mainBundle] loadNibNamed:@"ExportActivity" owner:self options:nil];
    self.exportViewController.activity = self;
    self.exportViewController.diaryEntry = theEntries[0];
}

- (void)performActivity {
    NSLog(@"performActivity");
}

@end