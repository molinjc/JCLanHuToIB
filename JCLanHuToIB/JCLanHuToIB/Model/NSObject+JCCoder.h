//
//  NSObject+JCCoder.h
//  JCUIKit
//
//  Created by Chuan on 2019/1/29.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCClassInfo.h"

/** 获取self所有的属性信息 */
extern void JCUI_ObjectAllPropertyInfo(id self, void (^propertyBlock)(JCClassPropertyInfo *info));

@interface NSObject (JCCoder)

/** 解档某属性，可与JCUI_ObjectAllPropertyInfo配合使用 */
- (void)jcui_coder:(NSCoder *)coder decodeObjectForPropertyInfo:(JCClassPropertyInfo *)info;

/** 归档某属性，可与JCUI_ObjectAllPropertyInfo配合使用 */
- (void)jcui_coder:(NSCoder *)coder encodeObjectForPropertyInfo:(JCClassPropertyInfo *)info;

/** 归档到某路径上，并返回是否成功状态 */
- (BOOL)archiveToFile:(NSString *)path;

/** 从某路径上解档某数据 */
+ (id)unarchiveForFile:(NSString *)path;

@end
