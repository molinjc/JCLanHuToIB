//
//  JCSBModel.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCSBModel.h"

static NSMutableArray<NSString *> *uids = nil;

@implementation JCSBModel {
    NSString *_uid;
}

- (instancetype)initWithXMLElement:(NSXMLElement *)xml {
    if (self = [super init]) {
        _xml = [self analysisXML:xml];
    }
    return self;
}

- (NSXMLElement *)analysisXML:(NSXMLElement *)xml {
    return xml;
}

- (NSString *)creatUid {
    static NSString *source = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        source = @"0123456789ABCDEFGHIJKLMNOPQRSTUWVXZYabcdefghijklmnopqrstuwvxzy";
        uids = @[].mutableCopy;
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
    
    if ([uids containsObject:result]) {
        NSString *uid = [self uid];
        [uids addObject:uid];
        return uid;
    }
    [uids addObject:result.mutableCopy];
    return result.mutableCopy;
}

- (void)setUid:(NSString *)uid {
    _uid = uid;
    if (![uids containsObject:uid]) { [uids addObject:uid]; }
}

- (NSString *)uid {
    if (!_uid) {
        _uid = [self creatUid];
    }
    return _uid;
}

- (NSXMLElement *)elementWithXML:(NSString *)xml {
    NSData *xmlData = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithData:xmlData options:NSXMLNodePreserveWhitespace error:nil];
    return xmlDocument.rootElement;
}

- (NSString *)nodeName {
    return @"";
}

@end
