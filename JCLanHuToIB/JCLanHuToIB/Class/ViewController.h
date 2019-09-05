//
//  ViewController.h
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/2.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ViewController : NSViewController <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, weak) IBOutlet WKWebView *webView;

@end

