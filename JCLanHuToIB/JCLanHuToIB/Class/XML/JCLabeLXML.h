//
//  JCLabeLXML.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCViewXML.h"

@interface JCLabeLXML : JCViewXML

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) JCColorXML *textColor;

@property (nonatomic, copy) NSString *textAlignment;

@property (nonatomic, copy) NSString *pointSize;

- (void)setupFamily:(NSString *)family FontName:(NSString *)fontName;

@end
