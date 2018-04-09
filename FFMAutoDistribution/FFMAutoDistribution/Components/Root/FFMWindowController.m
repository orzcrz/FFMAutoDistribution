//
//  FFMWindowController.m
//  FFMAutoDistribution
//
//  Created by 常小哲 on 18/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMWindowController.h"
#import "FFMOutputWC.h"
#import "FFMAboutWC.h"
#import "FFMPreferencesWC.h"
#import "FFMGitRepoSettingWC.h"

#import "FFMShellTask.h"

@interface FFMWindowController ()<NSComboBoxDataSource>

@property (nonatomic, strong) FFMAboutWC *about;
@property (nonatomic, strong) FFMPreferencesWC *preferenceWC;
@property (nonatomic, strong) FFMGitRepoSettingWC *gitRepo;
@property (nonatomic, strong) FFMOutputWC *output;

@property (weak) IBOutlet NSComboBox *branch; // 分支名
@property (weak) IBOutlet NSPopUpButton *sign; // development/ad-hoc/app-store
@property (weak) IBOutlet NSPopUpButton *build; // Debug/Release
@property (weak) IBOutlet NSPopUpButton *platform; // 分发平台
@property (unsafe_unretained) IBOutlet NSTextView *log; // 更新日志
@property (weak) IBOutlet NSButton *packingBtn;

@end

@implementation FFMWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(editingDidChange:) name:NSControlTextDidChangeNotification object:self.branch];
    [notiCenter addObserver:self selector:@selector(editingDidChange:) name:NSTextViewDidChangeSelectionNotification object:self.log];
    
    [self commonInit];
    
}

- (void)commonInit {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *branches = [ud stringArrayForKey:FFMPackingBranches];
    self.branch.stringValue = branches.count ? branches.firstObject : @"";
    
    self.log.string = [ud stringForKey:FFMPackingLog] ?: @"";
}

- (void)editingDidChange:(NSNotification *)note {
    self.packingBtn.enabled = \
    self.branch.stringValue.length &&
    self.log.string.length;
    
    if (note.object == self.log) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:self.log.string forKey:FFMPackingLog];
        [ud synchronize];
    }
}

#pragma mark-   touch action

- (IBAction)packing:(NSButton *)sender {
    sender.state = NSOnState;
    
    FFMShellTaskArgs *shellArgs = [FFMShellTaskArgs new];
    shellArgs.branchName = self.branch.stringValue;
    shellArgs.log = self.log.string;
    shellArgs.signMode = self.sign.title;
    shellArgs.buildConfig = self.build.title;
    FFMPackingPlatform pf = FFMPackingPlatform_Pgy;
    if ([self.platform.title isEqualToString:@"None"]) {
        pf = FFMPackingPlatform_None;
    }
    else if ([self.platform.title isEqualToString:@"Fir"]) {
        pf = FFMPackingPlatform_Fir;
    }
    else if ([self.platform.title isEqualToString:@"TestFlight"]) {
        pf = FFMPackingPlatform_TestFlight;
    }
    
    shellArgs.platform = pf;
    self.output = [FFMOutputWC ffm_loadFromNib];
    self.output.args = shellArgs;
    [self.window beginSheet:self.output.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
}

- (IBAction)checkBranch:(NSComboBox *)sender {
    if (!sender.stringValue.length) {
        return;
    }
    
    NSString *branch = sender.stringValue;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *branches = [[ud arrayForKey:FFMPackingBranches]?:@[] mutableCopy];
    if (branches.count > 5) {
        [branches replaceObjectAtIndex:0 withObject:branch];
    }
    else {
        if ([branches indexOfObject:branch] != 0) {
            if ([branches containsObject:branch]) {
                [branches removeObject:branch];
            }
            
            [branches insertObject:branch atIndex:0];
        }
    }
    [ud setObject:branches.copy forKey:FFMPackingBranches];
    [sender reloadData];

}

- (IBAction)selectSignMode:(NSPopUpButton *)sender {

}

- (IBAction)selectBuilidConfig:(NSPopUpButton *)sender {

}

- (IBAction)selectPlatform:(NSPopUpButton *)sender {

}

#pragma mark-   NSComboBoxDataSource

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    NSArray *branches = [[NSUserDefaults standardUserDefaults] arrayForKey:FFMPackingBranches];
    return branches.count;
}

- (nullable id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    NSArray *branches = [[NSUserDefaults standardUserDefaults] arrayForKey:FFMPackingBranches];
    if (branches.count) {
        return branches[index];
    }
    return nil;
}

#pragma mark-   preference

- (void)showAbout {
    [self.about showWindow:self];
}

- (void)showPreference {
    [self.preferenceWC showWindow:self];
}

- (void)showRepoSetting {    
    [self.window beginSheet:self.gitRepo.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
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
