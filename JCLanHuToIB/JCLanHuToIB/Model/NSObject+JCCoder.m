//
//  NSObject+JCCoder.m
//  JCUIKit
//
//  Created by Chuan on 2019/1/29.
//  Copyright © 2019 Chuan. All rights reserved.
//

#import "NSObject+JCCoder.h"
#import "NSObject+JCModel.h"
#import <objc/message.h>

/**
 在JCUI_EncodeTypeCType和JCUI_MessageSendCType，本想用objc_msgSend_stret来收发消息的，
 但对C语言了解不够深入，没法实现！所以这里用NSInvocation来进行消息转发。
 Class、SEL类型的value，这里是转换成字符串的；
 C语言类型的value以及Block，用NSData来进行存储的。
 */

/** 解档类型为id的属性 */
id JCUI_DecodeTypeObject(id value, Class cls) {
    if (![value isKindOfClass:[NSData class]]) { return value; }
    
    id obj = nil;
    if ([cls conformsToProtocol:@protocol(NSCoding)]) {
        if (@available(iOS 12.0, *)) {}
        else {
            obj = [NSKeyedUnarchiver unarchiveObjectWithData:value];
        }
    } else {
        obj = [cls jcui_modelWithJSON:value];
    }
    
    return obj;
}

/** 将id类型的属性转换为NSData(归档) */
id JCUI_EncodeTypeObject(id value) {
    if (!value) { return nil; }
    
    NSData *data = nil;
    if ([value conformsToProtocol:@protocol(NSCoding)]) {
        if (@available(iOS 12.0, *)) { return value; }
        data = [NSKeyedArchiver archivedDataWithRootObject:value];
    } else {
        data = [value jcui_modelToJSONData];
    }
    
    return data;
}


/** 将Class类型的属性转换为字符串值 */
NSString *JCUI_EncodeTypeClass(id self, SEL getter) {
    Class cls = ((Class (*)(id, SEL)) objc_msgSend)(self, getter);
    return NSStringFromClass(cls);
}

/** 将SEL类型的属性转换为字符串值 */
NSString *JCUI_EncodeTypeSEL(id self, SEL getter) {
    SEL sel = ((SEL (*)(id, SEL)) objc_msgSend)(self, getter);
    return NSStringFromSelector(sel);
}

/** 将C语言的类型属性转换为NSData */
NSData *JCUI_EncodeTypeCType(id self, SEL getter) {
    NSMethodSignature *sig = [self methodSignatureForSelector:getter];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:getter];
    [inv invoke];
    
    NSUInteger length = [sig methodReturnLength];
    char *buf = calloc(1, length);
    if (!buf) return nil;
    [inv getReturnValue:buf];
    NSData *data = [[NSData alloc] initWithBytes:buf length:length];
    free(buf);
    
    return data;
}

/** 消息发送，参数为Class类型 */
void JCUI_MessageSendClassType(id self, SEL setter, Class cls) {
    ((void (*)(id, SEL, Class))(void *) objc_msgSend)(self, setter, cls);
}

/** 消息发送，参数为SEL类型 */
void JCUI_MessageSendSELType(id self, SEL setter, SEL sel) {
    ((void (*)(id, SEL, SEL))(void *) objc_msgSend)(self, setter, sel);
}

/** 消息发送，处理C语言的类型 */
void JCUI_MessageSendCType(id self, SEL setter, NSData *data) {
    NSMethodSignature *sig = [self methodSignatureForSelector:setter];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:self];
    [inv setSelector:setter];

    NSUInteger size = 0;
    char *type = (char *)[sig getArgumentTypeAtIndex:2];
    NSGetSizeAndAlignment(type, &size, NULL);
    
    char *buf = calloc(1, size);
    if (!buf) { return; }

    [data getBytes:buf length:size];
    [inv setArgument:buf atIndex:2];
    [inv invoke];
    free(buf);
}


