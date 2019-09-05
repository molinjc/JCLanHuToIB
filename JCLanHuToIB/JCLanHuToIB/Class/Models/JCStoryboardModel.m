//
//  JCStoryboardModel.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/3.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCStoryboardModel.h"

@interface JCStoryboardModel ()
@property (nonatomic, strong) NSXMLDocument *document;
@property (nonatomic, strong) NSXMLElement *scenesElement;
@property (nonatomic, strong) NSXMLNode *initialNode;
@end

@implementation JCStoryboardModel

- (instancetype)init {
    if (self = [super init]) {
        _viewControllers = @[].mutableCopy;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    if (self = [self init]) {
        NSData *xmlData = [NSData dataWithContentsOfFile:path options:0 error:nil];
        _document = [[NSXMLDocument alloc] initWithData:xmlData options:NSXMLNodePreserveWhitespace error:nil];
        _scenesElement = [_document.rootElement elementsForName:@"scenes"].firstObject;
        
        for (NSXMLNode *node in _document.rootElement.attributes) {
            if ([node.name isEqualToString:@"initialViewController"]) { _initialNode = node; _initialViewController = node.stringValue; break;}
        }
        
        for (NSXMLElement *scene in _scenesElement.children) {
            if (scene.children.count) {
                JCViewControllerModel *vcm = [[JCViewControllerModel alloc] initWithXMLElement:(NSXMLElement *)scene.children.firstObject.children.firstObject];
                [_viewControllers addObject:vcm];
            }
        }
    }
    return self;
}

+ (instancetype)createStoryboard {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sb" ofType:@"xml"];
    JCStoryboardModel *model = [[self alloc] initWithPath:path];
    return model;
}

+ (instancetype)storyboardWithPath:(NSString *)path {
    return  [[self alloc] initWithPath:path];
}

+ (instancetype)loadLocationStoryboard {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* thepath = [paths lastObject];
    thepath = [thepath stringByAppendingPathComponent:@"jcib.storyboard"];
    return [self storyboardWithPath:thepath];
}

- (BOOL)saveWithPath:(NSString *)path {
    if (_document == nil) { return NO; }
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL fileExist = [fm fileExistsAtPath:path];
    if (fileExist) {
        [fm removeItemAtPath:path error:nil];
    } else {
        if (![fm createFileAtPath:path contents:nil attributes:nil]){
            NSLog(@"创建文件失败 %@", path);
            return NO;
        }
    }
    
    NSData *XMLData = [_document XMLDataWithOptions:NSXMLNodePrettyPrint];
    if (![XMLData writeToFile:path atomically:YES]) {
        NSLog(@"Could not write document out...");
        return NO;
    }
    return YES;
}

- (void)save {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* thepath = [paths lastObject];
    thepath = [thepath stringByAppendingPathComponent:@"jcib.storyboard"];
    NSLog(@"保存路径：%@", thepath);
    NSData *XMLData = [_document XMLDataWithOptions:NSXMLNodePrettyPrint];
    if (![XMLData writeToFile:thepath atomically:YES]) {
        NSLog(@"Could not write document out...");
    }
}

- (NSXMLElement *)elementWithXML:(NSString *)xml {
    NSData *xmlData = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithData:xmlData options:NSXMLNodePreserveWhitespace error:nil];
    return xmlDocument.rootElement;
}

- (NSString *)uid {
    static NSString *source = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        source = @"0123456789ABCDEFGHIJKLMNOPQRSTUWVXZYabcdefghijklmnopqrstuwvxzy";
    });
    
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < 10; i++) {
        if (i == 3 || i == 6) { [result appendString:@"-"]; }
        else {
            unsigned index = rand() % [source length];
            NSString *one = [source substringWithRange:NSMakeRange(index, 1)];
            [result appendString:one];
        }
    }
    return result.mutableCopy;;
}


- (void)addSceneWithViewController:(JCViewControllerModel *)model {
    if (_scenesElement.children.count == 0) {
        _initialViewController = model.vid;
        _initialNode.stringValue = model.vid;
    }
    NSInteger row = _scenesElement.children.count / 5;
    NSInteger index = _scenesElement.children.count % 5;
    
    NSXMLElement *scene = [self elementWithXML:[NSString stringWithFormat:@"<scene sceneID=\"%@\"></scene>", [self uid]]];
    
    NSXMLElement *objects = [NSXMLElement elementWithName:@"objects"];
    NSXMLElement *placeholder = [self elementWithXML:[NSString stringWithFormat:@"<placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"%@\" sceneMemberID=\"firstResponder\"/>", [self uid]]];
    [objects addChild:model.xml];
    [objects addChild:placeholder];
    
    NSXMLElement *point = [self elementWithXML:[NSString stringWithFormat:@"<point key=\"canvasLocation\" x=\"%f\" y=\"%f\"/>", (100.0 + 600 * index), (100.0 + 1000 * row)]];
    [scene addChild:objects];
    [scene addChild:point];
    [_scenesElement addChild:scene];
    [_viewControllers addObject:model];
}

@end
