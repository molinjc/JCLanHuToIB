//
//  JCViewControllerModel.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCSBModel.h"
#import "JCLabelModel.h"

/** 控制器的对象类 */
@interface JCViewControllerModel : JCSBModel

/** 控制器的标题 */
@property (nonatomic, copy) NSString *title;

/** 控制器的id */
@property (nonatomic, copy) NSString *vid;

/** 控制器的类型 */
@property (nonatomic, copy) NSString *customClass;

/** view节点的名称，默认'view' */
- (NSString *)viewName;

/** view节点 */
@property (nonatomic, strong) NSXMLElement *viewElement;

/** 添加子视图(节点) */
- (void)addSubviews:(JCViewModel *)subelement;

@property (nonatomic, strong, readonly) NSMutableArray<JCViewModel *> *subviews;

@end
