//
//  JCViewControllerXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCViewControllerXML.h"

@interface JCViewControllerXML ()

@end

@implementation JCViewControllerXML

- (BOOL)isEqual:(id)object {
    return [((JCViewControllerXML *)object).uid isEqualToString:self.uid];
}

- (void)analysisXMLElement:(NSXMLElement *)xml {
    [super analysisXMLElement:xml];
    for (NSXMLElement *child in xml.children) {
        if ([child.name isEqualToString:[self viewNodeName]]) {
            _viewXML = [[[self viewXMLClass] alloc] initWithXML:child];
            break;
        }
    }
}

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [self addAttributeName:@"sceneMemberID" stringValue:@"viewController" inXML:xml];
    _viewXML = [[[self viewXMLClass] alloc] initWithXML:nil];
    [_viewXML setupFullScreen];
    [_viewXML addKeyNodeWithValue:[self viewKey]];
    _viewXML.width = @"414";
    _viewXML.height = @"896";
    
    NSXMLElement *viewLayoutGuide = [self viewLayoutGuide];
    if (viewLayoutGuide) { [_viewXML.xml addChild:viewLayoutGuide]; }
    
    [xml addChild:_viewXML.xml];
    return xml;
}

- (void)addSubviews:(JCViewXML *)viewXML {
    [_viewXML addSubviews:viewXML];
}

- (NSArray<JCViewXML *> *)allSubviews {
    return [self _allSubviewsWithViewXML:_viewXML];
}

- (NSArray *)_allSubviewsWithViewXML:(JCViewXML *)viewXML {
    NSMutableArray *allSubviews = [NSMutableArray new];
    for (JCViewXML *xml in viewXML.subviews) {
        [allSubviews addObject:xml];
        if (xml.subviews.count) { [allSubviews addObjectsFromArray:[self _allSubviewsWithViewXML:xml]]; }
    }
    return allSubviews;
}

- (NSString *)nodeName {
    return @"viewController";
}

- (NSString *)viewNodeName {
    return @"view";
}

- (Class)viewXMLClass {
    return [JCViewXML class];
}

- (NSString *)viewKey {
    return @"view";
}

- (NSXMLElement *)viewLayoutGuide {
    return [self xmlElementWithString:[NSString stringWithFormat:@"<viewLayoutGuide key=\"safeArea\" id=\"%@\"/>", [JCUID sharedInstance].creatUid]];
}

#pragma mark - Setter/Getter

- (void)setTitle:(NSString *)title {
    [self addAttributeName:@"title" stringValue:title inXML:self.xml];
}

- (NSString *)title {
    return [self.xml attributeForName:@"title"].stringValue;
}

@end
