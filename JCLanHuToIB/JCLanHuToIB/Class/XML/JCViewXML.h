//
//  JCViewXML.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCBaseXML.h"
#import "JCColorXML.h"
#import "JCNodeModel.h"

@interface JCViewXML : JCBaseXML

/** 作为Controller.view时调用，指定容器的类型 */
- (void)addKeyNodeWithValue:(NSString *)value;

/** 作为Controller.view时调用，全屏设置 */
- (void)setupFullScreen;

@property (nonatomic, copy) NSString *x;

@property (nonatomic, copy) NSString *y;

@property (nonatomic, copy) NSString *width;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *alpha;

@property (nonatomic, strong) JCColorXML *backgroundColor;

@property (nonatomic, strong) NSMutableArray<JCViewXML *> *subviews;

- (void)addSubviews:(JCViewXML *)viewXML;

/** 设置数据 */
- (void)setupDatas:(JCNodeModel *)model;

/** 默认scaleToFill */
- (NSXMLNode *)contentMode;

- (NSXMLNode *)fixedFrame;

- (NSXMLNode *)translatesAutoresizingMaskIntoConstraints;

- (NSXMLNode *)opaque;

- (NSXMLNode *)userInteractionEnabled;

@property (nonatomic, copy) NSString *key;

@end
