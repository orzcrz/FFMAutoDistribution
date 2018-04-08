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

- (IBAction)openPanel:(NSButton *)sender {
    [FFMUtils openPanel:^(NSString *path) {
        _localTF.stringValue = path;
    }];
}

- (IBAction)cancel:(id)sender {
    [self.window close];
}

- (IBAction)confirm:(NSButton *)sender {
    sender.state = NSControlStateValueOn;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_remoteNameTF.stringValue forKey:FFMGitRepoRemoteName];
    [ud setObject:_remoteTF.stringValue forKey:FFMGitRepoRemoteURL];
    [ud setObject:_localNameTF.stringValue forKey:FFMGitRepoLocalName];
    [ud setObject:_localTF.stringValue forKey:FFMGitRepoLocalURL];
    [ud synchronize];
}

@end
