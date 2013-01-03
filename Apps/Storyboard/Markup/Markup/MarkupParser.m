//
//  MarkupParser.m
//  Markup
//
//  Created by Clemens Wagner on 03.01.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MarkupParser.h"
#import "UIColor+StringParsing.h"

@interface MarkupTag : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger position;
@property (nonatomic, strong) NSMutableDictionary *attributes;

+ (id)markupTagWithName:(NSString *)inName position:(NSUInteger)inPosition attributes:(NSDictionary *)inAttributes;
- (void)addAttribute:(id)inValue forName:(NSString *)inName;

@end

@interface MarkupParser()

@property (nonatomic, strong, readwrite) NSMutableAttributedString *text;
@property (nonatomic, strong) NSMutableDictionary *attributesByTagName;

@property (nonatomic, strong) NSMutableArray *stack;

@end

@implementation MarkupParser

- (id)init {
    self = [super init];
    if (self) {
        self.text = [[NSMutableAttributedString alloc] init];
        self.attributesByTagName = [NSMutableDictionary dictionary];
        self.stack = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

- (NSAttributedString *)attributedText {
    return [self.text copy];
}

- (void)setAttributes:(NSDictionary *)inAttributes forTagName:(NSString *)inTagName {
    [self.attributesByTagName setValue:inAttributes forKey:inTagName];
}

- (NSDictionary *)attributesForTagName:(NSString *)inTagName {
    return [self.attributesByTagName valueForKey:inTagName];
}

- (void)parser:(NSXMLParser *)inParser didStartElement:(NSString *)inElementName namespaceURI:(NSString *)inNamespaceURI qualifiedName:(NSString *)inQualifiedName attributes:(NSDictionary *)inAttributes {
    if([inElementName isEqualToString:@"text"]) {
        [self.text deleteCharactersInRange:NSMakeRange(0, [self.text length])];
    }
    else {
        NSUInteger thePosition = [self.text length];
        NSDictionary *theAttributes = [self attributesForTagName:inElementName];
        MarkupTag *theTag = [MarkupTag markupTagWithName:inElementName position:thePosition attributes:theAttributes];

        [theTag addAttribute:[UIColor colorWithString:[inAttributes valueForKey:@"color"]]
                     forName:NSForegroundColorAttributeName];
        [theTag addAttribute:[UIColor colorWithString:[inAttributes valueForKey:@"background-color"]]
                     forName:NSBackgroundColorAttributeName];
        [self.stack addObject:theTag];
    }
}

- (void)parser:(NSXMLParser *)inParser didEndElement:(NSString *)inElementName namespaceURI:(NSString *)inNamespaceURI qualifiedName:(NSString *)inQualifiedName {
    if([self.attributesByTagName objectForKey:inElementName] != nil) {
        MarkupTag *theTag = [self.stack lastObject];
        NSRange theRange = NSMakeRange(theTag.position, [self.text length] - theTag.position);

        [self.stack removeLastObject];
        [self.text addAttributes:theTag.attributes range:theRange];
    }
}

- (void)parser:(NSXMLParser *)inParser foundCharacters:(NSString *)inCharacters {
    NSAttributedString *theString = [[NSAttributedString alloc] initWithString:inCharacters];
    
    [self.text appendAttributedString:theString];
}

@end

@implementation MarkupTag

+ (id)markupTagWithName:(NSString *)inName position:(NSUInteger)inPosition attributes:(NSDictionary *)inAttributes {
    id theTag = [[[self class] alloc] init];
    NSMutableDictionary *theAttributes = [NSMutableDictionary dictionaryWithDictionary:inAttributes];

    [theTag setName:inName];
    [theTag setPosition:inPosition];
    [theTag setAttributes:theAttributes];
    return theTag;
}

- (void)addAttribute:(id)inValue forName:(NSString *)inName {
    if(inValue != nil) {
        [self.attributes setValue:inValue forKey:inName];
    }
}

@end
