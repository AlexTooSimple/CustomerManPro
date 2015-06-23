//
//  CustomerListView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "CustomerListView.h"
#import "ComponentsFactory.h"

#define CELL_NAME_LABEL_TAG         121
#define CELL_PHONE_LABEL_TAG        122

#define CELL_ROW_HEIGHT             44.0f


@implementation CustomerListView
@synthesize contentTable;
@synthesize customerList;
@synthesize delegate;

- (void)dealloc
{
    [contentTable release];
    if (customerList != nil) {
        [customerList release];
    }
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self layoutContentTable];
    }
    return self;
}

- (void)layoutContentTable
{
    RefreshSingleView *singleView = [[RefreshSingleView alloc] initWithFrame:CGRectZero];
    singleView.loadIndex = 10000;
    singleView.pageNumLoad = 0;
    singleView.dataSource = self;
    singleView.delegate = self;
    singleView.backgroundColor = [UIColor clearColor];
    self.contentTable = singleView;
    [self addSubview:singleView];
    
    self.contentTable.contentTable.separatorColor = [UIColor clearColor];
    self.contentTable.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    [singleView release];
}

- (void)reloadData:(NSArray *)itemData
{
    [self.contentTable resetViewDataStream];
    [self.contentTable reloadViewData:itemData];
}

#pragma mark
#pragma mark - UITableViewDelegate
- (UITableViewCell *)refreshSingleView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellCode = @"CustomerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellCode];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:tableCellCode] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconView.backgroundColor = [UIColor clearColor];
        iconView.image = [UIImage imageNamed:@"icon_login_account.png"];
        [cell.contentView addSubview:iconView];
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.tag = CELL_NAME_LABEL_TAG;
        [cell.contentView addSubview:nameLabel];
        
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.textColor = [UIColor blackColor];
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        phoneLabel.font = [UIFont systemFontOfSize:15.0f];
        phoneLabel.tag = CELL_PHONE_LABEL_TAG;
        [cell.contentView addSubview:phoneLabel];
        
        
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.backgroundColor = [UIColor clearColor];
        arrowView.image = [UIImage imageNamed:@"icon_item_right.png"];
        [cell.contentView addSubview:arrowView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(10.0f);
            make.top.equalTo(cell.contentView).with.offset((CELL_ROW_HEIGHT-29)/2.0f);
            make.size.mas_equalTo(CGSizeMake(29, 29));
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(3.0f, 50.0f, 3.0f, cell.contentView.frame.size.width/2.0f-10.0f));
        }];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(3.0f);
            make.bottom.equalTo(cell.contentView).with.offset(-3.0f);
            make.left.equalTo(nameLabel.mas_right).with.offset(10.0f);
            make.right.equalTo(cell.contentView).with.offset(-20.0f);
        }];
        
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(phoneLabel.mas_right).with.offset(3.0f);
            make.size.mas_equalTo(CGSizeMake(7.0f, 12.0f));
        }];
        
        [iconView release];
        [nameLabel release];
        [phoneLabel release];
        [arrowView release];
        
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
        }];
        [seperView release];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:CELL_NAME_LABEL_TAG];
    UILabel *phoneLabel = (UILabel *)[cell.contentView viewWithTag:CELL_PHONE_LABEL_TAG];
    
    NSInteger row = [indexPath row];
    NSDictionary *itemData = [self.customerList objectAtIndex:row];
    
    nameLabel.text = [itemData objectForKey:CUSTOMER_DIC_NAME_KEY];
    phoneLabel.text = [itemData objectForKey:CUSTOMER_DIC_PHONE_KEY];
    
    return cell;
}

- (void)refreshSingleView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerListView:didSelectRow:)]) {
        [self.delegate customerListView:self didSelectRow:row];
    }
}



- (void)DataChange:(NSMutableArray *)itemData
{
    self.customerList = itemData;
}

#pragma mark
#pragma mark - refreshSingleViewDataSource

- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_ROW_HEIGHT;
}
- (NSInteger)refreshSingleView:(RefreshSingleView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.customerList count];
}
- (NSInteger)numberOfSectionsInRefreshSingleView:(RefreshSingleView *)tableView
{
    return 1;
}
@end
