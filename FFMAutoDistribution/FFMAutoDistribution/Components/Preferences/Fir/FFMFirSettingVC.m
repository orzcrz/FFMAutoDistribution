//
//  FFMFirSettingVC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMFirSettingVC.h"

@interface FFMFirSettingVC ()

@property (weak) IBOutlet NSTextField *tkTF;

@end

@implementation FFMFirSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _tkTF.stringValue = [ud stringForKey:FFMPackingFirAPIToken]?:@"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveFirApiInfo) name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)saveFirApiInfo {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_tkTF.stringValue forKey:FFMPackingFirAPIToken];
    [ud synchronize];
}

@end
