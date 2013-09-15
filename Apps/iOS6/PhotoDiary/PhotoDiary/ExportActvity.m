//
//  ExportActvity.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 15.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ExportActvity.h"
#import "Model.h"

NSString * const kActivityTypeExport = @"kActivityTypeExport";

@implementation ExportActvity

- (NSString *)activityType {
    return kActivityTypeExport;
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Export", @"Activity Title");
}

- (UIImage *)activityImage {
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)inItems {
    for(id theItem in inItems) {
        if([theItem isKindOfClass:[DiaryEntry class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)inItems {

}

- (void)performActivity {

}

- (void)activityDidFinish:(BOOL)inCompleted {

}

@end