void JCUI_ObjectAllPropertyInfo(id self, void (^propertyBlock)(JCClassPropertyInfo *info)) {
    if (!propertyBlock) { return; }
    
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    if (propertyCount) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            propertyBlock([[JCClassPropertyInfo alloc] initWithProperty:propertys[i]]);
        }
        free(propertys);
    }
}

@implementation NSObject (JCCoder)

- (void)jcui_coder:(NSCoder *)coder decodeObjectForPropertyInfo:(JCClassPropertyInfo *)info {
    if (![coder containsValueForKey:info.name]) { return; }
    
    if (info.isCNumber) {
        [self setValue:[coder decodeObjectForKey:info.name] forKey:info.name];
        
    } else if (info.nsType) {
        id value = nil;
        
        if ([info.cls conformsToProtocol:@protocol(NSCoding)]) {
            value = [coder decodeObjectOfClass:info.cls forKey:info.name];
        } else {
            value = [coder decodeObjectForKey:info.name];
        }
        [self setValue:value forKey:info.name];
    } else {
        switch (info.type & JCEncodingTypeMask) {
            case JCEncodingTypeObject   : {
                id value = nil;
                if ([info.cls conformsToProtocol:@protocol(NSCoding)]) {
                    value = [coder decodeObjectOfClass:info.cls forKey:info.name];
                } else {
                    value = [coder decodeObjectForKey:info.name];
                }
                [self setValue:JCUI_DecodeTypeObject(value, info.cls) forKey:info.name];
            }  break;
            case JCEncodingTypeClass    : JCUI_MessageSendClassType(self, info.setter, NSClassFromString([coder decodeObjectForKey:info.name]));  break;
            case JCEncodingTypeSEL      : JCUI_MessageSendSELType(self, info.setter, NSSelectorFromString([coder decodeObjectForKey:info.name])); break;
            case JCEncodingTypeStruct   :
            case JCEncodingTypeUnion    :
            case JCEncodingTypeCArray   :
            case JCEncodingTypePointer  :
            case JCEncodingTypeCString  :
            case JCEncodingTypeBlock    : JCUI_MessageSendCType(self, info.setter, [coder decodeObjectForKey:info.name]);                         break;
            default: break;
        }
    }
}

- (void)jcui_coder:(NSCoder *)coder encodeObjectForPropertyInfo:(JCClassPropertyInfo *)info {
    if (info.nsType || info.isCNumber) { // NS对象或是Number对象
        [coder encodeObject:[self valueForKey:info.name] forKey:info.name];
    } else {
        switch (info.type & JCEncodingTypeMask) {
            case JCEncodingTypeObject   : [coder encodeObject:JCUI_EncodeTypeObject([self valueForKey:info.name]) forKey:info.name]; break;
            case JCEncodingTypeClass    : [coder encodeObject:JCUI_EncodeTypeClass(self, info.getter) forKey:info.name];             break;
            case JCEncodingTypeSEL      : [coder encodeObject:JCUI_EncodeTypeSEL(self, info.getter) forKey:info.name];               break;
            case JCEncodingTypeStruct   :
            case JCEncodingTypeUnion    :
            case JCEncodingTypeCArray   :
            case JCEncodingTypePointer  :
            case JCEncodingTypeCString  :
            case JCEncodingTypeBlock    : [coder encodeObject:JCUI_EncodeTypeCType(self, info.getter) forKey:info.name];             break;
            default: break;
        }
    }
}

- (BOOL)archiveToFile:(NSString *)path {
    if (@available(iOS 11, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:nil];
        return [data writeToFile:path atomically:YES];
    } else {
        return [NSKeyedArchiver archiveRootObject:self toFile:path];
    }
}

+ (id)unarchiveForFile:(NSString *)path {
    if (@available(iOS 11, *)) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (!data) { return nil; }
        
        return [NSKeyedUnarchiver unarchivedObjectOfClass:[self class] fromData:data error:nil];
    } else {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
}

@end
