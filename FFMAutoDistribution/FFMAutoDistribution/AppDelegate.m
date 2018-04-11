//
//  AppDelegate.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "AppDelegate.h"
#import "FFMAuthorization.h"
#import "FFMUserDefaultsManager.h"

#import "FFMGitRepoSettingWC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [FFMUserDefaultsManager.shareManager registerClass:[FFMUserDefault class]];
    
    _windowController = [FFMWindowController ffm_loadFromNib];
    [_windowController.window makeKeyAndOrderFront:nil];
    
    FFMUserDefault *ud = [FFMUserDefault new];
    if (!ud.FFMAppAuthorization) {
        [FFMAuthorization requestAuthorization:^(BOOL isAuthorized) {
            ud.FFMAppAuthorization = isAuthorized;
        }];
    }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    [_windowController.window makeKeyAndOrderFront:nil];
    return YES;
}

#pragma mark-  dock menu

- (IBAction)packing:(NSMenuItem *)sender {
    [_windowController packing:nil];
}

#pragma mark-  top menu

- (IBAction)about:(NSMenuItem *)sender {
    [_windowController showAbout];
}

- (IBAction)preferences:(id)sender {
    [_windowController showPreference];
}

- (IBAction)setGitRepo:(id)sender {
    [_windowController showRepoSetting];
}


@end
