//
//  JCBaseXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCBaseXML.h"

static NSMutableArray<NSString *> *uids = nil;

@implementation JCBaseXML {
    NSString *_uid;
}

- (void)setUid:(NSString *)uid {
    _uid = uid;
    [[JCUID sharedInstance] addUid:uid];
}

- (NSString *)uid {
    if (!_uid) { _uid = [[JCUID sharedInstance] creatUid]; }
    return _uid;
}

- (NSXMLElement *)xmlElementWithString:(NSString *)string {
    NSData *xmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithData:xmlData options:NSXMLNodePreserveWhitespace error:nil];
    return xmlDocument.rootElement;
}

- (NSXMLNode *)addAttributeName:(NSString *)name stringValue:(NSString *)value inXML:(NSXMLElement *)xml {
    NSXMLNode *node = [xml attributeForName:name];
    if (!node) {
        node = [NSXMLNode attributeWithName:name stringValue:value];
        [xml addAttribute:node];
    } else {
        node.stringValue = value;
    }
    return node;
}


- (instancetype)init {
    return [self initWithXML:nil];
}

- (instancetype)initWithXML:(NSXMLElement *)xml {
    if (self = [super init]) {
        _xml = xml;
        if (_xml) { [self analysisXMLElement:_xml]; }
        else { _xml = [self createXMLElement]; }
    }
    return self;
}

- (void)analysisXMLElement:(NSXMLElement *)xml {
    self.uid = [xml attributeForName:@"id"].stringValue;
}

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [NSXMLElement elementWithName:[self nodeName]];
    [xml addAttribute:[NSXMLNode attributeWithName:@"id" stringValue:self.uid]];
    return xml;
}

- (NSString *)nodeName {
    return @"";
}

@end
