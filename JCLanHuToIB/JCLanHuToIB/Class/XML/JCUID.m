//
//  JCUID.m
//  JCLanHuToIB
//
//  Created by TR-L on 2019/9/4.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCUID.h"

@implementation JCUID {
    NSMutableArray *_allUIDs;
}

static JCUID * _instance;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[JCUID alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _allUIDs = [NSMutableArray new];
    }
    return self;
}

- (NSString *)creatUid {
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
    
    if ([_allUIDs containsObject:result]) {
        NSString *uid = [self creatUid];
        [_allUIDs addObject:uid];
        return uid;
    }
    [_allUIDs addObject:result.mutableCopy];
    return result.mutableCopy;
}

- (void)addUid:(NSString *)uid {
    NSLog(@"%@", uid);
    if (![_allUIDs containsObject:uid]) {
        [_allUIDs addObject:uid];
    }
}

@end
