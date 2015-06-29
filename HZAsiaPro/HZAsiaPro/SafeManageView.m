//
//  SafeManageView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/23.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "SafeManageView.h"
#import "ComponentsFactory.h"

#define CELL_ROW_HEIGHT             40.0f

#define CELL_TITLE_LABEL_TAG        102

@implementation SafeManageView

@synthesize contentTable;
@synthesize itemList;
@synthesize delegate;

- (void)dealloc
{
    [contentTable release];
    if (itemList != nil) {
        [itemList release];
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTable = tableView;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    [tableView release];
}

- (void)reloadViewData:(NSArray *)itemData
{
    self.itemList = itemData;
    [self.contentTable reloadData];
}

#pragma mark
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(safeManageView:didSelectRow:)]) {
        [self.delegate safeManageView:self
                         didSelectRow:row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *safeManCell = @"safeManCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:safeManCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:safeManCell] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = CELL_TITLE_LABEL_TAG;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 1;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 30, 0, 20));
        }];
        [titleLabel release];
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(CELL_ROW_HEIGHT-1);
            make.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView);
        }];
        [seperView release];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    
    NSInteger row = indexPath.row;
    titleLabel.text = [self.itemList objectAtIndex:row];
    
    return cell;
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

@end
