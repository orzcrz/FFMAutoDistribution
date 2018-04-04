//
//  FFMWindowController.m
//  FFMAutoDistribution
//
//  Created by 常小哲 on 18/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMWindowController.h"

#import "FFMAboutWC.h"
#import "FFMPreferencesWC.h"
#import "FFMGitRepoSettingWC.h"

@interface FFMWindowController ()

@end

@implementation FFMWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

- (void)showAbout {
    FFMAboutWC *about = [FFMAboutWC ffm_loadFromNib];
    [self showWindow:about.window];
    [about.window orderFront:nil];
}

- (void)showPreference {
    FFMPreferencesWC *preferenceWC = [FFMPreferencesWC ffm_loadFromNib];
    [self showWindow:preferenceWC.window];
    [preferenceWC.window orderFront:nil];
}

- (void)showRepoSetting {
    FFMGitRepoSettingWC *gitRepo = [FFMGitRepoSettingWC ffm_loadFromNib];
    
    [self showWindow:gitRepo.window];
    [gitRepo.window orderFront:nil];
}


@end
