//
//  MarkupParser.h
//  Markup
//
//  Created by Clemens Wagner on 03.01.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkupParser : NSObject<NSXMLParserDelegate>

- (NSAttributedString *)attributedText;
- (void)setAttributes:(NSDictionary *)inAttributes forTagName:(NSString *)inTagName;
- (NSDictionary *)attributesForTagName:(NSString *)inTagName;

@end
