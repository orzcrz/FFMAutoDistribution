//
//  FFMPrivateRepoInfo.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/5/22.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMPrivateRepoInfo.h"

@implementation FFMPrivateRepoInfo

- (instancetype)initWithName:(NSString *)name url:(NSString *)url {
    if (self = [super init]) {
        _name = name;
        _url = url;
    }
    return self;
}

@end
