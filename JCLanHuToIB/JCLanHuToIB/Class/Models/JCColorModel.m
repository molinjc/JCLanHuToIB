//
//  JCColorModel.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCColorModel.h"

@interface JCColorModel ()
@property (nonatomic, strong) NSXMLNode *keyNode;
@end

@implementation JCColorModel

- (instancetype)init {
    if (self = [self initWithXMLElement:nil]) {}
    return self;
}

- (NSXMLElement *)analysisXML:(NSXMLElement *)xml {
    if (!xml) {
        xml = [self elementWithXML:@"<color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"genericGamma22GrayColorSpace\"/>"];
    }
    
    for (NSXMLNode *node in xml.attributes) {
        if ([node.name isEqualToString:@"key"]) { _key = node.stringValue; _keyNode = node; break; }
    }
    return xml;
}

- (void)r:(NSString *)r g:(NSString *)g b:(NSString *)b a:(NSString *)a {
    NSXMLNode *rNode = nil;
    NSXMLNode *gNode = nil;
    NSXMLNode *bNode = nil;
    NSXMLNode *aNode = nil;
    for (NSXMLNode *node in self.xml.attributes) {
        if ([node.name isEqualToString:@"red"]) {
            node.stringValue = r;
            rNode = node;
        }
        if ([node.name isEqualToString:@"green"]) {
            node.stringValue = g;
            gNode = node;
        }
        if ([node.name isEqualToString:@"blue"]) {
            node.stringValue = b;
            bNode = node;
        }
        if ([node.name isEqualToString:@"alpha"]) {
            node.stringValue = a;
            aNode = node;
        }
        if ([node.name isEqualToString:@"colorSpace"]) {
            node.stringValue = @"calibratedRGB";
        }
    }
    
    if (!rNode) {
        [self.xml addAttribute:[NSXMLNode attributeWithName:@"red" stringValue:r]];
    }
    if (!gNode) {
        [self.xml addAttribute:[NSXMLNode attributeWithName:@"green" stringValue:g]];
    }
    if (!bNode) {
        [self.xml addAttribute:[NSXMLNode attributeWithName:@"blue" stringValue:b]];
    }
    if (!aNode) {
        [self.xml addAttribute:[NSXMLNode attributeWithName:@"alpha" stringValue:a]];
    }
    
    [self.xml removeAttributeForName:@"customColorSpace"];
    [self.xml removeAttributeForName:@"white"];
}

- (void)setKey:(NSString *)key {
    _key = key;
    _keyNode.stringValue = key;
}

@end
