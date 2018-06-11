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
@property (weak) IBOutlet NSButton *confirmBtn;

@end

@implementation FFMGitRepoSettingWC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    FFMUserDefault *ud = [FFMUserDefault new];
    _remoteNameTF.stringValue = ud.FFMGitRepoRemoteName?:@"";
    _remoteTF.stringValue = ud.FFMGitRepoRemoteURL?:@"";
    _localNameTF.stringValue = ud.FFMGitRepoLocalName?:@"";
    _confirmBtn.enabled = _remoteNameTF.stringValue.length && _remoteTF.stringValue.length;

    __weak typeof(self) weakself = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSControlTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        weakself.confirmBtn.enabled = \
        weakself.remoteNameTF.stringValue.length
        && weakself.remoteTF.stringValue.length
        && weakself.localNameTF.stringValue.length;
    }];
}

#pragma mark-   touch action

- (IBAction)cancel:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)confirm:(NSButton *)sender {
    sender.state = NSOnState;
    
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];

    FFMUserDefault *ud = [FFMUserDefault new];
    ud.FFMGitRepoRemoteName = _remoteNameTF.stringValue;
    ud.FFMGitRepoRemoteURL = _remoteTF.stringValue;
    ud.FFMGitRepoLocalName = _localNameTF.stringValue;
}

@end
