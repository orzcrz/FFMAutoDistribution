//
//  FFMPgySettingVC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMPgySettingVC.h"

@interface FFMPgySettingVC ()

@property (weak) IBOutlet NSTextField *akTF;
@property (weak) IBOutlet NSTextField *ukTF;

@end

@implementation FFMPgySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FFMUserDefault *ud = [FFMUserDefault new];
    _akTF.stringValue = ud.FFMPackingPgyAPIKey?:@"";
    _ukTF.stringValue = ud.FFMPackingPgyUserKey?:@"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePgyApiInfo) name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)savePgyApiInfo {
    FFMUserDefault *ud = [FFMUserDefault new];
    ud.FFMPackingPgyAPIKey = _akTF.stringValue;
    ud.FFMPackingPgyUserKey = _ukTF.stringValue;
}

@end
