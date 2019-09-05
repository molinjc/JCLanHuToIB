//
//  JCStoryboardXML.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCViewControllerXML.h"

@interface JCStoryboardXML : NSObject

- (instancetype)initWithPaht:(NSString *)path;

/** Storyboard的第一个控制器的id */
@property (nonatomic, readonly) NSString *initialViewController;

@property (nonatomic, strong, readonly) NSMutableArray<JCViewControllerXML *> *viewControllers;

/** 添加一个JCViewControllerXML */
- (void)addViewControllers:(JCViewControllerXML *)viewControllerXML;

- (void)save;

@end
