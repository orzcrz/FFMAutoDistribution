//
//  FFMAboutWC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMAboutWC.h"

@interface FFMAboutWC ()

@property (weak) IBOutlet NSTextField *appName;
@property (weak) IBOutlet NSTextField *version;

@end

@implementation FFMAboutWC
- (IBAction)pgy:(id)sender {
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_name = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    self.appName.stringValue = app_name;
    self.version.stringValue = [NSString stringWithFormat:@"v%@", app_version];
}

@end
