//
//  JCColorXML.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCNodeXML : NSObject
@property (nonatomic, strong, readonly) NSXMLElement *xml;

- (instancetype)initWithXML:(NSXMLElement *)xml;

@end

@interface JCColorXML : JCNodeXML

+ (JCColorXML *)backgroundColor;

+ (JCColorXML *)textColor;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *red;
@property (nonatomic, copy) NSString *green;
@property (nonatomic, copy) NSString *blue;
@property (nonatomic, copy) NSString *alpha;

@end


@interface JCButtonState : JCNodeXML

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) JCColorXML *titleColor;
@end

