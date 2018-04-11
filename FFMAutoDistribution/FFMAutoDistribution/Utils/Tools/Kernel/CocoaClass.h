//
//  CocoaClass.h
//  Zeughaus
//
//  Created by 常小哲 on 16/4/12.
//  Copyright © 2016年 常小哲. All rights reserved.
//

@import Foundation;
@import ObjectiveC.runtime;

@class CocoaProperty;
@class CocoaMethod;
@class CocoaIvar;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CCInstanceEncodingType) {
    CCInstanceEncodingType_Mask       = 0xFF, ///< mask of type value
    CCInstanceEncodingType_Unknown    = 0, ///< unknown
    CCInstanceEncodingType_Void       = 1, ///< void
    CCInstanceEncodingType_Bool       = 2, ///< bool
    CCInstanceEncodingType_Int8       = 3, ///< char / BOOL
    CCInstanceEncodingType_UInt8      = 4, ///< unsigned char
    CCInstanceEncodingType_Int16      = 5, ///< short
    CCInstanceEncodingType_UInt16     = 6, ///< unsigned short
    CCInstanceEncodingType_Int32      = 7, ///< int
    CCInstanceEncodingType_UInt32     = 8, ///< unsigned int
    CCInstanceEncodingType_Int64      = 9, ///< long long
    CCInstanceEncodingType_UInt64     = 10, ///< unsigned long long
    CCInstanceEncodingType_Float      = 11, ///< float
    CCInstanceEncodingType_Double     = 12, ///< double
    CCInstanceEncodingType_LongDouble = 13, ///< long double
    CCInstanceEncodingType_Object     = 14, ///< id
    CCInstanceEncodingType_Class      = 15, ///< Class
    CCInstanceEncodingType_SEL        = 16, ///< SEL
    CCInstanceEncodingType_Block      = 17, ///< block
    CCInstanceEncodingType_Pointer    = 18, ///< void*
    CCInstanceEncodingType_Struct     = 19, ///< struct
    CCInstanceEncodingType_Union      = 20, ///< union
    CCInstanceEncodingType_CString    = 21, ///< char*
    CCInstanceEncodingType_CArray     = 22, ///< char[10] (for example)
    
    CCInstanceEncodingType_QualifierMask   = 0xFF00,   ///< mask of qualifier
    CCInstanceEncodingType_QualifierConst  = 1 << 8,  ///< const
    CCInstanceEncodingType_QualifierIn     = 1 << 9,  ///< in
    CCInstanceEncodingType_QualifierInout  = 1 << 10, ///< inout
    CCInstanceEncodingType_QualifierOut    = 1 << 11, ///< out
    CCInstanceEncodingType_QualifierBycopy = 1 << 12, ///< bycopy
    CCInstanceEncodingType_QualifierByref  = 1 << 13, ///< byref
    CCInstanceEncodingType_QualifierOneway = 1 << 14, ///< oneway
    
    CCInstanceEncodingType_PropertyMask         = 0xFF0000, ///< mask of property
    CCInstanceEncodingType_PropertyReadonly     = 1 << 16, ///< readonly
    CCInstanceEncodingType_PropertyCopy         = 1 << 17, ///< copy
    CCInstanceEncodingType_PropertyRetain       = 1 << 18, ///< retain
    CCInstanceEncodingType_PropertyNonatomic    = 1 << 19, ///< nonatomic
    CCInstanceEncodingType_PropertyWeak         = 1 << 20, ///< weak
    CCInstanceEncodingType_PropertyCustomGetter = 1 << 21, ///< getter=
    CCInstanceEncodingType_PropertyCustomSetter = 1 << 22, ///< setter=
    CCInstanceEncodingType_PropertyDynamic      = 1 << 23, ///< @dynamic
};

/// Foundation Class Type
typedef NS_ENUM (NSUInteger, CCClassEncodingType) {
    CCClassEncodingType_Unknown = 0,
    CCClassEncodingType_NSString,
    CCClassEncodingType_NSMutableString,
    CCClassEncodingType_NSValue,
    CCClassEncodingType_NSNumber,
    CCClassEncodingType_NSDecimalNumber,
    CCClassEncodingType_NSData,
    CCClassEncodingType_NSMutableData,
    CCClassEncodingType_NSDate,
    CCClassEncodingType_NSURL,
    CCClassEncodingType_NSArray,
    CCClassEncodingType_NSMutableArray,
    CCClassEncodingType_NSDictionary,
    CCClassEncodingType_NSMutableDictionary,
    CCClassEncodingType_NSSet,
    CCClassEncodingType_NSMutableSet,
};

// get instance encoding type
CCInstanceEncodingType CCGetInstanceEncodingType(const char *typeEncoding);

// get class encoding type
CCClassEncodingType CCGetClassEncodingType (Class cls);

@interface CocoaClass : NSObject

@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) CocoaClass *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CocoaProperty *> *propertyInfos;///< properties
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CocoaMethod *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, CocoaIvar *> *ivarInfos; ///< ivars

+ (instancetype)resolve:(Class)cls;
+ (instancetype)resolveWithClassName:(NSString *)clsName;
- (instancetype)initWithClass:(Class)cls;

// update info
- (void)setNeedUpdate;
- (BOOL)needUpdate;
- (void)updateIfNeed;

// property
- (void)copyPropertyList:(void(^)(objc_property_t property))block;

// method
+ (BOOL)swizzleMethodForClass:(Class)cls oldSel:(SEL)oldSel withMethod:(SEL)newSel;
- (BOOL)swizzleMethod:(SEL)oldSel withMethod:(SEL)newSel;

- (void)copyMethodList:(void(^)(Method method))block;

// ivar
- (void)copyIvarList:(void(^)(Ivar ivar))block;

@end


@interface CocoaProperty : NSObject

@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           ///< property's name
@property (nonatomic, assign, readonly) CCInstanceEncodingType type;      ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil
@property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)

+ (instancetype)resolve:(objc_property_t)property;
- (instancetype)initWithProperty:(objc_property_t)property;

@end


@interface CocoaIvar : NSObject

@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) CCInstanceEncodingType type;    ///< Ivar's type

+ (instancetype)resolve:(Ivar)ivar;
- (instancetype)initWithIvar:(Ivar)ivar;

@end


@interface CocoaMethod : NSObject

@property (nonatomic, assign, readonly) Method method;                  ///< method opaque struct
@property (nonatomic, strong, readonly) NSString *name;                 ///< method name
@property (nonatomic, assign, readonly) SEL sel;                        ///< method's selector
@property (nonatomic, assign, readonly) IMP imp;                        ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding;         ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type

+ (instancetype)resolve:(Method)method;
- (instancetype)initWithMethod:(Method)method;

@end

NS_ASSUME_NONNULL_END
