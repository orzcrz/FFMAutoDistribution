//
//  FFMAuthorization.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMAuthorization.h"
#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>

@implementation FFMAuthorization

+ (instancetype)requestAuthorization:(void (^)(BOOL))result {
    FFMAuthorization *auth = [FFMAuthorization new];
    
    !result ?: result([auth requestAuthorization]);

    return auth;
}

//- (BOOL)requestAuthorization {
//
//    AuthorizationRef authRef = NULL;
//
//    OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authRef);
//    if (status != errAuthorizationSuccess) {
//        authRef = NULL;
//        return NO;
//    }
//
//    BOOL result = NO;
//    NSError *error = nil;
//    AuthorizationItem authItem        = { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
//    AuthorizationRights authRights    = { 1, &authItem };
//    AuthorizationFlags flags          = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
//
//    status = AuthorizationCopyRights(authRef, &authRights, kAuthorizationEmptyEnvironment, flags, NULL);
//    if (status != errAuthorizationSuccess) {
//        error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//    } else {
//        CFErrorRef  cfError;
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
//        result = (BOOL) SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef)bundleId, authRef, &cfError);
//        if (!result) {
//            error = CFBridgingRelease(cfError);
//            NSLog(@"%@", error);
//        }
//    }
//
//    return result;
//}

- (BOOL)requestAuthorization {
    AuthorizationRef myAuthorizationRef;
    OSStatus myStatus;
    myStatus = AuthorizationCreate (NULL, kAuthorizationEmptyEnvironment,
                                    kAuthorizationFlagExtendRights | kAuthorizationFlagInteractionAllowed , &myAuthorizationRef);
    AuthorizationItem myItems[1];
    myItems[0].name = [[NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleIdentifier"] UTF8String];
    myItems[0].valueLength = 0;
    myItems[0].value = NULL;
    myItems[0].flags = 0;

    AuthorizationRights myRights;
    myRights.count = sizeof (myItems) / sizeof (myItems[0]);
    myRights.items = myItems;

    AuthorizationFlags myFlags;
    myFlags = kAuthorizationFlagDefaults |
    kAuthorizationFlagInteractionAllowed |
    kAuthorizationFlagExtendRights;

    myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights,
                                        kAuthorizationEmptyEnvironment, myFlags, NULL);
    return (myStatus==errAuthorizationSuccess);
}

@end
