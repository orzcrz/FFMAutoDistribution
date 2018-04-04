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

@property (nonatomic, strong) FFMAboutWC *about;
@property (nonatomic, strong) FFMPreferencesWC *preferenceWC;
@property (nonatomic, strong) FFMGitRepoSettingWC *gitRepo;

@end

@implementation FFMWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

- (void)end {
    
}

- (void)showAbout {
    [self.about showWindow:self];
}

- (void)showPreference {
    [self.preferenceWC showWindow:self];
}

- (void)showRepoSetting {
    [self.gitRepo showWindow:self];
}

#pragma mark-   Setter & Getter

- (FFMAboutWC *)about {
    if (_about) return _about;
    _about = [FFMAboutWC ffm_loadFromNib];
    return _about;
}

- (FFMPreferencesWC *)preferenceWC {
    if (_preferenceWC) return _preferenceWC;
    _preferenceWC = [FFMPreferencesWC ffm_loadFromNib];
    return _preferenceWC;
}

- (FFMGitRepoSettingWC *)gitRepo {
    if (_gitRepo) return _gitRepo;
    _gitRepo = [FFMGitRepoSettingWC ffm_loadFromNib];
    return _gitRepo;
}

@end
