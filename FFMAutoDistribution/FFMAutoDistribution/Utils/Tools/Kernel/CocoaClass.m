//
//  CocoaClass.m
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

#import "CocoaClass.h"

#pragma mark-  functions

CCInstanceEncodingType CCGetInstanceEncodingType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return CCInstanceEncodingType_Unknown;
    size_t len = strlen(type);
    if (len == 0) return CCInstanceEncodingType_Unknown;
    
    CCInstanceEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= CCInstanceEncodingType_QualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= CCInstanceEncodingType_QualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= CCInstanceEncodingType_QualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= CCInstanceEncodingType_QualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= CCInstanceEncodingType_QualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= CCInstanceEncodingType_QualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= CCInstanceEncodingType_QualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }
    
    len = strlen(type);
    if (len == 0) return CCInstanceEncodingType_Unknown | qualifier;
    
    switch (*type) {
        case 'v': return CCInstanceEncodingType_Void | qualifier;
        case 'B': return CCInstanceEncodingType_Bool | qualifier;
        case 'c': return CCInstanceEncodingType_Int8 | qualifier;
        case 'C': return CCInstanceEncodingType_UInt8 | qualifier;
        case 's': return CCInstanceEncodingType_Int16 | qualifier;
        case 'S': return CCInstanceEncodingType_UInt16 | qualifier;
        case 'i': return CCInstanceEncodingType_Int32 | qualifier;
        case 'I': return CCInstanceEncodingType_UInt32 | qualifier;
        case 'l': return CCInstanceEncodingType_Int32 | qualifier;
        case 'L': return CCInstanceEncodingType_UInt32 | qualifier;
        case 'q': return CCInstanceEncodingType_Int64 | qualifier;
        case 'Q': return CCInstanceEncodingType_UInt64 | qualifier;
        case 'f': return CCInstanceEncodingType_Float | qualifier;
        case 'd': return CCInstanceEncodingType_Double | qualifier;
        case 'D': return CCInstanceEncodingType_LongDouble | qualifier;
        case '#': return CCInstanceEncodingType_Class | qualifier;
        case ':': return CCInstanceEncodingType_SEL | qualifier;
        case '*': return CCInstanceEncodingType_CString | qualifier;
        case '^': return CCInstanceEncodingType_Pointer | qualifier;
        case '[': return CCInstanceEncodingType_CArray | qualifier;
        case '(': return CCInstanceEncodingType_Union | qualifier;
        case '{': return CCInstanceEncodingType_Struct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return CCInstanceEncodingType_Block | qualifier;
            else
                return CCInstanceEncodingType_Object | qualifier;
        }
        default: return CCInstanceEncodingType_Unknown | qualifier;
    }
}

CCClassEncodingType CCGetClassEncodingType (Class cls) {
    if (!cls) return CCClassEncodingType_Unknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return CCClassEncodingType_NSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return CCClassEncodingType_NSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return CCClassEncodingType_NSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return CCClassEncodingType_NSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return CCClassEncodingType_NSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return CCClassEncodingType_NSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return CCClassEncodingType_NSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return CCClassEncodingType_NSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return CCClassEncodingType_NSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return CCClassEncodingType_NSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return CCClassEncodingType_NSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return CCClassEncodingType_NSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return CCClassEncodingType_NSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return CCClassEncodingType_NSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return CCClassEncodingType_NSSet;
    return CCClassEncodingType_Unknown;
}

#pragma mark-  CocoaClass

@implementation CocoaClass {
    BOOL _needUpdate;
}

@synthesize propertyInfos = _propertyInfos;
@synthesize methodInfos = _methodInfos;
@synthesize ivarInfos = _ivarInfos;

