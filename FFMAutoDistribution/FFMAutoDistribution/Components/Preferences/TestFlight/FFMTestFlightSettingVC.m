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

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _accountTF.stringValue = [ud stringForKey:FFMPackingTestFlightAccount]?:@"";
    _passcodeTF.stringValue = [ud stringForKey:FFMPackingTestFlightPasscode]?:@"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDeveloperInfo) name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)saveDeveloperInfo {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_accountTF.stringValue forKey:FFMPackingTestFlightAccount];
    [ud setObject:_passcodeTF.stringValue forKey:FFMPackingTestFlightPasscode];
    [ud synchronize];
}

@end
