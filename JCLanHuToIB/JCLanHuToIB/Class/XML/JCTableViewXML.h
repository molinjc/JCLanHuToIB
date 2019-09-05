//
//  JCTableViewXML.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/5.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCScrollViewXML.h"

@class JCTableViewCellXML;

@interface JCTableViewXML : JCScrollViewXML

- (void)addCell:(JCTableViewCellXML *)cell;

/** 添加代理对象 */
- (void)addDelegate:(NSString *)dalegateUid;

/** 设置静态("static")或动态。默认动态"prototypes" */
@property (nonatomic, copy) NSString *dataMode;

/** TableView的分组类型，默认plain */
@property (nonatomic, copy) NSString *style;

@end


@interface JCTableViewCellXML : JCViewXML

@end
