//
//  AppDelegate.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "AppDelegate.h"
#import "FFMAuthorization.h"

#import "FFMAboutWC.h"
#import "FFMPreferencesWC.h"

@interface AppDelegate () {
    FFMPreferencesWC *_preferenceWC;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _windowController = [FFMWindowController ffm_loadFromNib];
    [_windowController.window makeKeyAndOrderFront:nil];
    
//    [FFMAuthorization requestAuthorization:^(BOOL isAuthorized) {
//    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

#pragma mark-  menu

- (IBAction)about:(NSMenuItem *)sender {
    FFMAboutWC *about = [FFMAboutWC ffm_loadFromNib];
    [_windowController showWindow:about.window];
    [about.window orderFront:nil];
}

- (IBAction)preferences:(id)sender {
    _preferenceWC = [FFMPreferencesWC ffm_loadFromNib];
    [_windowController showWindow:_preferenceWC.window];
    [_preferenceWC.window orderFront:nil];
}


@end
