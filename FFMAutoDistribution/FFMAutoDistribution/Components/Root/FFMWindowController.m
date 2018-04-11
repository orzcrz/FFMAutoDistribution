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
    FFMUserDefault *ud = [FFMUserDefault new];
    NSArray *branches = ud.FFMPackingBranches;
    self.branch.stringValue = branches.count ? branches.firstObject : @"";
    
    self.log.string = ud.FFMPackingLog ?: @"";
}

- (void)editingDidChange:(NSNotification *)note {
    self.packingBtn.enabled = \
    self.branch.stringValue.length &&
    self.log.string.length;
    
    if (note.object == self.log) {
        FFMUserDefault *ud = [FFMUserDefault new];
        ud.FFMPackingLog = self.log.string;
    }
}

#pragma mark-   touch action

- (IBAction)packing:(NSButton *)sender {

    sender.state = NSOnState;
    
    if ([self.platform.title isEqualToString:@"Fir"] || [self.platform.title isEqualToString:@"TestFlight"]) {
        [FFMUtils alertMessage:@"功能尚未开发"];
        return;
    }
    
    FFMShellTaskArgs *shellArgs = [FFMShellTaskArgs new];
    shellArgs.branchName = self.branch.stringValue;
    shellArgs.log = self.log.string;
    shellArgs.signMode = self.sign.title;
    shellArgs.buildConfig = self.build.title;
    shellArgs.platform = self.platform.title;
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
    
    FFMUserDefault *ud = [FFMUserDefault new];
    NSMutableArray *branches = [ud.FFMPackingBranches?:@[] mutableCopy];
    if ([branches containsObject:branch]) {
        if (branches.count > 1) {
            [branches exchangeObjectAtIndex:[branches indexOfObject:branch] withObjectAtIndex:0];
        }
    }
    else {
        if (branches.count > 5) {
            [branches removeLastObject];
        }
        [branches insertObject:branch atIndex:0];
    }
    ud.FFMPackingBranches = branches.copy;
    [sender reloadData];

}

#pragma mark-   NSComboBoxDataSource

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    NSArray *branches = [FFMUserDefault new].FFMPackingBranches;
    return branches.count;
}

- (nullable id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    NSArray *branches = [FFMUserDefault new].FFMPackingBranches;
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
