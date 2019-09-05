//
//  JCUID.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCUID : NSObject

+ (instancetype)sharedInstance;

- (NSString *)creatUid;

- (void)addUid:(NSString *)uid;

@end
