//
//  FFMUserDefault.h
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/3/30.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFMUserDefault : NSObject

@property (nonatomic, strong) NSArray<NSString *> *FFMPackingBranches;  // 打包的分支
@property (nonatomic, assign) BOOL FFMAppAuthorization;     // 授权
@property (nonatomic, copy) NSString *FFMGitRepoRemoteName; // 远程仓库名 eg. origin
@property (nonatomic, copy) NSString *FFMGitRepoRemoteURL;  // 远程仓库地址
@property (nonatomic, copy) NSString *FFMGitRepoLocalName;  // 本地仓库名称 文件夹名
@property (nonatomic, copy) NSString *FFMPackingWorkPath;   // 打包工作路径 创建备份文件和临时文件的文件夹路径
@property (nonatomic, copy) NSString *FFMPackingPodPath;    // pod 路径
@property (nonatomic, copy) NSString *FFMPackingXcprettyPath;   // xcpretty 路径
@property (nonatomic, copy) NSString *FFMPackingLog;        // 打包的日志
@property (nonatomic, copy) NSString *FFMPackingFirAPIToken;   // 上传Fir所需的tk
@property (nonatomic, copy) NSString *FFMPackingPgyAPIKey;   // 上传Pgy所需的ak
@property (nonatomic, copy) NSString *FFMPackingPgyUserKey;   // 上传Pgy所需的uk
@property (nonatomic, copy) NSString *FFMPackingTestFlightAccount;      // 上传TestFlight所需的开发者帐号
@property (nonatomic, copy) NSString *FFMPackingTestFlightPasscode;     // 上传TestFlight所需的开发者密码

@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *FFMPrivateSpecs;     // 私仓  url : name

@end
