//
//  JCImageViewXML.m
//  JCLanHuToIB
//
//  Created by Chuan on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCImageViewXML.h"

@implementation JCImageViewXML

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [self addAttributeName:@"horizontalHuggingPriority" stringValue:@"251" inXML:xml];
    [self addAttributeName:@"verticalHuggingPriority" stringValue:@"251" inXML:xml];
    return xml;
}

- (NSString *)nodeName {
    return @"imageView";
}

- (NSXMLNode *)contentMode {
    return [NSXMLNode attributeWithName:@"contentMode" stringValue:@"scaleAspectFit"];
}

- (void)setImage:(NSString *)image {
    NSXMLNode *node = [self.xml attributeForName:@"image"];
    if (!node) {
        node = [NSXMLNode attributeWithName:@"image" stringValue:image];
        [self.xml addAttribute:node];
    } else {
        node.stringValue = image;
    }
}

- (NSString *)image {
    return [self.xml attributeForName:@"image"].stringValue;
}

@end
