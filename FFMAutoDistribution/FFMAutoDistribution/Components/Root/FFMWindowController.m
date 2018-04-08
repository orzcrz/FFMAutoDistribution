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

@property (strong) FFMShellTaskArgs *shellArgs;

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
    self.shellArgs = [FFMShellTaskArgs new];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *branches = [ud stringArrayForKey:FFMPackingBranches];
    self.branch.stringValue = branches.count ? branches.firstObject : @"";
    self.shellArgs.branchName = self.branch.stringValue;
    
    self.log.string = [ud stringForKey:FFMPackingLog] ?: @"";
    self.shellArgs.log = self.log.string;
}

- (void)editingDidChange:(NSNotification *)note {
    self.packingBtn.enabled = \
    self.branch.stringValue.length &&
    self.log.string.length;
    
    if (note.object == self.log) {
        self.shellArgs.log = self.log.string;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:self.log.string forKey:FFMPackingLog];
        [ud synchronize];
    }
}

#pragma mark-   touch action

- (IBAction)packing:(NSButton *)sender {
    sender.state = NSOnState;
    
    self.output.args = self.shellArgs;
    
}

- (IBAction)checkBranch:(NSComboBox *)sender {
    if (!sender.stringValue.length) {
        return;
    }
    
    NSString *branch = sender.stringValue;
    self.shellArgs.branchName = branch;
    
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
    self.shellArgs.signMode = sender.selectedItem.title;
}

- (IBAction)selectBuilidConfig:(NSPopUpButton *)sender {
    self.shellArgs.buildConfig = sender.selectedItem.title;
}

- (IBAction)selectPlatform:(NSPopUpButton *)sender {
    self.shellArgs.platform = sender.selectedItem.title;
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
    [self.gitRepo showWindow:self];
}

#pragma mark-   Setter & Getter

- (FFMOutputWC *)output {
    if (_output) return _output;
    _output = [FFMOutputWC ffm_loadFromNib];
    return _output;
}

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
