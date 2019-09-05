//
//  JCTextFieldXML.m
//  JCLanHuToIB
//
//  Created by Chuan on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCTextFieldXML.h"

@interface JCTextFieldXML ()
@property (nonatomic, strong) NSXMLElement *fontElement;
@end

@implementation JCTextFieldXML

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [xml removeAttributeForName:@"horizontalHuggingPriority"];
    [xml removeAttributeForName:@"verticalHuggingPriority"];
    [xml removeAttributeForName:@"adjustsFontSizeToFit"];
    [xml removeAttributeForName:@"baselineAdjustment"];
    [xml removeAttributeForName:@"lineBreakMode"];
    [self addAttributeName:@"contentHorizontalAlignment" stringValue:@"left" inXML:xml];
    [self addAttributeName:@"contentVerticalAlignment" stringValue:@"center" inXML:xml];
    [self addAttributeName:@"minimumFontSize" stringValue:@"17" inXML:xml];
    [self addAttributeName:@"text" stringValue:@"text" inXML:xml];
    [self addAttributeName:@"placeholder" stringValue:@"" inXML:xml];

    [xml addChild:[self xmlElementWithString:@"<textInputTraits key=\"textInputTraits\"/>"]];
    return xml;
}

- (NSString *)nodeName {
    return @"textField";
}

- (void)setupDatas:(JCNodeModel *)model {
    [super setupDatas:model];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [self.xml attributeForName:@"placeholder"].stringValue = placeholder;
}

- (NSString *)placeholder {
    return [self.xml attributeForName:@"placeholder"].stringValue;
}

- (void)setBorder:(BOOL)border {
    _border = border;
    if (_border) {
        [self addAttributeName:@"borderStyle" stringValue:@"roundedRect" inXML:self.xml];
    }
}

@end
