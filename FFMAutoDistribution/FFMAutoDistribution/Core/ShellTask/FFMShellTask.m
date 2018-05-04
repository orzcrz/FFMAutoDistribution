//
//  FFMShellTask.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMShellTask.h"
#import <objc/runtime.h>

@implementation FFMShellTaskArgs

- (instancetype)init
{
    self = [super init];
    if (self) {
        FFMUserDefault *ud = [FFMUserDefault new];
        _repoLocalPath = ud.FFMPackingWorkPath;
        _repoProjectName = ud.FFMGitRepoLocalName;
        _repoRemoteURL = ud.FFMGitRepoRemoteURL;
        _podPath = ud.FFMPackingPodPath;
        _xcprettyPath = ud.FFMPackingXcprettyPath;
    }
    return self;
}

- (void)setPlatform:(NSString *)platform {
    FFMUserDefault *ud = [FFMUserDefault new];
    NSString *shellName = @"packing";

    if ([platform isEqualToString:@"蒲公英"]) {
        shellName = @"pgy";
        self.ext1 = ud.FFMPackingPgyAPIKey;
        self.ext2 = ud.FFMPackingPgyUserKey;
    }
    else if ([platform isEqualToString:@"Fir"]) {
        shellName = @"fir";
        self.ext1 = ud.FFMPackingFirAPIToken;
    }
    else if ([platform isEqualToString:@"TestFlight"]) {
        shellName = @"testflight";
        self.ext1 = ud.FFMPackingTestFlightAccount;
        self.ext2 = ud.FFMPackingTestFlightPasscode;
    }

    self.shellPath = [[FFMUtils bundleWithName:@"shell"] pathForResource:shellName ofType:@"sh"];
}

- (void)setSignMode:(NSString *)signMode {
    _signMode = signMode;
    
    _plistPath = [[FFMUtils bundleWithName:@"plist"] pathForResource:signMode ofType:@"plist"];
}

- (NSArray<NSString *> *)allArgs {
    NSMutableArray *args = @[].mutableCopy;
    u_int count;
    objc_property_t *propertList = class_copyPropertyList(self.class, &count);
    if (propertList) {
        for (u_int i = 0; i < count; i++) {
            objc_property_t property = propertList[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                              encoding:NSUTF8StringEncoding];
            NSString *value = [self valueForKey:propertyName];
            [args addObject:value?:@""];
        }
    }
    free(propertList);
    
    return args;
}

@end


@implementation FFMShellTask

- (instancetype)init {
    self = [super init];
    if (self) {
        _task = [NSTask new];
        _task.launchPath = @"/bin/sh";
        
        _output = [NSPipe pipe];
        _error = [NSPipe pipe];
        
        [_task setStandardOutput:_output];
        [_task setStandardError:_error];
    }
    return self;
}

- (void)startWithArgs:(FFMShellTaskArgs *)args {
    _task.arguments = args.allArgs;
    __weak typeof(self) weakself = self;
    [[_task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *output) {
        !weakself.outputReadabilityHandler ?: weakself.outputReadabilityHandler(output);
    }];
    
    [[_task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *error) {
        !weakself.errorReadabilityHandler ?: weakself.errorReadabilityHandler(error);
    }];
    
    [_task setTerminationHandler:^(NSTask *task) {
        !weakself.terminationHandler ?: weakself.terminationHandler(task);
        
        [task.standardOutput fileHandleForReading].readabilityHandler = nil;
        [task.standardError fileHandleForReading].readabilityHandler = nil;
    }];
    
    [_task launch];
}

- (void)stop {
    [_task interrupt];
    [_task terminate];
}

@end
