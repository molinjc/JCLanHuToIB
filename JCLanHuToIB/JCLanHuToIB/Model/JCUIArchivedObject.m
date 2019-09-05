//
//  JCUIArchivedObject.m
//  JCUIKit
//
//  Created by Chuan on 2019/2/21.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "JCUIArchivedObject.h"
#import "NSObject+JCCoder.h"
#import <objc/message.h>

@implementation JCUIArchivedObject

- (instancetype)init {
    if (self = [super init]) {}
    return self;
}

+ (instancetype)unarchivedWithFile:(NSString *)path {
    if (!path) { return nil; }
    if (@available(iOS 12.0, *)) {
        NSData *fromData = [NSData dataWithContentsOfFile:path];
        if (!fromData) { return nil; }
        NSError *error = nil;
        id obj = [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:fromData error:nil];
        if (error) { NSLog(@"%@ unarchived error: %@", self, error); }
        return obj;
    } else {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
}

+ (instancetype)unarchivedNamed:(NSString *)name {
    if (!name) { return nil; }
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:name];
    return [self unarchivedWithFile:path];
}

+ (instancetype)unarchived {
    return [self unarchivedNamed:NSStringFromClass(self)];
}

- (BOOL)archivedWithFile:(NSString *)path {
    if (@available(iOS 12.0, *)) {
        NSError *error = nil;
        NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:&error];
        if (error) { NSLog(@"%@ archived error: %@", self, error); }
        if (!archiverData) { return NO; }
        return [archiverData writeToFile:path atomically:YES];
    } else {
        return [NSKeyedArchiver archiveRootObject:self toFile:path];
    }
}

- (BOOL)archivedNamed:(NSString *)name {
    return [self archivedWithFile:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:name]];
}

- (BOOL)archived {
    return [self archivedNamed:NSStringFromClass([self class])];
}

- (void)clearAllValue {
    __weak typeof(self) weakself = self;
    JCUI_ObjectAllPropertyInfo(self, ^(JCClassPropertyInfo *info) {
        ((void (*)(id, SEL, void *))(void *) objc_msgSend)(weakself, info.setter, NULL);
    });
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        @synchronized (self) {
            __weak typeof(self) weakself = self;
            JCUI_ObjectAllPropertyInfo(self, ^(JCClassPropertyInfo *info) {
                @try {
                    [weakself jcui_coder:decoder decodeObjectForPropertyInfo:info];
                } @catch (NSException *exception) {
                    printf("\n[JCUIKit] <%s %p> -initWithCoder:\n%s", NSStringFromClass([self class]).UTF8String, self, exception.description.UTF8String);
                }
            });
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    @synchronized (self) {
        __weak typeof(self) weakself = self;
        JCUI_ObjectAllPropertyInfo(self, ^(JCClassPropertyInfo *info) {
            @try {
                [weakself jcui_coder:aCoder encodeObjectForPropertyInfo:info];
            } @catch (NSException *exception) {
                printf("\n[JCUIKit] <%s %p> -encodeWithCoder:\n%s", NSStringFromClass([self class]).UTF8String, self, exception.description.UTF8String);
            }
        });
    }
}

/** 支持加密编码 */
+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
