//
//  FFMPreferencesWC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMPreferencesWC.h"

#import "FFMPgySettingVC.h"
#import "FFMFirSettingVC.h"
#import "FFMTestFlightSettingVC.h"
#import "FFMWorkPathVC.h"

@interface FFMPreferencesWC () {
    NSView *_titleBar;
}

@property (nonatomic, strong) FFMPgySettingVC *pgyVC;
@property (nonatomic, strong) FFMFirSettingVC *firVC;
@property (nonatomic, strong) FFMTestFlightSettingVC *testFlightVC;
@property (nonatomic, strong) FFMWorkPathVC *workPathVC;

@end

@implementation FFMPreferencesWC

- (void)windowDidLoad {
    [super windowDidLoad];
    _titleBar = self.window.ffm_titleBar;
    [self pgy:nil];
}

#pragma mark-  tool bar

- (IBAction)pgy:(NSToolbarItem *)sender {
    [self changeContentView:self.pgyVC.view];
}

- (IBAction)fir:(NSToolbarItem *)sender {
    [self changeContentView:self.firVC.view];
}

- (IBAction)testFlight:(NSToolbarItem *)sender {
    [self changeContentView:self.testFlightVC.view];
}

- (IBAction)workPath:(NSToolbarItem *)sender {
    [self changeContentView:self.workPathVC.view];
}

#pragma mark-  utils

- (void)changeContentView:(NSView *)view {
    NSRect rect = view.frame;
    rect.origin = NSZeroPoint;
    view.frame = rect;
    [self.window ffm_setSize:NSMakeSize(rect.size.width, rect.size.height+NSHeight(_titleBar.frame))];
    [self.window.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.window.contentView addSubview:view];
}

#pragma mark-   Setter & Getter

- (FFMPgySettingVC *)pgyVC {
    if (_pgyVC) return _pgyVC;
    _pgyVC = [FFMPgySettingVC ffm_loadFromNib];
    return _pgyVC;
}

- (FFMFirSettingVC *)firVC {
    if (_firVC) return _firVC;
    _firVC = [FFMFirSettingVC ffm_loadFromNib];
    return _firVC;
}

- (FFMTestFlightSettingVC *)testFlightVC {
    if (_testFlightVC) return _testFlightVC;
    _testFlightVC = [FFMTestFlightSettingVC ffm_loadFromNib];
    return _testFlightVC;
}


- (FFMWorkPathVC *)workPathVC {
    if (_workPathVC) return _workPathVC;
    _workPathVC = [FFMWorkPathVC ffm_loadFromNib];
    return _workPathVC;
}

@end
