//
//  JCSBModel.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCSBModel : NSObject

/** 随机生成一串id */
- (NSString *)creatUid;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, strong, readonly) NSXMLElement *xml;

/** 可传nil */
- (instancetype)initWithXMLElement:(NSXMLElement *)xml;

/** 子类重写 */
- (NSXMLElement *)analysisXML:(NSXMLElement *)xml;

/** 将xml字符串转成XMLElement对象 */
- (NSXMLElement *)elementWithXML:(NSString *)xml;

/** 节点的名称 */
- (NSString *)nodeName;

@end
