//
//  JCViewControllerXML.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCLabeLXML.h"

@interface JCViewControllerXML : JCBaseXML

@property (nonatomic, strong, readonly) JCViewXML *viewXML;

@property (nonatomic, copy) NSString *title;

- (void)addSubviews:(JCViewXML *)viewXML;

/** 返回所有子视图 */
- (NSArray<JCViewXML *> *)allSubviews;

- (Class)viewXMLClass;

- (NSString *)viewKey;

- (NSString *)viewNodeName;

@end
