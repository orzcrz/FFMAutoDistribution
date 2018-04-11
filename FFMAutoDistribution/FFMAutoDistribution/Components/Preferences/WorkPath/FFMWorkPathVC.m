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
@property (weak) IBOutlet NSTextField *podPath;
@property (weak) IBOutlet NSTextField *xcprettyPath;

@end

@implementation FFMWorkPathVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FFMUserDefault *ud = [FFMUserDefault new];
    _workPath.stringValue = ud.FFMPackingWorkPath?:@"";
    _podPath.stringValue = ud.FFMPackingPodPath?:@"";
    _xcprettyPath.stringValue = ud.FFMPackingXcprettyPath?:@"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveWorkPath) name:NSControlTextDidEndEditingNotification object:nil];
}

- (IBAction)selectPath:(NSButton *)sender {
    sender.state = NSOnState;
    
    [FFMUtils openPanel:^(NSString *path) {
        _workPath.stringValue = path;
        [self saveWorkPath];
    }];
}

- (void)saveWorkPath {
    FFMUserDefault *ud = [FFMUserDefault new];
    ud.FFMPackingWorkPath = _workPath.stringValue;
    ud.FFMPackingPodPath = _podPath.stringValue;
    ud.FFMPackingXcprettyPath = _xcprettyPath.stringValue;
}

@end
