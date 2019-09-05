//
//  JCBaseXML.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCUID.h"

@interface JCBaseXML : NSObject

@property (nonatomic, strong, readonly) NSXMLElement *xml;

@property (nonatomic, copy) NSString *uid;

/** xml可传nil */
- (instancetype)initWithXML:(NSXMLElement *)xml;

/** 子类可重写 */
- (void)analysisXMLElement:(NSXMLElement *)xml;

/** 子类可重写 */
- (NSXMLElement *)createXMLElement;

/** 节点的名称 */
- (NSString *)nodeName;

/** 将字符串转成XML对象 */
- (NSXMLElement *)xmlElementWithString:(NSString *)string;

- (NSXMLNode *)addAttributeName:(NSString *)name stringValue:(NSString *)value inXML:(NSXMLElement *)xml;

@end

