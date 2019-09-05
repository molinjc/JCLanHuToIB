//
//  ViewController.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/2.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "ViewController.h"
#import "JCCocoaPython.h"
#import "JCNodeModel.h"
#import "JCUIModelKit.h"

#import "JCStoryboardXML.h"

@interface ViewController ()
@property (weak) IBOutlet NSPopUpButton *haveControllerButton;
@property (weak) IBOutlet NSComboBox *newcontrollerBox;
@property (weak) IBOutlet NSComboBox *onewViewBox;
@property (weak) IBOutlet NSPopUpButton *haveViewButton;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *viewLabelView;

@property (nonatomic, strong) JCStoryboardXML *sbXML;
@property (nonatomic, strong) JCViewControllerXML *viewControllerXML;
@property (nonatomic, strong) JCViewXML *viewXML;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://lanhuapp.com/"]];
    [self.webView loadRequest:request];
    [self creartSBModel];
    [self updatecontrollerBox];
    if (_viewControllerXML) { [self updateViewBox]; }
}

- (void)creartSBModel {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* thepath = [paths lastObject];
    thepath = [thepath stringByAppendingPathComponent:@"jcib.storyboard"];

    _sbXML = [[JCStoryboardXML alloc] initWithPaht:thepath];

//    if ([[NSFileManager defaultManager] fileExistsAtPath:thepath]) {
//        _sbModel = [JCStoryboardModel loadLocationStoryboard];
//    } else {
//        _sbModel = [JCStoryboardModel createStoryboard];
//    }
}

- (void)updatecontrollerBox {
    [self.haveControllerButton removeAllItems];
    NSMutableArray *array = @[].mutableCopy;
    for (JCViewControllerXML *model in _sbXML.viewControllers) {
        NSString *titles = model.title;
        if (!titles.length) { titles = model.uid; }
        if (![array containsObject:titles]) {
            [array addObject:titles];
        }
    }
    _viewControllerXML = _sbXML.viewControllers.firstObject;
    [self.haveControllerButton addItemsWithTitles:array];
}

- (void)updateViewBox {
    [self.haveViewButton removeAllItems];
    NSMutableArray *array = @[].mutableCopy;
    for (JCViewXML *model in _viewControllerXML.allSubviews) {
        NSString *titles = [NSString stringWithFormat:@"%@-%@", model.xml.name, model.uid];
        if (![array containsObject:titles]) { [array addObject:titles]; }
//        if (model.subviews.count) {
//            [array addObjectsFromArray:[self subviewsFromModel:model]];
//        }
    }
    [self.haveViewButton addItemsWithTitles:array];
}

#pragma mark - WKWebView WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - WKWebView JCWKNavigationDelegate

- (IBAction)classNameAction:(NSComboBox *)sender {
    NSLog(@"indexOfSelectedItem: %@", sender.stringValue);
}

- (IBAction)createViewsAction:(NSButton *)sender {
    NSString *doc = @"document.body.outerHTML";
    [self.webView evaluateJavaScript:doc completionHandler:^(id htmlStr, NSError * error) {
        if (error) { NSLog(@"JSError:%@",error); }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"h" ofType:@"py"];
        JCCocoaPython *python = [[JCCocoaPython alloc] initWithPath:path args:@[htmlStr]];
        python.completed = ^(NSString *results, NSString *errors) {
            NSLog(@"results: %@, errors: %@", results, errors);
            JCNodeModel *model = [JCNodeModel jcui_modelWithJSON:results];
            [self handelWithModel:model];
        };
        [python runSync];
    }];
}

- (void)handelWithModel:(JCNodeModel *)model {
    NSString *cls = self.onewViewBox.stringValue;
    
    if ([cls isEqualToString:@"view"]) {
        JCViewXML *vm = [[JCViewXML alloc] initWithXML:nil];
        [vm setupDatas:model];
        _viewXML = vm;
    } else if ([cls isEqualToString:@"label"]) {
        JCLabeLXML *lm = [[JCLabeLXML alloc] initWithXML:nil];
        [lm setupDatas:model];
        _viewXML = lm;
    }
    
    self.viewLabelView.stringValue = [NSString stringWithFormat:@"创建成功%@", _viewXML.uid];
}

#pragma mark - Target Action

- (IBAction)backAction:(NSButton *)sender {
}

- (IBAction)forwardAction:(id)sender {
}

- (IBAction)onewControllerAction:(NSButton *)sender {
    NSString *cls = self.newcontrollerBox.stringValue;
    NSString *title = self.titleField.stringValue;
    
    if ([cls isEqualToString:@"ViewController"]) {
        JCViewControllerXML *vcm = [[JCViewControllerXML alloc] initWithXML:nil];
        if (title.length) { vcm.title = title; }
        [_sbXML addViewControllers:vcm];
        self.viewControllerXML = vcm;
        [self updatecontrollerBox];
    }
}

- (IBAction)onewViewAction:(NSButton *)sender {
//    NSString *doc = @"document.body.outerHTML";
    NSString *doc = @"document.getElementsByClassName(\"annotation_container lanhu_scrollbar flag-ps\")[0].outerHTML";
    [self.webView evaluateJavaScript:doc completionHandler:^(id htmlStr, NSError * error) {
        if (error) { NSLog(@"JSError:%@",error); }
        [self handleHtml: htmlStr newView:YES];
    }];
}

- (void)handleHtml:(NSString *)html newView:(BOOL)isnew {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"h" ofType:@"py"];
    JCCocoaPython *python = [[JCCocoaPython alloc] initWithPath:path args:@[html]];
    python.completed = ^(NSString *results, NSString *errors) {
        JCNodeModel *model = [JCNodeModel jcui_modelWithJSON:results];
        if (isnew) { [self handelWithModel:model]; }
        else { [self.viewXML setupDatas:model]; }
    };
    [python runSync];
}

- (IBAction)addToControllerAction:(NSButton *)sender {
    [_viewControllerXML addSubviews:_viewXML];
    [self updateViewBox];
}

- (IBAction)addToViewAction:(NSButton *)sender {
    NSString *v = self.haveViewButton.title;
    
    JCViewXML *model = [self seachViewModel:_viewControllerXML.allSubviews withTitle:v];
    if (!model) {
        [_viewControllerXML addSubviews:_viewXML];
    } else {
        [model addSubviews:_viewXML];
    }
    [self updateViewBox];
}

- (JCViewXML *)seachViewModel:(NSArray *)subviews withTitle:(NSString *)title {
    for (JCViewXML *model in subviews) {
        NSString *t = [NSString stringWithFormat:@"%@-%@", model.xml.name, model.uid];
        if ([t isEqualToString:title]) { return model; }
        else if (model.subviews.count) {
            JCViewXML *vm = [self seachViewModel:model.subviews withTitle:title];
            if (vm) { return vm; }
        }
    }
    return nil;
}

- (IBAction)saveAction:(id)sender {
    [_sbXML save];
}

- (IBAction)updateViewAction:(NSButton *)sender {
    NSString *doc = @"document.getElementsByClassName(\"annotation_container lanhu_scrollbar flag-ps\")[0].outerHTML";
    [self.webView evaluateJavaScript:doc completionHandler:^(id htmlStr, NSError * error) {
        if (error) { NSLog(@"JSError:%@",error); }
        [self handleHtml: htmlStr newView:NO];
    }];
}

@end