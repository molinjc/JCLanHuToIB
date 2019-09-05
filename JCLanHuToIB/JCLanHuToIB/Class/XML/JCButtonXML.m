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

- (void)setupFamily:(NSString *)family FontName:(NSString *)fontName {
    [_fontElement removeAttributeForName:@"type"];
    [self addAttributeName:@"family" stringValue:family inXML:_fontElement];
    [self addAttributeName:@"fontName" stringValue:fontName inXML:_fontElement];
}

- (void)setupDatas:(JCNodeModel *)model {
    if (!model.text.length) {
        if (self.width.floatValue <= 0) { [super setupDatas:model]; }
        else { self.image = model.name; }
    }
    else {
        self.title = model.text;
        self.titleColor.red = @(model.color_r / 255.0).stringValue;
        self.titleColor.green = @(model.color_g / 255.0).stringValue;
        self.titleColor.blue = @(model.color_b / 255.0).stringValue;
        self.titleColor.alpha = @(model.color_a).stringValue;
        self.pointSize = model.font_size;
        
        static NSArray *familys = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            familys = @[@"Thonburi", @"Khmer Sangam MN", @"Kohinoor Telugu", @"Snell Roundhand", @"Academy Engraved LET", @"Marker Felt", @"Avenir", @"Geeza Pro", @"Arial Rounded MT Bold", @"Trebuchet MS", @"Arial", @"Menlo", @"Gurmukhi MN", @"Malayalam Sangam MN", @"Kannada Sangam MN", @"Bradley Hand", @"Bodoni 72 Oldstyle", @"Cochin", @"Sinhala Sangam MN", @"PingFang HK", @"Iowan Old Style", @"Kohinoor Bangla", @"Damascus", @"Al Nile", @"Farah", @"Papyrus", @"Verdana", @"Zapf Dingbats", @"Avenir Next Condensed", @"Courier", @"Hoefler Text", @"Euphemia UCAS", @"Helvetica", @"Lao Sangam MN", @"Hiragino Mincho ProN", @"Bodoni Ornaments", @"Apple Color Emoji", @"Mishafi", @"Optima", @"Gujarati Sangam MN", @"Devanagari Sangam MN", @"PingFang SC", @"Savoye LET", @"Times New Roman", @"Kailasa", @"Apple SD Gothic Neo", @"Futura", @"Bodoni 72", @"Baskerville", @"Symbol", @"Copperplate", @"Party LET", @"American Typewriter", @"Chalkboard SE", @"Avenir Next", @"Noteworthy", @"Hiragino Sans", @"Zapfino", @"Tamil Sangam MN", @"Chalkduster", @"Arial Hebrew", @"Georgia", @"Helvetica Neue", @"Gill Sans", @"Kohinoor Devanagari", @"Palatino", @"Courier New", @"Oriya Sangam MN", @"Didot", @"PingFang TC", @"Bodoni 72 Smallcaps"];
        });
        
        NSString *family = model.font;
        if ([model.font containsString:@"-"]) { family = [model.font componentsSeparatedByString:@"-"].firstObject; }
        if ([familys containsObject:family]) {
            [self setupFamily:family FontName:model.font];
        }
        
        if (self.width.floatValue <= 2) {
            self.x = model.x;
            self.y = model.y;
            self.width = model.width;
            self.height = model.height;
            if (model.opaque < 1) { self.alpha = @(1 - model.opaque).stringValue; }
        }
    }
    
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

- (void)setPointSize:(NSString *)pointSize {
    [_fontElement attributeForName:@"pointSize"].stringValue = pointSize;
}

- (NSString *)pointSize {
    return [_fontElement attributeForName:@"pointSize"].stringValue;
}

@end
