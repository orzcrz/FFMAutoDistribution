//
//  FFMUserDefaultsManager.h
//  FFMAutoDistribution
//
//  Created by RangerChiong on 2017/4/25.
//  Copyright © 2017年 Ranger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFMUserDefaultsManager : NSObject

@property (class, readonly, strong) FFMUserDefaultsManager *shareManager;

- (void)registerClass:(Class)aClass;
- (void)unregisterClass;

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeObjectsForKeys:(NSArray<NSString *> *)keys;

- (void)removeAllData;

@end
