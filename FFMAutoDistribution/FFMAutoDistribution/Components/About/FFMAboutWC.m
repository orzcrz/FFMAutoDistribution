//
//  FFMAboutWC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMAboutWC.h"

@interface FFMAboutWC ()

@property (weak) IBOutlet NSImageView *icon;
@property (weak) IBOutlet NSTextField *appName;
@property (weak) IBOutlet NSTextField *version;
@property (weak) IBOutlet NSTextField *rights;

@end

@implementation FFMAboutWC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.icon.wantsLayer = YES;
    self.icon.layer.cornerRadius = 16;
    self.icon.layer.masksToBounds = YES;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *bundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *shortVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *copyright = [infoDictionary objectForKey:@"NSHumanReadableCopyright"];
    self.appName.stringValue = name;
    self.version.stringValue = [NSString stringWithFormat:@"版本 %@（%@）", shortVersion, bundleVersion];
    self.rights.stringValue = copyright;
}

@end
