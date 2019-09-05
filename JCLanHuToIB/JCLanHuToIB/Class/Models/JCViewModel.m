//
//  JCViewModel.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCViewModel.h"
#import "JCLabelModel.h"

@interface JCViewModel ()
@property (nonatomic, strong) NSXMLElement *rectElement;
@property (nonatomic, strong) NSXMLElement *subviewsElement;
@property (nonatomic, strong) NSXMLNode *contentModeNode;
@property (nonatomic, strong) NSXMLNode *alphaNode;
@end

@implementation JCViewModel

- (NSXMLElement *)analysisXML:(NSXMLElement *)xml {
    _subviews = [NSMutableArray new];

    if (!xml) {
        xml = [self creatViewControllerXML];
    } else {
        for (NSXMLNode *node in xml.attributes) {
            if ([node.name isEqualToString:@"id"]) { _vid = node.stringValue; }
            if ([node.name isEqualToString:@"contentMode"]) { _contentModeNode = node; }
            if ([node.name isEqualToString:@"alpha"]) { _alphaNode = node; }
            
        }
        for (NSXMLElement *node in xml.children) {
            if ([node.name isEqualToString:@"rect"]) { _rectElement = node; }
            if ([node.name isEqualToString:@"color"]) {
                _colorModel = [[JCColorModel alloc] initWithXMLElement:node];
            }
            if ([node.name isEqualToString:@"subviews"]) { _subviewsElement = node; }
        }

        for (NSXMLElement *node in _subviewsElement.children) {
            if ([node.name isEqualToString:@"view"]) {
                [_subviews addObject:[[JCViewModel alloc] initWithXMLElement:node]];
            } else if ([node.name isEqualToString:@"label"]) {
                [_subviews addObject:[[JCLabelModel alloc] initWithXMLElement:node]];
            }
        }
    }
    return xml;
}

- (NSXMLElement *)creatViewControllerXML {
    NSXMLElement *element = [NSXMLElement elementWithName:[self nodeName]];
    _vid = [self uid];
    [element addAttribute:[NSXMLNode attributeWithName:@"id" stringValue:_vid]];
    _contentModeNode = [NSXMLNode attributeWithName:@"contentMode" stringValue:@"scaleToFill"];
    [element addAttribute:_contentModeNode];
    [element addAttribute:[NSXMLNode attributeWithName:@"fixedFrame" stringValue:@"YES"]];
    [element addAttribute:[NSXMLNode attributeWithName:@"translatesAutoresizingMaskIntoConstraints" stringValue:@"NO"]];
    
    _rectElement = [self elementWithXML:@"<rect key=\"frame\" x=\"0\" y=\"0\" width=\"10\" height=\"10\"/>"];
    [element addChild:_rectElement];
    
    NSXMLElement *autoresizingMask = [self elementWithXML:@"<autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>"];
    [element addChild:autoresizingMask];
    
    [element addChild:self.colorModel.xml];
    
    return element;
}

- (void)addSubview:(JCViewModel *)subview {
    if (!_subviewsElement) {
        _subviewsElement = [NSXMLElement elementWithName:@"subviews"];
        [self.xml addChild:_subviewsElement];
    }
    
    [_subviewsElement addChild:subview.xml];
}

- (void)setupDatas:(JCNodeModel *)data {
    self.x = data.x;
    self.y = data.y;
    self.width = data.width;
    self.height = data.height;
    self.alpha = @(data.opaque).stringValue;
    [self.colorModel r:_COLORSTR(data.color_r) g:_COLORSTR(data.color_g) b:_COLORSTR(data.color_b) a:@(data.color_a).stringValue];
}

- (NSString *)nodeName {
    return @"view";
}

- (void)setX:(NSString *)x {
    _x = x;
    _SETTER(@"x", _rectElement, x);
}

- (void)setY:(NSString *)y {
    _y = y;
    _SETTER(@"y", _rectElement, y);
}

- (void)setWidth:(NSString *)width {
    _width = width;
    _SETTER(@"width", _rectElement, width);
}

- (void)setHeight:(NSString *)height {
    _height = height;
    _SETTER(@"height", _rectElement, height);
}

- (void)setAlpha:(NSString *)alpha {
    _alpha = alpha;
    if (!_alphaNode) {
        _alphaNode = [NSXMLNode attributeWithName:@"alpha" stringValue:alpha];
        [self.xml addAttribute:_alphaNode];
    }
    _alphaNode.stringValue = alpha;
}

- (JCColorModel *)colorModel {
    if (!_colorModel) {
        _colorModel = [[JCColorModel alloc] init];
    }
    return _colorModel;
}

- (void)setContentMode:(NSString *)contentMode {
    _contentMode = contentMode;
    _contentModeNode.stringValue = contentMode;
}

@end
