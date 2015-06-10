//
//  CustomerListView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "CustomerListView.h"
#import "PureLayout.h"

#define CELL_NAME_LABEL_TAG         121
#define CELL_PHONE_LABEL_TAG        122


@implementation CustomerListView
@synthesize contentTable;
@synthesize customerList;
@synthesize delegate;

- (void)dealloc
{
    [contentTable release];
    [customerList release];
    
    [super dealloc];
}

- (void)layoutContentTable
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor grayColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.contentTable = tableView;
    [self addSubview:tableView];
    [tableView release];
    
}


#pragma mark
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellCode = @"CustomerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellCode];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:tableCellCode] autorelease];
        UILabel *nameLabel = [[UILabel alloc] initForAutoLayout];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.tag = CELL_NAME_LABEL_TAG;
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel *phoneLabel = [[UILabel alloc] initForAutoLayout];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.textColor = [UIColor blackColor];
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        phoneLabel.font = [UIFont systemFontOfSize:15.0f];
        phoneLabel.tag = CELL_PHONE_LABEL_TAG;
        [cell.contentView addSubview:phoneLabel];
        [phoneLabel release];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:CELL_NAME_LABEL_TAG];
    UILabel *phoneLabel = (UILabel *)[cell.contentView viewWithTag:CELL_PHONE_LABEL_TAG];
    
    NSInteger row = [indexPath row];
    NSDictionary *itemData = [self.customerList objectAtIndex:row];
    
    nameLabel.text = [itemData objectForKey:CUSTOMER_DIC_NAME_KEY];
    phoneLabel.text = [itemData objectForKey:CUSTOMER_DIC_PHONE_KEY];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerListView:didSelectRow:)]) {
        [self.delegate customerListView:self didSelectRow:row];
    }
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.customerList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
@end
