//
//  FFMGitRepoSettingWC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMGitRepoSettingWC.h"

@interface FFMGitRepoSettingWC ()

@property (weak) IBOutlet NSTextField *remoteNameTF;
@property (weak) IBOutlet NSTextField *remoteTF;
@property (weak) IBOutlet NSTextField *localNameTF;
@property (weak) IBOutlet NSTextField *localTF;
@property (weak) IBOutlet NSButton *confirmBtn;

@end

@implementation FFMGitRepoSettingWC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _remoteNameTF.stringValue = [ud stringForKey:FFMGitRepoRemoteName]?:@"";
    _remoteTF.stringValue = [ud stringForKey:FFMGitRepoRemoteURL]?:@"";
    _localNameTF.stringValue = [ud stringForKey:FFMGitRepoLocalName]?:@"";
    _localTF.stringValue = [ud stringForKey:FFMGitRepoLocalURL]?:@"";

    __weak typeof(self) weakself = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSControlTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        weakself.confirmBtn.enabled = \
        weakself.remoteNameTF.stringValue.length &&
        weakself.remoteTF.stringValue.length &&
        weakself.localNameTF.stringValue.length &&
        weakself.localTF.stringValue.length;
    }];
}

#pragma mark-   touch action

- (IBAction)cancel:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)confirm:(NSButton *)sender {
    sender.state = NSOnState;
    
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_remoteNameTF.stringValue forKey:FFMGitRepoRemoteName];
    [ud setObject:_remoteTF.stringValue forKey:FFMGitRepoRemoteURL];
    [ud setObject:_localNameTF.stringValue forKey:FFMGitRepoLocalName];
    [ud setObject:_localTF.stringValue forKey:FFMGitRepoLocalURL];
    [ud synchronize];
}

@end
