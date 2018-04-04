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

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

#pragma mark-   touch action

- (IBAction)cancel:(id)sender {
    [self.window orderOut:nil];
}

- (IBAction)confirm:(NSButton *)sender {
    sender.state = NSControlStateValueOn;
    
}

@end
