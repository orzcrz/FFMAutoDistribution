//
//  AppDelegate.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "AppDelegate.h"
#import "FFMAuthorization.h"

#import "FFMGitRepoSettingWC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _windowController = [FFMWindowController ffm_loadFromNib];
    [_windowController.window makeKeyAndOrderFront:nil];
    [FFMAuthorization requestAuthorization:^(BOOL isAuthorized) {
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

#pragma mark-  menu

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
