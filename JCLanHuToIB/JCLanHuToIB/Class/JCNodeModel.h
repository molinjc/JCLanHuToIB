//
//  JCNodeModel.h
//  JCLanHuToIB
//
//  Created by Chuan on 2019/9/2.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCNodeModel : NSObject
@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, assign) float opaque;
@property (nonatomic, copy) NSString *font;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *align;
@property (nonatomic, assign) float color_r;
@property (nonatomic, assign) float color_g;
@property (nonatomic, assign) float color_b;
@property (nonatomic, assign) float color_a;
@property (nonatomic, copy) NSString *font_size;
@property (nonatomic, copy) NSString *text;
- (NSString *)xml;

@end
