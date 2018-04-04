//
//  FFMBaseView.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMBaseView.h"

@implementation FFMBaseView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    [[NSColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1] setFill];
    NSRectFill(dirtyRect);
}

@end
