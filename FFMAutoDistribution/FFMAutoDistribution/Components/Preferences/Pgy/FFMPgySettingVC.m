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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _akTF.stringValue = [ud stringForKey:FFMPackingPgyAPIKey]?:@"";
    _ukTF.stringValue = [ud stringForKey:FFMPackingPgyUserKey]?:@"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePgyApiInfo) name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)savePgyApiInfo {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_akTF.stringValue forKey:FFMPackingPgyAPIKey];
    [ud setObject:_ukTF.stringValue forKey:FFMPackingPgyUserKey];
    [ud synchronize];
}

@end
