//
//  JCViewControllerModel.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCViewControllerModel.h"

@interface JCViewControllerModel ()
/** subviews的节点，子视图都是添加到这里的 */
@property (nonatomic, strong) NSXMLElement *subviewsElement;
@end

@implementation JCViewControllerModel

- (NSXMLElement *)analysisXML:(NSXMLElement *)xml {
    _subviews = [NSMutableArray new];

    if (!xml) {
        xml = [self creatViewControllerXML];
    } else {
        for (NSXMLNode *node in xml.attributes) {
            if ([node.name isEqualToString:@"id"]) { _vid = node.stringValue; }
            if ([node.name isEqualToString:@"title"]) { _title = node.stringValue; }
        }
        
        for (NSXMLElement *element in xml.children) {
            if ([element.name isEqualToString:@"view"]) {
                for (NSXMLElement *subelement  in element.children) {
                    if ([subelement.name isEqualToString:@"subviews"]) { _subviewsElement = subelement; }
                }
                break;
            }
        }

        for (NSXMLElement *element in _subviewsElement.children) {
            if ([element.name isEqualToString:@"view"]) {
                [_subviews addObject:[[JCViewModel alloc] initWithXMLElement:element]];
            } else if ([element.name isEqualToString:@"label"]) {
                [_subviews addObject:[[JCLabelModel alloc] initWithXMLElement:element]];
            }
        }
    }
    return xml;
}

- (NSXMLElement *)creatViewControllerXML {
    NSXMLElement *element = [NSXMLElement elementWithName:[self nodeName]];
    _vid = [self uid];
    [element addAttribute:[NSXMLNode attributeWithName:@"id" stringValue:_vid]];
    [element addAttribute:[NSXMLNode attributeWithName:@"sceneMemberID" stringValue:@"viewController"]];
    
    NSXMLElement *viewElement = [NSXMLElement elementWithName:[self viewName]];
    [element addChild:viewElement];
    [viewElement addAttribute:[NSXMLNode attributeWithName:@"key" stringValue:@"view"]];
    [viewElement addAttribute:[NSXMLNode attributeWithName:@"contentMode" stringValue:@"scaleToFill"]];
    [viewElement addAttribute:[NSXMLNode attributeWithName:@"id" stringValue:[self creatUid]]];
    
    NSXMLElement *rect = [self elementWithXML:@"<rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"414\" height=\"896\"/>"];
    [viewElement addChild:rect];
    
    NSXMLElement *autoresizingMask = [self elementWithXML:@"<autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>"];
    [viewElement addChild:autoresizingMask];
    
    _subviewsElement = [NSXMLElement elementWithName:@"subviews"];
    [viewElement addChild:_subviewsElement];
    
    NSXMLElement *color = [self elementWithXML:@"<color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"genericGamma22GrayColorSpace\"/>"];
    [viewElement addChild:color];
    
    NSXMLElement *viewLayoutGuide = [self elementWithXML:[NSString stringWithFormat:@"<viewLayoutGuide key=\"safeArea\" id=\"%@\"/>", [self creatUid]]];
    [viewElement addChild:viewLayoutGuide];
    
    return element;
}

- (NSString *)nodeName {
    return @"viewController";
}

- (NSString *)viewName {
    return @"view";
}

- (void)addSubviews:(JCViewModel *)subview {
    [_subviews addObject:subview];
    [_subviewsElement addChild:subview.xml];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    NSXMLNode *titleNode = nil;
    for (NSXMLNode *node in self.xml.attributes) {
        if ([node.name isEqualToString:@"title"]) {
            node.stringValue = title;
            titleNode = node;
            break;
        }
    }
    
    if (!titleNode) {
        [self.xml addAttribute:[NSXMLNode attributeWithName:@"title" stringValue:title]];
    }
}

- (void)setCustomClass:(NSString *)customClass {
    _customClass = customClass;
    NSXMLNode *customClassNode = nil;
    for (NSXMLNode *node in self.xml.attributes) {
        if ([node.name isEqualToString:@"customClass"]) {
            node.stringValue = customClass;
            customClassNode = node;
            break;
        }
    }
    
    if (!customClassNode) {
        [self.xml addAttribute:[NSXMLNode attributeWithName:@"customClass" stringValue:customClass]];
    }
}

@end
