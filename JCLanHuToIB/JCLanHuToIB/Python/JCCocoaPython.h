//
//  JCCocoaPython.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/2.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCocoaPython : NSObject

- (instancetype)initWithPath:(NSString *)scrPath args:(NSArray<NSString *> *)arge;

/** 完成回调 */
@property (nonatomic, copy) void (^completed)(NSString *results, NSString *errors);

/** 是否异步执行回调，只在runAsync下生效 */
@property (nonatomic, assign) BOOL asyncComlete;

/** 同步执行 */
- (void)runSync;

/** 异步执行, asyncComlete: 回调是否异步主线程执行 */
- (void)runAsync:(BOOL)asyncComlete;

@end
