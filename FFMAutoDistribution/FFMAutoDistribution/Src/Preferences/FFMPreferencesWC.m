//
//  FFMPreferencesWC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMPreferencesWC.h"

@interface FFMPreferencesWC ()

@end

@implementation FFMPreferencesWC

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

#pragma mark-  tool bar

- (IBAction)pgy:(NSToolbarItem *)sender {
    [self.window ffm_setSize:NSMakeSize(300, 300)];
}

- (IBAction)fir:(NSToolbarItem *)sender {
    [self.window ffm_setSize:NSMakeSize(600, 150)];
}

- (IBAction)testFlight:(NSToolbarItem *)sender {
    [self.window ffm_setSize:NSMakeSize(700, 150)];
}

- (IBAction)workPath:(NSToolbarItem *)sender {
    [self.window ffm_setSize:NSMakeSize(800, 400)];
}

@end
