//
//  AppDelegate.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "AppDelegate.h"

#import "FFMAboutController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _windowController = [[FFMWindowController alloc] initWithWindowNibName:@"FFMWindowController"];
    [_windowController.window center];
    [_windowController.window makeKeyAndOrderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark-  menu

- (IBAction)about:(NSMenuItem *)sender {
    FFMAboutController *vc = [[FFMAboutController alloc] initWithNibName:@"FFMAboutController" bundle:nil];
    [_windowController.contentViewController presentViewControllerAsModalWindow:vc];
}



@end
