//
//  JCTableViewXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/5.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCTableViewXML.h"

@interface JCTableViewXML ()
@property (nonatomic, strong) NSXMLElement *prototypesElement;
@property (nonatomic, strong) JCViewXML *tableHeaderViewXML;
@property (nonatomic, strong) JCViewXML *tableFooterViewXML;
@end

@implementation JCTableViewXML

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [self addAttributeName:@"alwaysBounceVertical" stringValue:@"YES" inXML:xml];
    [self addAttributeName:@"dataMode" stringValue:@"prototypes" inXML:xml];
    [self addAttributeName:@"style" stringValue:@"plain" inXML:xml];
    [self addAttributeName:@"separatorStyle" stringValue:@"default" inXML:xml];
    [self addAttributeName:@"separatorStyle" stringValue:@"default" inXML:xml];
    [self addAttributeName:@"rowHeight" stringValue:@"-1" inXML:xml];
    [self addAttributeName:@"estimatedRowHeight" stringValue:@"-1" inXML:xml];
    [self addAttributeName:@"sectionHeaderHeight" stringValue:@"28" inXML:xml];
    [self addAttributeName:@"sectionFooterHeight" stringValue:@"28" inXML:xml];
    return xml;
}

- (NSXMLNode *)multipleTouchEnabled {
    return nil;
}

- (void)addSubviews:(JCViewXML *)viewXML {
    if ([viewXML isKindOfClass:[JCTableViewCellXML class]]) {
        [self addCell:(JCTableViewCellXML *)viewXML];
    } else {
        if (!_tableHeaderViewXML) {
            _tableHeaderViewXML = viewXML;
            _tableHeaderViewXML.key = @"tableHeaderView";
            [self.xml addChild:_tableHeaderViewXML.xml];
        } else if (!_tableFooterViewXML) {
            _tableFooterViewXML = viewXML;
            _tableFooterViewXML.key = @"tableFooterView";
            [self.xml addChild:_tableFooterViewXML.xml];
        }
    }
}

- (void)addCell:(JCTableViewCellXML *)cell {
    if (!_prototypesElement) {
        _prototypesElement = [NSXMLElement elementWithName:@"prototypes"];
        [self.xml addChild:_prototypesElement];
        [self.xml addChild:[NSXMLElement elementWithName:@"sections"]];
    }
    [_prototypesElement addChild:cell.xml];
}

- (void)addDelegate:(NSString *)dalegateUid {
    NSXMLElement *connections = nil;
    for (NSXMLElement *child in self.xml.children) {
        if ([child.name isEqualToString:@"connections"]) {
            connections = child;
            for (NSXMLElement *outlet in connections.children) {
                [outlet attributeForName:@"destination"].stringValue = dalegateUid;
            }
            break;
        }
    }
    
    if (!connections) {
        connections = [self xmlElementWithString:[NSString stringWithFormat:@"<connections><outlet property=\"dataSource\" destination=\"%@\" id=\"%@\"/><outlet property=\"delegate\" destination=\"%@\" id=\"%@\"/></connections>", dalegateUid, [JCUID sharedInstance].creatUid, dalegateUid, [JCUID sharedInstance].creatUid]];
        [self.xml addChild:connections];
    }
}

- (void)setDataMode:(NSString *)dataMode {
    [self.xml attributeForName:@"dataMode"].stringValue = dataMode;
}

- (NSString *)dataMode {
    return [self.xml attributeForName:@"dataMode"].stringValue;
}

- (void)setStyle:(NSString *)style {
    [self.xml attributeForName:@"style"].stringValue = style;
}

- (NSString *)style {
    return [self.xml attributeForName:@"style"].stringValue;
}

@end


@interface JCTableViewCellContentViewXML : JCScrollViewXML
@property (nonatomic, copy) NSString *tableViewCell;
@end

@implementation JCTableViewCellContentViewXML

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [self addAttributeName:@"key" stringValue:@"contentView" inXML:xml];
    [self addAttributeName:@"preservesSuperviewLayoutMargins" stringValue:@"YES" inXML:xml];
    [self addAttributeName:@"insetsLayoutMarginsFromSafeArea" stringValue:@"NO" inXML:xml];
    
    NSXMLElement *autoresizingMask = nil;
    for (NSXMLElement *child in xml.children) {
        if ([child.name isEqualToString:@"autoresizingMask"]) { autoresizingMask = child; break; }
    }
    
    if (autoresizingMask) {
        [xml removeChildAtIndex:[xml.children indexOfObject:autoresizingMask]];
    }
    [xml addChild:[self xmlElementWithString:@"<autoresizingMask key=\"autoresizingMask\"/>"]];
    
    return xml;
}

- (NSString *)nodeName {
    return @"tableViewCellContentView";
}

- (NSXMLNode *)contentMode {
    return [NSXMLNode attributeWithName:@"contentMode" stringValue:@"center"];
}

- (NSXMLNode *)opaque {
    return [NSXMLNode attributeWithName:@"opaque" stringValue:@"NO"];;
}

- (void)setTableViewCell:(NSString *)tableViewCell {
    NSXMLNode *node = [self.xml attributeForName:@"tableViewCell"];
    if (!node) {
        node = [NSXMLNode attributeWithName:@"tableViewCell" stringValue:tableViewCell];
        [self.xml addAttribute:node];
    } else {
        node.stringValue = tableViewCell;
    }
}

- (NSString *)tableViewCell {
    return [self.xml attributeForName:@"tableViewCell"].stringValue;
}

@end



@interface JCTableViewCellXML ()
@property (nonatomic, strong) JCTableViewCellContentViewXML *tableViewCellContentView;
@end

@implementation JCTableViewCellXML

- (void)analysisXMLElement:(NSXMLElement *)xml {
    [super analysisXMLElement:xml];
    for (NSXMLElement *child in xml.children) {
        if ([child.name isEqualToString:@"tableViewCellContentView"]) {
            _tableViewCellContentView = [[JCTableViewCellContentViewXML alloc] initWithXML:child];
            break;
        }
    }
}

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [self addAttributeName:@"alwaysBounceVertical" stringValue:@"YES" inXML:xml];
    [self addAttributeName:@"dataMode" stringValue:@"prototypes" inXML:xml];
    [self addAttributeName:@"style" stringValue:@"plain" inXML:xml];
    [self addAttributeName:@"separatorStyle" stringValue:@"default" inXML:xml];
    [self addAttributeName:@"separatorStyle" stringValue:@"default" inXML:xml];
    [self addAttributeName:@"rowHeight" stringValue:@"-1" inXML:xml];
    [self addAttributeName:@"estimatedRowHeight" stringValue:@"-1" inXML:xml];
    [self addAttributeName:@"sectionHeaderHeight" stringValue:@"28" inXML:xml];
    [self addAttributeName:@"sectionFooterHeight" stringValue:@"28" inXML:xml];
    _tableViewCellContentView = [[JCTableViewCellContentViewXML alloc] init];
    _tableViewCellContentView.tableViewCell = self.uid;
    [xml addChild:_tableViewCellContentView.xml];
    return xml;
}

- (void)addSubviews:(JCViewXML *)viewXML {
    [_tableViewCellContentView addSubviews:viewXML];
}

- (void)setWidth:(NSString *)width {
    [super setWidth:width];
    _tableViewCellContentView.width = width;
}

- (void)setHeight:(NSString *)height {
    [super setHeight:height];
    _tableViewCellContentView.height = @(height.floatValue - 0.5).stringValue;
}

@end
