//
//  FFMSetPrivateRepo.m
//  FFMAutoDistribution
//
//  Created by 常润泽 on 2018/5/21.
//  Copyright © 2018年 常润泽. All rights reserved.
//

#import "FFMSetPrivateRepo.h"

#import "FFMPrivateRepoInfo.h"

@interface FFMSetPrivateRepo ()<NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FFMSetPrivateRepo

- (void)windowDidLoad {
    [super windowDidLoad];
    
    FFMUserDefault *ud = [FFMUserDefault new];
    self.dataSource = @[].mutableCopy;
    [ud.FFMPrivateSpecs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        FFMPrivateRepoInfo *info = [[FFMPrivateRepoInfo alloc] initWithName:key url:obj];
        [self.dataSource addObject:info];
    }];
    [self.dataSource addObject:[[FFMPrivateRepoInfo alloc] initWithName:@"123" url:@"345"]];
    [self.dataSource addObject:[[FFMPrivateRepoInfo alloc] initWithName:@"123" url:@"345"]];

    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:NSTextDidEndEditingNotification object:nil];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    FFMPrivateRepoInfo *info = [self.dataSource objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"name"]) {
        return info.name;
    }
    else if ([tableColumn.identifier isEqualToString:@"url"]) {
        return info.url;
    }
    
    return nil;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.dataSource count];
}

- (void)textDidEndEditing:(NSNotification *)notification {
    NSTextFieldCell *cell = [self.tableView selectedCell];
    FFMPrivateRepoInfo *info = [self.dataSource objectAtIndex:self.tableView.editedRow];
    
}

@end
