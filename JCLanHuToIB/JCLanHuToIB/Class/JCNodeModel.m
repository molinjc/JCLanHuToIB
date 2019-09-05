//
//  JCNodeModel.m
//  JCLanHuToIB
//
//  Created by Chuan on 2019/9/2.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCNodeModel.h"

@implementation JCNodeModel {
    NSString *uid;
}

- (NSString *)uid {
    if (uid) { return uid; }
    static NSString *source = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        source = @"0123456789ABCDEFGHIJKLMNOPQRSTUWVXZYabcdefghijklmnopqrstuwvxzy";
    });
    
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < 10; i++) {
        if (i == 3 || i == 6) { [result appendString:@"-"]; }
        else {
            unsigned index = rand() % [source length];
            NSString *one = [source substringWithRange:NSMakeRange(index, 1)];
            [result appendString:one];
        }
    }
    uid = result.mutableCopy;
    return uid;
}

- (NSString *)xml {
    if ([self.className isEqualToString:@"UILabel"]) { return [self xml_label]; }
    return nil;
}

- (NSString *)xml_label {
    NSString *textAlignment = @"natural";
    if ([self.align containsString:@"居中"]) {
        textAlignment = @"center";
    } else if ([self.align containsString:@"右"]) {
        textAlignment = @"right";
    }
    
    NSString *text = self.text;
    if (!text.length) { text = @"Label"; }
    
    NSString *fontDescription = [NSString stringWithFormat:@"<fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"%@\"/>", self.font_size];
    if (self.font.length) {
        static NSArray *familys = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            familys = @[@"Thonburi", @"Khmer Sangam MN", @"Kohinoor Telugu", @"Snell Roundhand", @"Academy Engraved LET", @"Marker Felt", @"Avenir", @"Geeza Pro", @"Arial Rounded MT Bold", @"Trebuchet MS", @"Arial", @"Menlo", @"Gurmukhi MN", @"Malayalam Sangam MN", @"Kannada Sangam MN", @"Bradley Hand", @"Bodoni 72 Oldstyle", @"Cochin", @"Sinhala Sangam MN", @"PingFang HK", @"Iowan Old Style", @"Kohinoor Bangla", @"Damascus", @"Al Nile", @"Farah", @"Papyrus", @"Verdana", @"Zapf Dingbats", @"Avenir Next Condensed", @"Courier", @"Hoefler Text", @"Euphemia UCAS", @"Helvetica", @"Lao Sangam MN", @"Hiragino Mincho ProN", @"Bodoni Ornaments", @"Apple Color Emoji", @"Mishafi", @"Optima", @"Gujarati Sangam MN", @"Devanagari Sangam MN", @"PingFang SC", @"Savoye LET", @"Times New Roman", @"Kailasa", @"Apple SD Gothic Neo", @"Futura", @"Bodoni 72", @"Baskerville", @"Symbol", @"Copperplate", @"Party LET", @"American Typewriter", @"Chalkboard SE", @"Avenir Next", @"Noteworthy", @"Hiragino Sans", @"Zapfino", @"Tamil Sangam MN", @"Chalkduster", @"Arial Hebrew", @"Georgia", @"Helvetica Neue", @"Gill Sans", @"Kohinoor Devanagari", @"Palatino", @"Courier New", @"Oriya Sangam MN", @"Didot", @"PingFang TC", @"Bodoni 72 Smallcaps"];
        });
        
        NSString *family = self.font;
        if ([self.font containsString:@"-"]) {
            family = [self.font componentsSeparatedByString:@"-"].firstObject;
        }
        
        if ([familys containsObject:family]) {
            fontDescription = [NSString stringWithFormat:@"<fontDescription key=\"fontDescription\" name=\"%@\" family=\"%@\" pointSize=\"%@\"/>", self.font, family, self.font_size];
        }
    }
    
    NSString *xml = [NSString stringWithFormat:@"<label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"%@\" textAlignment=\"%@\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\"><rect key=\"frame\" x=\"%@\" y=\"%@\" width=\"%@\" height=\"%@\"/><autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>%@<color key=\"textColor\" red=\"%f\" green=\"%f\" blue=\"%f\" alpha=\"%f\" colorSpace=\"calibratedRGB\"/><nil key=\"highlightedColor\"/></label>", text, textAlignment, self.uid, self.x, self.y, self.width, self.height, fontDescription, self.color_r / 255.0, self.color_g / 255.0, self.color_b / 255.0, self.color_a];
    return xml;
}

@end
