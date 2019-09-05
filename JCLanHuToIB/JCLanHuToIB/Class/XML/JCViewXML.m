//
//  JCViewXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCViewXML.h"

@interface JCViewXML ()
@property (nonatomic, strong) NSXMLElement *rectElement;
@property (nonatomic, strong) NSXMLElement *subviewsElement;
@end

@implementation JCViewXML

- (instancetype)initWithXML:(NSXMLElement *)xml {
    if (self = [super initWithXML:xml]) {
        _subviews = [NSMutableArray new];
    }
    return self;
}

- (void)analysisXMLElement:(NSXMLElement *)xml {
    [super analysisXMLElement:xml];
    
    NSXMLElement *backgroundColorNode = nil;
    for (NSXMLElement *children in xml.children) {
        if ([children.name isEqualToString:@"rect"]) { _rectElement = children; }
        if ([children.name isEqualToString:@"color"] && [[children attributeForName:@"key"].stringValue isEqualToString:@"backgroundColor"]) { backgroundColorNode = children; }
        if (backgroundColorNode && _rectElement) { break; }
    }
    [xml removeChildAtIndex:[xml.children indexOfObject:backgroundColorNode]];
    _backgroundColor = [JCColorXML backgroundColor];
    [xml addChild:_backgroundColor.xml];
}

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [xml addAttribute:[self contentMode]];
    [xml addAttribute:[self fixedFrame]];
    [xml addAttribute:[self translatesAutoresizingMaskIntoConstraints]];
    _rectElement = [self xmlElementWithString:@"<rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"0.0\" height=\"0.0\"/>"];
    [xml addChild:_rectElement];
    [xml addChild:[self xmlElementWithString:@"<autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>"]];
    _backgroundColor = [JCColorXML backgroundColor];
    [xml addChild:_backgroundColor.xml];
    
    NSXMLNode *node = [self opaque];
    if (node) { [xml addAttribute:node]; }
    
    node = [self userInteractionEnabled];
    if (node) { [xml addAttribute:node]; }
    return xml;
}

- (NSString *)nodeName {
    return @"view";
}

- (NSXMLNode *)contentMode {
    return [NSXMLNode attributeWithName:@"contentMode" stringValue:@"scaleToFill"];
}

- (void)addKeyNodeWithValue:(NSString *)value {
    NSXMLNode *node = [self.xml attributeForName:@"key"];
    if (!node) {
        node = [NSXMLNode attributeWithName:@"key" stringValue:value];
        [self.xml addAttribute:node];
        
    } else { node.stringValue = value; }
}

- (NSXMLNode *)fixedFrame {
    return [NSXMLNode attributeWithName:@"fixedFrame" stringValue:@"YES"];
}

- (NSXMLNode *)translatesAutoresizingMaskIntoConstraints {
    return [NSXMLNode attributeWithName:@"translatesAutoresizingMaskIntoConstraints" stringValue:@"NO"];
}

- (NSXMLNode *)opaque {
    return nil;
}

- (NSXMLNode *)userInteractionEnabled {
    return nil;
}

- (void)setupFullScreen {
    NSXMLElement *autoresizingMask = nil;
    for (NSXMLElement *children in self.xml.children) {
        if ([children.name isEqualToString:@"autoresizingMask"]) { autoresizingMask = children; break; }
    }
    [self.xml removeChildAtIndex:[self.xml.children indexOfObject:autoresizingMask]];
    [self.xml addChild:[self xmlElementWithString:@"<autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>"]];
}

- (void)addSubviews:(JCViewXML *)viewXML {
    if (!_subviewsElement) {
        _subviewsElement = [NSXMLElement elementWithName:@"subviews"];
        [self.xml addChild:_subviewsElement];
    }
    if (![_subviews containsObject:viewXML]) {
        [_subviewsElement addChild:viewXML.xml];
        [_subviews addObject:viewXML];
        
        viewXML.x = @(viewXML.x.floatValue - self.x.floatValue).stringValue;
        viewXML.y = @(viewXML.y.floatValue - self.y.floatValue).stringValue;
    }
}

- (void)setupDatas:(JCNodeModel *)model {
    self.x = model.x;
    self.y = model.y;
    self.width = model.width;
    self.height = model.height;
    if (model.opaque < 1) { self.alpha = @(1 - model.opaque).stringValue; }
    self.backgroundColor.red = @(model.color_r / 255.0).stringValue;
    self.backgroundColor.green = @(model.color_g / 255.0).stringValue;
    self.backgroundColor.blue = @(model.color_b / 255.0).stringValue;
    self.backgroundColor.alpha = @(model.color_a).stringValue;
}

- (BOOL)isEqual:(id)object {
    return [((JCViewXML *)object).uid isEqualToString:self.uid];
}

#pragma mark - Setter/Getter

- (void)setX:(NSString *)x {
    [_rectElement attributeForName:@"x"].stringValue = x;
}

- (NSString *)x {
    return [_rectElement attributeForName:@"x"].stringValue;
}

- (void)setY:(NSString *)y {
    [_rectElement attributeForName:@"y"].stringValue = y;
}

- (NSString *)y {
    return [_rectElement attributeForName:@"y"].stringValue;
}

- (void)setWidth:(NSString *)width {
    [_rectElement attributeForName:@"width"].stringValue = width;
}

- (NSString *)width {
    return [_rectElement attributeForName:@"width"].stringValue;
}

- (void)setHeight:(NSString *)height {
    [_rectElement attributeForName:@"height"].stringValue = height;
}

- (NSString *)height {
    return [_rectElement attributeForName:@"height"].stringValue;
}

- (void)setAlpha:(NSString *)alpha {
    NSXMLNode *node = [self.xml attributeForName:@"alpha"];
    if (!node) {
        node = [NSXMLNode attributeWithName:@"alpha" stringValue:alpha];
        [self.xml addAttribute:node];
        
    } else { node.stringValue = alpha; }
}

- (NSString *)alpha {
    return [self.xml attributeForName:@"alpha"].stringValue;
}

- (void)setBackgroundColor:(JCColorXML *)backgroundColor {
    if (_backgroundColor) {
        [self.xml removeChildAtIndex:[self.xml.children indexOfObject:_backgroundColor.xml]];
    }
    _backgroundColor = backgroundColor;
    [self.xml addChild:_backgroundColor.xml];
}

- (void)setKey:(NSString *)key {
    NSXMLNode *node = [self.xml attributeForName:@"key"];
    if (!node) {
        node = [NSXMLNode attributeWithName:@"key" stringValue:key];
        [self.xml addAttribute:node];
        
    } else { node.stringValue = key; }
}

- (NSString *)key {
    return [self.xml attributeForName:@"key"].stringValue;
}

@end
