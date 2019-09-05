//
//  JCColorXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCColorXML.h"

@implementation JCNodeXML

- (instancetype)init {
    return [self initWithXML:nil];
}

- (instancetype)initWithXML:(NSXMLElement *)xml {
    if (self = [super init]) {
        _xml = xml;
        if (!_xml) { _xml = [self creartXML]; }
    }
    return self;
}

- (NSXMLElement *)creartXML {
    return nil;
}

- (NSXMLElement *)xmlElementWithString:(NSString *)string {
    NSData *xmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithData:xmlData options:NSXMLNodePreserveWhitespace error:nil];
    return xmlDocument.rootElement;
}

@end

@implementation JCColorXML

- (NSXMLElement *)creartXML {
    return [self xmlElementWithString:@"<color key=\"backgroundColor\" red=\"1\" green=\"1\" blue=\"1\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>"];
}

+ (JCColorXML *)backgroundColor {
    JCColorXML *obj = [[self alloc] init];
    obj.key = @"backgroundColor";
    return obj;
}

+ (JCColorXML *)textColor {
    JCColorXML *obj = [[self alloc] init];
    obj.key = @"textColor";
    obj.red = @"0";
    obj.green = @"0";
    obj.blue = @"0";
    return obj;
}

- (void)setKey:(NSString *)key {
    [self.xml attributeForName:@"key"].stringValue = key;
}

- (NSString *)key {
    return [self.xml attributeForName:@"key"].stringValue;
}

- (void)setAlpha:(NSString *)alpha {
    [self.xml attributeForName:@"alpha"].stringValue = alpha;
}

- (NSString *)alpha {
    return [self.xml attributeForName:@"alpha"].stringValue;
}

- (void)setRed:(NSString *)red {
    [self.xml attributeForName:@"red"].stringValue = red;
}

- (NSString *)red {
    return [self.xml attributeForName:@"red"].stringValue;
}

- (void)setGreen:(NSString *)green {
    [self.xml attributeForName:@"green"].stringValue = green;
}

- (NSString *)green {
    return [self.xml attributeForName:@"green"].stringValue;
}

- (void)setBlue:(NSString *)blue {
    [self.xml attributeForName:@"blue"].stringValue = blue;
}

- (NSString *)blue {
    return [self.xml attributeForName:@"blue"].stringValue;
}

@end


@implementation JCButtonState {
    JCColorXML *_titleColor;
}

- (NSXMLElement *)creartXML {
    return [self xmlElementWithString:@"<state key=\"normal\" title=\"Button\"></state>"];
}

- (void)setKey:(NSString *)key {
    [self.xml attributeForName:@"key"].stringValue = key;
}

- (NSString *)key {
    return [self.xml attributeForName:@"key"].stringValue;
}

- (void)setTitle:(NSString *)title {
    [self.xml attributeForName:@"title"].stringValue = title;
}

- (NSString *)title {
    return [self.xml attributeForName:@"title"].stringValue;
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

- (void)setTitleColor:(JCColorXML *)titleColor {
    if (_titleColor) {
        [self.xml removeChildAtIndex:[self.xml.children indexOfObject:_titleColor.xml]];
    }
    _titleColor = titleColor;
    _titleColor.key = @"titleColor";
    [self.xml addChild:_titleColor.xml];
}

- (JCColorXML *)titleColor {
    if (!_titleColor) {
        _titleColor = [JCColorXML textColor];
        _titleColor.key = @"titleColor";
        [self.xml addChild:_titleColor.xml];
    }
    return _titleColor;
}

@end
