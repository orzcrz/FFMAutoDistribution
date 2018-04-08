//
//  FFMOutputWC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMOutputWC.h"

@interface FFMOutputWC ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation FFMOutputWC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    
}

- (void)appendConentString:(NSString *)string toTextView:(NSTextView *)textView {
    NSRange theEnd = NSMakeRange(textView.string.length, 0);
    [textView.textStorage replaceCharactersInRange:NSMakeRange(textView.textStorage.length, 0)
                                        withString:string];
    theEnd.location += string.length;
    
    textView.textColor = [NSColor colorWithRed:53/255.0 green:240/255.0 blue:43/255.0 alpha:1.0];
    [textView scrollRangeToVisible:theEnd];
}

@end
