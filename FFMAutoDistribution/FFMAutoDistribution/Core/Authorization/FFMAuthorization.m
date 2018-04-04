//
//  FFMAuthorization.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMAuthorization.h"

@implementation FFMAuthorization

+ (instancetype)requestAuthorization:(void (^)(BOOL))result {
    FFMAuthorization *auth = [FFMAuthorization new];
    
    !result ?: result([auth requestAuthorization]);

    return auth;
}

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
