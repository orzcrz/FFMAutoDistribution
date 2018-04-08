//
//  FFMWorkPathVC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMWorkPathVC.h"

@interface FFMWorkPathVC ()

@property (weak) IBOutlet NSTextField *workPath;

@end

@implementation FFMWorkPathVC

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakself = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:NSControlTextDidEndEditingNotification object:_workPath queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakself updateWorkPath];
    }];
}

- (IBAction)selectPath:(NSButton *)sender {
    sender.state = NSControlStateValueOn;
    
    [FFMUtils openPanel:^(NSString *path) {
        _workPath.stringValue = path;
        [self updateWorkPath];
    }];
}

- (void)updateWorkPath {
    if (!_workPath.stringValue.length) return;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_workPath.stringValue forKey:FFMPackingWorkPath];
    [ud synchronize];
}

@end
