//
//  JCColorModel.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCSBModel.h"

/** 为了简单，这里只定义两种，calibratedRGB和genericGamma22GrayColorSpace
 默认是calibratedRGB，若有修改，则默认genericGamma22GrayColorSpace*/
@interface JCColorModel : JCSBModel

/** 默认是backgroundColor，文本的是‘textColor’ */
@property (nonatomic, copy) NSString *key;

- (void)r:(NSString *)r g:(NSString *)g b:(NSString *)b a:(NSString *)a;

@end
