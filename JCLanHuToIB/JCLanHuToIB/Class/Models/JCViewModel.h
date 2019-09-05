//
//  JCViewModel.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCSBModel.h"
#import "JCColorModel.h"
#import "JCNodeModel.h"

#define _SETTER(arrt, e, value) \
NSXMLNode *rnode = nil; \
for (NSXMLNode *node in e.attributes) { if ([node.name isEqualToString:arrt]) { node.stringValue = value; rnode = node; break; }} \
if (!rnode) { [e addAttribute:[NSXMLNode attributeWithName:arrt stringValue:value]];}


#define _COLORSTR(c) @(c / 255.0).stringValue

@interface JCViewModel : JCSBModel

/** 子类实现的，外部不要调用 */
- (NSXMLElement *)creatViewControllerXML;

/** 视图的id */
@property (nonatomic, copy) NSString *vid;

/** 内容模式，一般是scaleToFill */
@property (nonatomic, copy) NSString *contentMode;

@property (nonatomic, copy) NSString *x;

@property (nonatomic, copy) NSString *y;

@property (nonatomic, copy) NSString *width;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *alpha;

/** 懒加载, 背景颜色 */
@property (nonatomic, strong) JCColorModel *colorModel;

/** 添加视图 */
- (void)addSubview:(JCViewModel *)subview;

@property (nonatomic, strong, readonly) NSMutableArray *subviews;

- (void)setupDatas:(JCNodeModel *)data;

@end
