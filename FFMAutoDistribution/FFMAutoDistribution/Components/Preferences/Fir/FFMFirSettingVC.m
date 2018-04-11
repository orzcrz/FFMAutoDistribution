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

    FFMUserDefault *ud = [FFMUserDefault new];
    _tkTF.stringValue = ud.FFMPackingFirAPIToken?:@"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveFirApiInfo) name:NSControlTextDidEndEditingNotification object:nil];
}

- (void)saveFirApiInfo {
    FFMUserDefault *ud = [FFMUserDefault new];
    _tkTF.stringValue = ud.FFMPackingFirAPIToken;
}

@end