+ (instancetype)resolve:(Class)cls {

    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    CocoaClass *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    [info updateIfNeed];
    
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[CocoaClass alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

+ (instancetype)resolveWithClassName:(NSString *)clsName {
    Class cls = NSClassFromString(clsName);
    return [self resolve:cls];
}

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;

    self = [super init];
    if (self) {
        _cls = cls;
        _superCls = class_getSuperclass(cls);
        _isMeta = class_isMetaClass(cls);
        _name = NSStringFromClass(cls);
        _superClassInfo = [self.class resolve:_superCls];
    }
    return self;
}

#pragma mark-  update class info

- (void)__update {
    _propertyInfos = nil;
    _ivarInfos = nil;
    _methodInfos = nil;

    _needUpdate = NO;
}

- (void)setNeedUpdate {
    _needUpdate = YES;
}

- (BOOL)needUpdate {
    return _needUpdate;
}

- (void)updateIfNeed {
    if (self && self->_needUpdate) {
        [self __update];
    }
}

#pragma mark-  property

- (void)copyPropertyList:(void(^)(objc_property_t property))block {
    NSParameterAssert(block);
    u_int count;
    objc_property_t *properties = class_copyPropertyList(_cls, &count);
    if (properties) {
        for (u_int i = 0; i < count; i++) {
            block(properties[i]);
        }
    }
    
    free(properties);
}

#pragma mark-  methods

+ (BOOL)swizzleMethodForClass:(Class)cls oldSel:(SEL)oldSel withMethod:(SEL)newSel {
    Method oldMethod = class_getInstanceMethod(cls, oldSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    
    BOOL didAddMethod = class_addMethod(cls,
                                        oldSel,
                                        method_getImplementation(newMethod),
                                        method_getTypeEncoding(newMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            newSel,
                            method_getImplementation(oldMethod),
                            method_getTypeEncoding(oldMethod));
    }
    else {
        method_exchangeImplementations(oldMethod, newMethod);
    }
    return didAddMethod;
}

- (BOOL)swizzleMethod:(SEL)oldSel withMethod:(SEL)newSel {
    return [self.class swizzleMethodForClass:_cls oldSel:oldSel withMethod:newSel];
}

- (void)copyMethodList:(void(^)(Method method))block {
    NSParameterAssert(block);
    u_int count;
    Method *methods = class_copyMethodList(_cls, &count);
    if (methods) {
        for (u_int i = 0; i < count; i++) {
            block(methods[i]);
        }
    }

    free(methods);
}

#pragma mark-  ivar

- (void)copyIvarList:(void(^)(Ivar ivar))block {
    NSParameterAssert(block);
    u_int count;
    Ivar *ivars = class_copyIvarList(_cls, &count);
    if (ivars) {
        for (u_int i = 0; i < count; i++) {
            block(ivars[i]);
        }
    }
    
    free(ivars);
}

#pragma mark-  info getter

- (NSDictionary<NSString *,CocoaProperty *> *)propertyInfos {
    if (_propertyInfos) return _propertyInfos;
    
    NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
    _propertyInfos = propertyInfos;
    [self copyPropertyList:^(objc_property_t  _Nonnull property) {
        CocoaProperty *info = [CocoaProperty resolve:property];
        if (info.name) propertyInfos[info.name] = info;
    }];

    return _propertyInfos;
}

- (NSDictionary<NSString *,CocoaMethod *> *)methodInfos {
    if (_methodInfos) return _methodInfos;
    
    NSMutableDictionary *methodInfos = [NSMutableDictionary new];
    _methodInfos = methodInfos;
    [self copyMethodList:^(Method  _Nonnull method) {
        CocoaMethod *info = [CocoaMethod resolve:method];
        if (info.name) methodInfos[info.name] = info;
    }];
    return _methodInfos;
}

- (NSDictionary<NSString *,CocoaIvar *> *)ivarInfos {
    if (_ivarInfos) return _ivarInfos;
    
    NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
    _ivarInfos = ivarInfos;
    [self copyIvarList:^(Ivar  _Nonnull ivar) {
        CocoaIvar *info = [CocoaIvar resolve:ivar];
        if (info.name) ivarInfos[info.name] = info;
    }];
    return _ivarInfos;
}

@end


#pragma mark-  CocoaProperty

@implementation CocoaProperty

+ (instancetype)resolve:(objc_property_t)property {
    return [[self alloc] initWithProperty:property];
}

- (instancetype)initWithProperty:(objc_property_t)property {
    NSParameterAssert(property);
    self = [self init];
    
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    CCInstanceEncodingType type = 0;
    u_int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        objc_property_attribute_t attr = attrs[i];
        const char *attrValue = attr.value;
        switch (attr.name[0]) {
            case 'T': { // Type encoding
                if (attrValue) {
                    _typeEncoding = [NSString stringWithUTF8String:attrValue];
                    type = CCGetInstanceEncodingType(attrValue);
                    if ((type & CCInstanceEncodingType_Mask) == CCInstanceEncodingType_Object) {
                        size_t len = strlen(attrValue);
                        if (len > 3) {
                            char clsName[len - 2];
                            clsName[len - 3] = '\0';
                            memcpy(clsName, attrValue + 2, len - 3);
                            _cls = objc_getClass(clsName);
                        }
                    }
                }
            } break;
            case 'V': { // Instance variable
                if (attrValue) {
                    _ivarName = [NSString stringWithUTF8String:attrValue];
                }
            } break;
            case 'R': {
                type |= CCInstanceEncodingType_PropertyReadonly;
            } break;
            case 'C': {
                type |= CCInstanceEncodingType_PropertyCopy;
            } break;
            case '&': {
                type |= CCInstanceEncodingType_PropertyRetain;
            } break;
            case 'N': {
                type |= CCInstanceEncodingType_PropertyNonatomic;
            } break;
            case 'D': {
                type |= CCInstanceEncodingType_PropertyDynamic;
            } break;
            case 'W': {
                type |= CCInstanceEncodingType_PropertyWeak;
            } break;
            case 'G': {
                type |= CCInstanceEncodingType_PropertyCustomGetter;
                if (attrValue) {
                    _getter = sel_registerName(attrValue);
                }
            } break;
            case 'S': {
                type |= CCInstanceEncodingType_PropertyCustomSetter;
                if (attrValue) {
                    _setter = sel_registerName(attrValue);
                }
            } // break; commented for code coverage in next line
            default: break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    
    if (!_getter) {
        _getter = sel_registerName(name);
    }
    if (!_setter) {
        char *setter = nil;
        asprintf(&setter, "set%c%s:", toupper(*name), name + 1);
        _setter = sel_registerName(setter);
        free(setter);
    }
    
    return self;
}

@end

#pragma mark-  CocoaIvar

@implementation CocoaIvar

+ (instancetype)resolve:(Ivar)ivar {
    return [[self alloc] initWithIvar:ivar];
}

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar) return nil;
    self = [super init];
    _ivar = ivar;
    const char *name = ivar_getName(ivar);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    _offset = ivar_getOffset(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        _type = CCGetInstanceEncodingType(typeEncoding);
    }
    return self;
}

@end

@implementation CocoaMethod

+ (instancetype)resolve:(Method)method {
    return [[self alloc] initWithMethod:method];
}

- (instancetype)initWithMethod:(Method)method {
    if (!method) return nil;
    self = [super init];
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}

@end


