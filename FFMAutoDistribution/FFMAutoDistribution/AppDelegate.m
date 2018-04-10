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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:FFMAppAuthorization]) {
        [FFMAuthorization requestAuthorization:^(BOOL isAuthorized) {
            [[NSUserDefaults standardUserDefaults] setBool:isAuthorized forKey:FFMAppAuthorization];
        }];
    }
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
