//
//  JCScrollViewXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/5.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCScrollViewXML.h"

@implementation JCScrollViewXML

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];

    NSXMLNode *node = [self clipsSubviews];
    if (node) { [xml addAttribute:node]; }
    
    node = [self multipleTouchEnabled];
    if (node) { [xml addAttribute:node]; }
    return xml;
}

- (NSXMLNode *)clipsSubviews {
    return [NSXMLNode attributeWithName:@"clipsSubviews" stringValue:@"YES"];
}

- (NSXMLNode *)multipleTouchEnabled {
    return [NSXMLNode attributeWithName:@"multipleTouchEnabled" stringValue:@"YES"];
}

@end
