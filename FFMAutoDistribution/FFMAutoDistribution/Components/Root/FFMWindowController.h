//
//  FFMWindowController.h
//  FFMAutoDistribution
//
//  Created by 常小哲 on 18/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FFMWindowController : NSWindowController

- (IBAction)packing:(NSButton *)sender;

- (void)showAbout;
- (void)showPreference;
- (void)showRepoSetting;
- (void)showPrivateRepoSetting;

@end
