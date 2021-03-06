//
//  FFMTestFlightSettingVC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMTestFlightSettingVC.h"

@interface FFMTestFlightSettingVC ()

@property (weak) IBOutlet NSTextField *accountTF;
@property (weak) IBOutlet NSSecureTextField *passcodeTF;

@end

@implementation FFMTestFlightSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    FFMUserDefault *ud = [FFMUserDefault new];
    _accountTF.stringValue = ud.FFMPackingTestFlightAccount?:@"";
    _passcodeTF.stringValue = ud.FFMPackingTestFlightPasscode?:@"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDeveloperInfo) name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)saveDeveloperInfo {
    FFMUserDefault *ud = [FFMUserDefault new];
    _accountTF.stringValue = ud.FFMPackingTestFlightAccount;
    _passcodeTF.stringValue = ud.FFMPackingTestFlightPasscode;
}

@end
