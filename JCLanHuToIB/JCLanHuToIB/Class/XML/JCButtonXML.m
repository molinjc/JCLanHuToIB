//
//  JCButtonXML.m
//  JCLanHuToIB
//
//  Created by Chuan on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCButtonXML.h"

@interface JCButtonXML ()
@property (nonatomic, strong) NSXMLElement *fontElement;
@property (nonatomic, strong) JCButtonState *state;
@end

@implementation JCButtonXML

- (void)analysisXMLElement:(NSXMLElement *)xml {
    [super analysisXMLElement:xml];
    for (NSXMLElement *chlid in xml.children) {
        if ([chlid.name isEqualToString:@"fontDescription"]) { _fontElement = chlid; }
        if ([chlid.name isEqualToString:@"state"]) {
            _state = [[JCButtonState alloc] initWithXML:chlid];
        }
    }
}

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [self addAttributeName:@"contentHorizontalAlignment" stringValue:@"center" inXML:xml];
    [self addAttributeName:@"contentVerticalAlignment" stringValue:@"center" inXML:xml];
    [self addAttributeName:@"lineBreakMode" stringValue:@"middleTruncation" inXML:xml];
    [self addAttributeName:@"buttonType" stringValue:@"roundedRect" inXML:xml];

    _fontElement = [self xmlElementWithString:@"<fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"15\"/>"];
    [xml addChild:_fontElement];

    _state = [[JCButtonState alloc] init];
    [xml addChild:_state.xml];
    return xml;
}

- (NSString *)nodeName {
    return @"button";
}

- (NSXMLNode *)contentMode {
    return [NSXMLNode attributeWithName:@"contentMode" stringValue:@"scaleToFill"];
}

- (NSXMLNode *)opaque {
    return [NSXMLNode attributeWithName:@"opaque" stringValue:@"NO"];
}

#pragma mark - Setter/Getter

- (void)setTitle:(NSString *)title {
    _state.title = title;
}

- (NSString *)title {
    return _state.title;
}

- (void)setTitleColor:(JCColorXML *)titleColor {
    _state.titleColor = titleColor;
}

- (JCColorXML *)titleColor {
    return _state.titleColor;
}

- (void)setImage:(NSString *)image {
    _state.image = image;
}

- (NSString *)image {
    return _state.image;
}

@end
