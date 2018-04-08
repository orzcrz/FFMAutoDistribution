//
//  NSWindowController+Ext.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/4.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMNibHelper.h"

@implementation NSWindowController (Ext)

+ (instancetype)ffm_loadFromNib {
    return [[self alloc] initWithWindowNibName:NSStringFromClass(self)];
}

@end


@implementation NSWindow (Ext)

- (NSView *)ffm_titleBar {
    for (NSView *view in self.contentView.superview.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"NSTitlebarContainerView")]) {
            return view;
        }
    }
    return nil;
}

- (void)ffm_setSize:(NSSize)size {
    // top regular
    NSPoint origin = NSMakePoint(NSMinX(self.frame), NSMinY(self.frame) + NSHeight(self.frame) - size.height);
    [self setFrame:(NSRect){origin, size}
           display:YES
           animate:YES];
}

@end


@implementation NSViewController (Ext)

+ (instancetype)ffm_loadFromNib {
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
}

@end
