//
//  JCTableViewControllerXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/5.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCTableViewControllerXML.h"

@implementation JCTableViewControllerXML

- (NSXMLElement *)createXMLElement {
    NSXMLElement *xml = [super createXMLElement];
    [((JCTableViewXML *)self.viewXML) addDelegate:self.uid];
    
//    移除
//    translatesAutoresizingMaskIntoConstraints
    
    return xml;
}

- (NSString *)nodeName {
    return @"tableViewController";
}

- (NSString *)viewNodeName {
    return @"tableView";
}

- (Class)viewXMLClass {
    return [JCTableViewXML class];
}

- (NSString *)viewKey {
    return @"view";
}

@end
