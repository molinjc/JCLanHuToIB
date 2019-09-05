//
//  JCCocoaPython.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/2.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCCocoaPython.h"

@interface JCCocoaPython ()
@property (nonatomic, strong) NSTask *task;
@property (nonatomic, strong) NSPipe *outPip;
@property (nonatomic, strong) NSPipe *errorPipe;
@end

@implementation JCCocoaPython

- (instancetype)init {
    if (self = [super init]) {
        _task = [[NSTask alloc] init];
        _outPip = [NSPipe pipe];
        _errorPipe = [NSPipe pipe];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)scrPath args:(NSArray<NSString *> *)arge {
    self = [self init];
    _task.launchPath = @"/usr/local/bin/python3";
    NSMutableArray *allArgs = arge.mutableCopy;
    [allArgs insertObject:scrPath atIndex:0];
    _task.arguments = allArgs;
    _task.standardInput = [NSPipe pipe];
    _task.standardOutput = _outPip;
    _task.standardError = _errorPipe;
    return self;
}

- (NSString *)fetchResult:(NSPipe *)pipe {
    NSData *data = [pipe.fileHandleForReading readDataToEndOfFile];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)runSync {
    [_task launch];
    [_task waitUntilExit];
    
    NSString *aError = [self fetchResult:_errorPipe];
    NSLog(@"error: %@", aError);
    NSString *result = [self fetchResult:_outPip];
    if (_completed) { _completed(result, aError); }
}

@end
