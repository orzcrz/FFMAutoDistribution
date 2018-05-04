//
//  FFMShellTask.h
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFMShellTaskArgs : NSObject

@property (copy) NSString *shellPath;  // must be the first one in args

@property (copy) NSString *podPath;
@property (copy) NSString *xcprettyPath;

@property (copy) NSString *branchName;
@property (nonatomic, copy) NSString *signMode;
@property (copy) NSString *buildConfig;
@property (copy) NSString *repoLocalPath;
@property (copy) NSString *repoProjectName;
@property (copy) NSString *repoRemoteURL;
@property (copy) NSString *plistPath;
@property (copy) NSString *log;

@property (copy) NSString *ext1; // 追加字段
@property (copy) NSString *ext2; // 追加字段

- (void)setPlatform:(NSString *)platform;
- (NSArray<NSString *> *)allArgs;

@end



@interface FFMShellTask : NSObject

@property (strong, readonly) NSTask *task;
@property (strong, readonly) NSPipe *output;
@property (strong, readonly) NSPipe *error;

@property (copy) void (^outputReadabilityHandler)(NSFileHandle *output);
@property (copy) void (^errorReadabilityHandler)(NSFileHandle *error);
@property (copy) void (^terminationHandler)(NSTask *task);


- (void)startWithArgs:(FFMShellTaskArgs *)args;
- (void)stop;

@end
