//
//  JCStoryboardXML.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCStoryboardXML.h"

@interface JCStoryboardXML ()
@property (nonatomic, strong) NSXMLDocument *document;
@property (nonatomic, strong) NSXMLElement *scenesElement;
@property (nonatomic, strong) NSXMLNode *initialNode;
@property (nonatomic, copy) NSString *path;
@end

@implementation JCStoryboardXML

- (instancetype)init {
    return [self initWithPaht:nil];
}

- (instancetype)initWithPaht:(NSString *)path {
    if (self = [super init]) {
        _path = path;
        [self _initWithPaht:path];
    }
    return self;
}

- (void)_initWithPaht:(NSString *)path {
    if (!path.length) { path = [[NSBundle mainBundle] pathForResource:@"sb" ofType:@"xml"]; }
    NSData *xmlData = [NSData dataWithContentsOfFile:path options:0 error:nil];
    if (!xmlData.length) {
        path = [[NSBundle mainBundle] pathForResource:@"sb" ofType:@"xml"];
        xmlData = [NSData dataWithContentsOfFile:path options:0 error:nil];
    }
    _document = [[NSXMLDocument alloc] initWithData:xmlData options:NSXMLNodePreserveWhitespace error:nil];
    _scenesElement = [_document.rootElement elementsForName:@"scenes"].firstObject;
    _viewControllers = [NSMutableArray new];
    
    for (NSXMLElement *child in _scenesElement.children) {
        if (child.children.count) {
            JCViewControllerXML *vcm = [[JCViewControllerXML alloc] initWithXML:(NSXMLElement *)child.children.firstObject.children.firstObject];
            [_viewControllers addObject:vcm];
        }
    }
}

- (void)addViewControllers:(JCViewControllerXML *)viewControllerXML {
    if ([_viewControllers containsObject:viewControllerXML]) { return; }
    
    NSXMLElement *scene = [NSXMLElement elementWithName:@"scene"];
    [scene addAttribute:[NSXMLNode attributeWithName:@"sceneID" stringValue:[JCUID sharedInstance].creatUid]];
    
    NSXMLElement *objects = [NSXMLElement elementWithName:@"objects"];
    [objects addChild:viewControllerXML.xml];
    [objects addChild:[self xmlElementWithString:[NSString stringWithFormat:@"<placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"%@\" sceneMemberID=\"firstResponder\"/>", [JCUID sharedInstance].creatUid]]];
    [scene addChild:objects];
    
    NSXMLElement *point = [self xmlElementWithString:@"<point key=\"canvasLocation\"/>"];
    NSInteger row = _viewControllers.count / 5;
    NSInteger index = _viewControllers.count % 5;
    [point addAttribute:[NSXMLNode attributeWithName:@"x" stringValue:@(100.0 + 600 * index).stringValue]];
    [point addAttribute:[NSXMLNode attributeWithName:@"y" stringValue:@(100.0 + 1000 * row).stringValue]];
    [scene addChild:point];
    
    if (_viewControllers.count == 0) {
        [_document.rootElement attributeForName:@"initialViewController"].stringValue = viewControllerXML.uid;
    }
    
    [_scenesElement addChild:scene];
    [_viewControllers addObject:viewControllerXML];
}

- (void)save {
    if (!_path.length) {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* thepath = [paths lastObject];
        _path = [thepath stringByAppendingPathComponent:@"jcib.storyboard"];
    }

    NSLog(@"保存路径：%@", _path);
    NSData *XMLData = [_document XMLDataWithOptions:NSXMLNodePrettyPrint];
    if (![XMLData writeToFile:_path atomically:YES]) {
        NSLog(@"Could not write document out...");
    }
}

- (NSString *)initialViewController {
    return [_document.rootElement attributeForName:@"initialViewController"].stringValue;
}

- (NSXMLElement *)xmlElementWithString:(NSString *)string {
    NSData *xmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithData:xmlData options:NSXMLNodePreserveWhitespace error:nil];
    return xmlDocument.rootElement;
}

@end
