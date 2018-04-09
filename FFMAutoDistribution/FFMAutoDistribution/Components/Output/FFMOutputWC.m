//
//  FFMOutputWC.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/4/8.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMOutputWC.h"

#import "FFMShellTask.h"

@interface FFMOutputWC ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (strong) FFMShellTask *task;
@property (weak) IBOutlet NSButton *stopBtn;

@end

@implementation FFMOutputWC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.task = [FFMShellTask new];
    
    __weak typeof(self) weakself = self;
    self.task.outputReadabilityHandler = ^(NSFileHandle *output) {
        NSData *data = output.availableData;
        if (data.length) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [weakself appendConentString:string toTextView:weakself.textView];
        }
    };
    self.task.errorReadabilityHandler = ^(NSFileHandle *error) {
        NSData *data = error.availableData;
        if (data.length) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [weakself appendConentString:string toTextView:weakself.textView];
        }
    };
    self.task.terminationHandler = ^(NSTask *task) {
        [weakself appendConentString:@"退出当前任务" toTextView:weakself.textView];
    };
    
    [self.task startWithArgs:self.args];
}

- (IBAction)pressStopButtonAction:(NSButton *)sender {
    [self.task stop];
    [self.window.sheetParent endSheet:self.window];
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
