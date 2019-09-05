//
//  JCLabelModel.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCViewModel.h"

@interface JCLabelModel : JCViewModel

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *textAlignment;

@property (nonatomic, copy) NSString *pointSize;

@property (nonatomic, strong) JCColorModel *textColorModel;

/** 自定义字体时要两个属性一起设置 */
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, copy) NSString *family;
@end

