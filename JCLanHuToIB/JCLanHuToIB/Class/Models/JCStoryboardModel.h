//
//  JCStoryboardModel.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCViewControllerModel.h"

@interface JCStoryboardModel : NSObject

+ (instancetype)createStoryboard;

+ (instancetype)storyboardWithPath:(NSString *)path;

/** 加载本地的sb文件 */
+ (instancetype)loadLocationStoryboard;

/** 保存到本地，名为‘jcib.storyboard’，与+loadLocationStoryboard一起使用 */
- (void)save;

- (BOOL)saveWithPath:(NSString *)path;

/** Storyboard的第一个控制器的id */
@property (nonatomic, readonly) NSString *initialViewController;

/** 添加一个scene(包含viewController) */
- (void)addSceneWithViewController:(JCViewControllerModel *)model;

@property (nonatomic, strong, readonly) NSMutableArray<JCViewControllerModel *> *viewControllers;

@end
