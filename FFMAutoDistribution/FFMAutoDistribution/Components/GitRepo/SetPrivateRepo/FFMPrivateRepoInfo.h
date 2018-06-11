//
//  FFMPrivateRepoInfo.h
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/5/22.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFMPrivateRepoInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithName:(NSString *)name url:(NSString *)url;

@end
