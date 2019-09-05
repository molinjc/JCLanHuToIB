//
//  JCLabelModel.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCLabelModel.h"

@interface JCLabelModel ()
@property (nonatomic, strong) NSXMLNode *textNode;
@property (nonatomic, strong) NSXMLNode *textAlignmentNode;
@property (nonatomic, strong) NSXMLElement *font;
@property (nonatomic, strong) NSXMLNode *fontNameNode;
@property (nonatomic, strong) NSXMLNode *familyNode;
@property (nonatomic, strong) NSXMLNode *pointSizeNode;
@end

@implementation JCLabelModel

- (NSString *)nodeName {
    return @"label";
}

- (NSXMLElement *)creatViewControllerXML {
    NSXMLElement *element = [super creatViewControllerXML];
    self.contentMode = @"left";
    [element addAttribute:[NSXMLNode attributeWithName:@"opaque" stringValue:@"NO"]];
    [element addAttribute:[NSXMLNode attributeWithName:@"userInteractionEnabled" stringValue:@"NO"]];
    [element addAttribute:[NSXMLNode attributeWithName:@"horizontalHuggingPriority" stringValue:@"251"]];
    [element addAttribute:[NSXMLNode attributeWithName:@"verticalHuggingPriority" stringValue:@"251"]];
    _textNode = [NSXMLNode attributeWithName:@"text" stringValue:@"Label"];
    [element addAttribute:_textNode];
    _textAlignmentNode = [NSXMLNode attributeWithName:@"textAlignment" stringValue:@"natural"];
    [element addAttribute:_textAlignmentNode];
    [element addAttribute:[NSXMLNode attributeWithName:@"lineBreakMode" stringValue:@"tailTruncation"]];
    [element addAttribute:[NSXMLNode attributeWithName:@"baselineAdjustment" stringValue:@"alignBaselines"]];
    [element addAttribute:[NSXMLNode attributeWithName:@"adjustsFontSizeToFit" stringValue:@"NO"]];
    
    NSXMLElement *font = [self elementWithXML:@"<fontDescription key=\"fontDescription\" type=\"system\"/>"];
    _pointSizeNode = [NSXMLNode attributeWithName:@"pointSize" stringValue:@"17"];
    [font addAttribute:_pointSizeNode];
    [element addChild:font];
    _font = font;
    
    [element addChild:[self elementWithXML:@"<nil key=\"highlightedColor\"/>"]];
    return element;
}


- (void)setupDatas:(JCNodeModel *)data {
    if (!data.font.length) {
        [super setupDatas:data];
    } else {
        if (!self.x.length) {
            self.x = data.x;
            self.y = data.y;
            self.width = data.width;
            self.height = data.height;
            self.alpha = @(data.opaque).stringValue;
        }
        
        self.text = data.text;
        static NSArray *familys = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            familys = @[@"Thonburi", @"Khmer Sangam MN", @"Kohinoor Telugu", @"Snell Roundhand", @"Academy Engraved LET", @"Marker Felt", @"Avenir", @"Geeza Pro", @"Arial Rounded MT Bold", @"Trebuchet MS", @"Arial", @"Menlo", @"Gurmukhi MN", @"Malayalam Sangam MN", @"Kannada Sangam MN", @"Bradley Hand", @"Bodoni 72 Oldstyle", @"Cochin", @"Sinhala Sangam MN", @"PingFang HK", @"Iowan Old Style", @"Kohinoor Bangla", @"Damascus", @"Al Nile", @"Farah", @"Papyrus", @"Verdana", @"Zapf Dingbats", @"Avenir Next Condensed", @"Courier", @"Hoefler Text", @"Euphemia UCAS", @"Helvetica", @"Lao Sangam MN", @"Hiragino Mincho ProN", @"Bodoni Ornaments", @"Apple Color Emoji", @"Mishafi", @"Optima", @"Gujarati Sangam MN", @"Devanagari Sangam MN", @"PingFang SC", @"Savoye LET", @"Times New Roman", @"Kailasa", @"Apple SD Gothic Neo", @"Futura", @"Bodoni 72", @"Baskerville", @"Symbol", @"Copperplate", @"Party LET", @"American Typewriter", @"Chalkboard SE", @"Avenir Next", @"Noteworthy", @"Hiragino Sans", @"Zapfino", @"Tamil Sangam MN", @"Chalkduster", @"Arial Hebrew", @"Georgia", @"Helvetica Neue", @"Gill Sans", @"Kohinoor Devanagari", @"Palatino", @"Courier New", @"Oriya Sangam MN", @"Didot", @"PingFang TC", @"Bodoni 72 Smallcaps"];
        });
        
        NSString *family = data.font;
        if ([data.font containsString:@"-"]) {
            family = [data.font componentsSeparatedByString:@"-"].firstObject;
        }
        
        if ([familys containsObject:family]) {
            self.fontName = data.font;
            self.family = family;
            [_font removeAttributeForName:@"type"];
        }
        
        _pointSizeNode.stringValue = data.font_size;
        [self.textColorModel r:_COLORSTR(data.color_r) g:_COLORSTR(data.color_g) b:_COLORSTR(data.color_b) a:@(data.color_a).stringValue];
        
        if ([data.align containsString:@"居中"]) {
            self.textAlignment = @"center";
        } else if ([data.align containsString:@"右"]) {
            self.textAlignment = @"right";
        }
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    _textNode.stringValue = text;
}

- (void)setTextAlignment:(NSString *)textAlignment {
    _textAlignment = textAlignment;
    _textAlignmentNode.stringValue = textAlignment;
}

- (void)setPointSize:(NSString *)pointSize {
    _pointSize = pointSize;
    _pointSizeNode.stringValue = pointSize;
}

- (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    if (!_fontNameNode) {
        _fontNameNode = [NSXMLNode attributeWithName:@"name" stringValue:fontName];
        [_font addAttribute:_fontNameNode];
    }
    _fontNameNode.stringValue = fontName;
}

- (void)setFamily:(NSString *)family {
    _family = family;
    if (!_familyNode) {
        _familyNode = [NSXMLNode attributeWithName:@"family" stringValue:family];
        [_font addAttribute:_familyNode];
    }
    _familyNode.stringValue = family;
}

- (JCColorModel *)textColorModel {
    if (!_textColorModel) {
        _textColorModel = [[JCColorModel alloc] initWithXMLElement:nil];
        _textColorModel.key = @"textColor";
        [self.xml addChild:_textColorModel.xml];
    }
    return _textColorModel;
}

@end
