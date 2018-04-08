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
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    [[_task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *output) {
        dispatch_async(mainQueue, ^{
            !weakself.outputReadabilityHandler ?: weakself.outputReadabilityHandler(output);
        });
    }];
    
    [[_task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *error) {
        dispatch_async(mainQueue, ^{
            !weakself.errorReadabilityHandler ?: weakself.errorReadabilityHandler(error);
        });
    }];
    
    [_task setTerminationHandler:^(NSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !weakself.terminationHandler ?: weakself.terminationHandler(task);
        });
        
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
