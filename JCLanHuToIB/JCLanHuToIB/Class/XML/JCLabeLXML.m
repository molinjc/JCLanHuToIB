//
//  JCLabeLXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCLabeLXML.h"

@interface JCLabeLXML ()
@property (nonatomic, strong) NSXMLElement *fontElement;
@end

@implementation JCLabeLXML

- (void)analysisXMLElement:(NSXMLElement *)xml {
    [super analysisXMLElement:xml];
    for (NSXMLElement *chlid in xml.children) {
        if ([chlid.name isEqualToString:@"fontDescription"]) { _fontElement = chlid; }
        if ([chlid.name isEqualToString:@"color"] && [[chlid attributeForName:@"key"].stringValue isEqualToString:@"textColor"]) {
            _textColor = [[JCColorXML alloc] initWithXML:chlid];
        }
    }
}

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [self addAttributeName:@"horizontalHuggingPriority" stringValue:@"251" inXML:xml];
    [self addAttributeName:@"verticalHuggingPriority" stringValue:@"251" inXML:xml];
    [self addAttributeName:@"text" stringValue:@"Label" inXML:xml];
    [self addAttributeName:@"textAlignment" stringValue:@"natural" inXML:xml];
    [self addAttributeName:@"lineBreakMode" stringValue:@"tailTruncation" inXML:xml];
    [self addAttributeName:@"baselineAdjustment" stringValue:@"alignBaselines" inXML:xml];
    [self addAttributeName:@"adjustsFontSizeToFit" stringValue:@"NO" inXML:xml];
    
    _fontElement = [self xmlElementWithString:@"<fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>"];
    [xml addChild:_fontElement];
    
    _textColor = [JCColorXML textColor];
    [xml addChild:_textColor.xml];
    [xml addChild:[self xmlElementWithString:@"<nil key=\"highlightedColor\"/>"]];
    return xml;
}

- (NSString *)nodeName {
    return @"label";
}

- (NSXMLNode *)contentMode {
    return [NSXMLNode attributeWithName:@"contentMode" stringValue:@"left"];
}

- (NSXMLNode *)opaque {
    return [NSXMLNode attributeWithName:@"opaque" stringValue:@"NO"];
}

- (NSXMLNode *)userInteractionEnabled {
    return [NSXMLNode attributeWithName:@"userInteractionEnabled" stringValue:@"NO"];
}

- (void)setupFamily:(NSString *)family FontName:(NSString *)fontName {
    [_fontElement removeAttributeForName:@"type"];
    [self addAttributeName:@"family" stringValue:family inXML:_fontElement];
    [self addAttributeName:@"fontName" stringValue:fontName inXML:_fontElement];
}

- (void)setupDatas:(JCNodeModel *)model {
    if (!model.text.length) { [super setupDatas:model]; }
    else {
        self.text = model.text;
        if ([model.align containsString:@"居中"]) { self.textAlignment = @"center"; }
        else if ([model.align containsString:@"右"]) { self.textAlignment = @"right"; }
        self.textColor.red = @(model.color_r / 255.0).stringValue;
        self.textColor.green = @(model.color_g / 255.0).stringValue;
        self.textColor.blue = @(model.color_b / 255.0).stringValue;
        self.textColor.alpha = @(model.color_a).stringValue;
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

- (void)setText:(NSString *)text {
    [self.xml attributeForName:@"text"].stringValue = text;
}

- (NSString *)text {
    return [self.xml attributeForName:@"text"].stringValue;
}

- (void)setTextColor:(JCColorXML *)textColor {
    if (_textColor) {
        [self.xml removeChildAtIndex:[self.xml.children indexOfObject:_textColor.xml]];
    }
    _textColor = textColor;
    [self.xml addChild:_textColor.xml];
}

- (void)setTextAlignment:(NSString *)textAlignment {
    [self.xml attributeForName:@"textAlignment"].stringValue = textAlignment;
}

- (NSString *)textAlignment {
    return [self.xml attributeForName:@"textAlignment"].stringValue;
}

- (void)setPointSize:(NSString *)pointSize {
    [_fontElement attributeForName:@"pointSize"].stringValue = pointSize;
}

- (NSString *)pointSize {
    return [_fontElement attributeForName:@"pointSize"].stringValue;
}

@end
