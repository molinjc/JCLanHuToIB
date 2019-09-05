//
//  JCUIArchivedObject.h
//  JCUIKit
//
//  Created by Chuan on 2019/2/21.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 作为可归档的model的基类，基类负责归档解档，子类负责属性的操作 */
@interface JCUIArchivedObject : NSObject <NSSecureCoding>

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)decoder NS_DESIGNATED_INITIALIZER;

- (void)encodeWithCoder:(NSCoder *)aCoder NS_REQUIRES_SUPER;

/** 解档在path路径上的归档文件 */
+ (instancetype)unarchivedWithFile:(NSString *)path;

/** 解档在documents路径上叫name的归档文件 */
+ (instancetype)unarchivedNamed:(NSString *)name;

/** 解档在documents路径上与类名一样的归档文件 */
+ (instancetype)unarchived;

/** 归档后存放在path路径上 */
- (BOOL)archivedWithFile:(NSString *)path;

/** 归档后存放在documents路径并以name命名文件 */
- (BOOL)archivedNamed:(NSString *)name;

/** 归档后存放在documents路径并以类名命名文件 */
- (BOOL)archived;

/** 将所有属性值设为null */
- (void)clearAllValue;

@end

