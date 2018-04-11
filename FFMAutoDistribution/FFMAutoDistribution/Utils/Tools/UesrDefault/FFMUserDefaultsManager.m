//
//  FFMUserDefaultsManager.m
//  FFMAutoDistribution
//
//  Created by RangerChiong on 2017/4/25.
//  Copyright © 2017年 Ranger. All rights reserved.
//

#import "FFMUserDefaultsManager.h"

#import "CocoaClass.h"

@interface FFMUserDefaultsManager () {
    NSUserDefaults  *_userDefault;
    CocoaClass *_classInfo;
    NSDictionary<NSString *, CocoaMethod *> *_originMethods;
}

@end

@implementation FFMUserDefaultsManager

+ (instancetype)shareManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _userDefault = [NSUserDefaults standardUserDefaults];
        _originMethods = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark-   public methods

- (void)registerClass:(Class)aClass {
    _classInfo = [CocoaClass resolve:aClass];
    // 备份原方法
    _originMethods = [NSDictionary dictionaryWithDictionary:_classInfo.methodInfos];

    // 在原方法中插入userDefault读写代码
    [self __injectCodeForSetterAndGetter];
}

- (void)unregisterClass {
    [_classInfo setNeedUpdate];
    [_classInfo updateIfNeed];
    // 还原方法备份
    [_classInfo.methodInfos enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CocoaMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        class_replaceMethod(_classInfo.cls, obj.sel, _originMethods[key].imp, NULL);
    }];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [_userDefault setObject:object forKey:key];
    [_userDefault synchronize];
}

- (id)objectForKey:(NSString *)key {
    return [_userDefault objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [_userDefault removeObjectForKey:key];
    [_userDefault synchronize];
}

- (void)removeObjectsForKeys:(NSArray<NSString *> *)keys {
    for (NSString *key in keys) {
        [_userDefault removeObjectForKey:key];
    }
    [_userDefault synchronize];
}

- (void)removeAllData {
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    [_userDefault removePersistentDomainForName:bundle];
}

#pragma mark-  private methods

#define Make_Setter_Method(type, setStatement)  \
void (*setter)(__unsafe_unretained id, SEL, type) = (void(*)(__unsafe_unretained id, SEL, type))method_getImplementation(originSetterMethod);\
id setter_imp = ^(__unsafe_unretained id this, type param) {\
[_userDefault setStatement:param forKey:key];\
[_userDefault synchronize];\
setter(this, obj.setter, param);\
};\
method_setImplementation(originSetterMethod, imp_implementationWithBlock(setter_imp));\

#define Make_Getter_Method(getStatement)  \
id getter_imp = ^(__unsafe_unretained id this) {\
return [_userDefault getStatement:key];\
};\
method_setImplementation(originGetterMethod, imp_implementationWithBlock(getter_imp));

#define OverrideSetterGetterMethod(type, setStatement, getStatement)   \
Make_Setter_Method(type, setStatement);    \
Make_Getter_Method(getStatement)

- (void)__injectCodeForSetterAndGetter {
    [_classInfo.propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString *key, CocoaProperty *obj, BOOL *stop) {
        Method originSetterMethod = class_getInstanceMethod(_classInfo.cls, obj.setter);
        Method originGetterMethod = class_getInstanceMethod(_classInfo.cls, obj.getter);

        const char *attributes = property_copyAttributeValue(obj.property, "T");
        switch (attributes[0]) {
            case 's':  // short
            case 'i':  // int
            case 'l':  // long
            case 'q':  // long long
            case 'C':  // unsigned char
            case 'S':  // unsigned short
            case 'I':  // unsigned int
            case 'L':  // unsigned long
            case 'Q':  // unsigned long long
            {
                OverrideSetterGetterMethod(NSInteger, setInteger, integerForKey);
                break;
            }
            case 'B':  // BOOL
            case 'c':  // char
            {
                
                OverrideSetterGetterMethod(BOOL, setBool, boolForKey);
                break;
            }
                
            case 'f':  // float
            {
                OverrideSetterGetterMethod(float, setFloat, floatForKey);
                break;
            }
                
            case 'd':  // double
            {
                OverrideSetterGetterMethod(double, setDouble, doubleForKey);
                break;
            }
                
            case '@':  // object
            {
                OverrideSetterGetterMethod(id, setObject, objectForKey);
                break;
            }
            default: break;
        }
    }];
}

@end
