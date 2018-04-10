//
//  FFMUtils.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMUtils.h"

@implementation FFMUtils

+ (void)alertMessage:(NSString *)msg {
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert setMessageText:msg];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert beginSheetModalForWindow:[NSApplication.sharedApplication mainWindow] completionHandler:^(NSModalResponse returnCode) {
    }];
}

+ (void)openPanel:(void (^)(NSString *path))block {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canCreateDirectories = YES;
    panel.canChooseDirectories = YES;
    [panel setAllowsMultipleSelection:NO];
    [panel beginSheetModalForWindow:NSApplication.sharedApplication.mainWindow completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSString *pathString = panel.URL.path;
            !block ?: block(pathString);
        }
    }];
}

+ (NSBundle *)bundleWithName:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

@end
