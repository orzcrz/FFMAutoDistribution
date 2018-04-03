//
//  FFMWindowController.m
//  FFMAutoDistribution
//
//  Created by 常小哲 on 18/4/3.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMWindowController.h"
#import "FFMHomeController.h"

@interface FFMWindowController ()

@end

@implementation FFMWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    FFMHomeController *vc = [[FFMHomeController alloc] initWithNibName:@"FFMHomeController" bundle:[NSBundle mainBundle]];
    self.contentViewController = vc;
}

@end
