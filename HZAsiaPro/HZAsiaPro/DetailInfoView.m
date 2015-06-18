//
//  DetailInfoView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "DetailInfoView.h"
#import "ComponentsFactory.h"

#define CELL_ROW_HEIGHT                 44.0f

#define CELL_ROW_TITLW_LABEL_TAG        101
#define CELL_ROW_VALUE_LABEL_TAG        102
#define CELL_ROW_SEPER_VIEW_TAG         103


@implementation DetailInfoView

@synthesize contentTable;
@synthesize itemDatas;

- (void)dealloc
{
    [contentTable release];
    [itemDatas release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pagingEnabled = NO;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    self.contentTable = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.size.equalTo(self);
    }];
    [tableView release];
    
    [self layoutContentTableHeader];
}


- (void)reloadViewData:(NSArray *)itemList
{
    self.itemDatas = itemList;
    [self.contentTable reloadData];
}

- (void)layoutContentTableHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, 20.0f)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"th.png"]];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, DEVICE_MAINSCREEN_WIDTH, 20.0f)];
    label1.textColor =[UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont boldSystemFontOfSize:13.5];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"客户基本信息";
    label1.shadowColor = [UIColor blackColor];
    label1.shadowOffset = CGSizeMake(0.5,0.5);
    label1.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label1];
    [label1 release];
    
    self.contentTable.tableHeaderView = headerView;
    [headerView release];
}


#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemDatas count];
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
    NSInteger row = indexPath.row;
    CGFloat cellHeight = CELL_ROW_HEIGHT;
    NSDictionary *data = [self.itemDatas objectAtIndex:row];
    
    NSString *textStr = [data objectForKey:DATA_SHOW_VALUE_COLUM];
    
    
    NSDictionary *attribute = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [UIFont systemFontOfSize:15.0f],NSFontAttributeName,nil];
    CGFloat height = DEVICE_MAINSCREEN_WIDTH/2-10.0f+30.0f;
    CGRect rect = [textStr boundingRectWithSize:CGSizeMake(height, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attribute
                                       context:nil];
    [attribute release];
    if (rect.size.height > CELL_ROW_HEIGHT) {
        cellHeight = rect.size.height+10;
    }

    return cellHeight;
}
#pragma mark
#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)] autorelease];
//    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"th.png"]];
//        
//    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-15, 20)];
//    label1.textColor =[UIColor whiteColor];
//    label1.textAlignment = NSTextAlignmentLeft;
//    label1.font = [UIFont boldSystemFontOfSize:13.5];
//    label1.backgroundColor = [UIColor clearColor];
//    label1.text = @"客户基本信息";
//    label1.shadowColor = [UIColor blackColor];
//    label1.shadowOffset = CGSizeMake(0.5,0.5);
//    label1.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:label1];
//    [label1 release];
//    
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailInfoCell = @"detailInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:detailInfoCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.tag = CELL_ROW_TITLW_LABEL_TAG;
        [cell.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).with.offset(15.0f);
            make.right.equalTo(cell.contentView.mas_centerX).with.offset(-50.0f);
            make.bottom.equalTo(cell.contentView.mas_top).with.offset(CELL_ROW_HEIGHT);
        }];
        [titleLabel release];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.numberOfLines = 0;
        valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        valueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        valueLabel.contentMode = UIViewContentModeCenter;
        valueLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.font = [UIFont systemFontOfSize:15.0f];
        valueLabel.textColor = [UIColor grayColor];
        valueLabel.tag = CELL_ROW_VALUE_LABEL_TAG;
        [cell.contentView addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_centerX).with.offset(-30.0f);
            make.top.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
        }];
        [valueLabel release];
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        seperView.tag = CELL_ROW_SEPER_VIEW_TAG;
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
        }];
        [seperView release];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_ROW_TITLW_LABEL_TAG];
    UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:CELL_ROW_VALUE_LABEL_TAG];
    UIView *seperView = (UIView *)[cell.contentView viewWithTag:CELL_ROW_SEPER_VIEW_TAG];
    
    NSInteger row = indexPath.row;
    NSDictionary *data = [self.itemDatas objectAtIndex:row];
    
    titleLabel.text = [data objectForKey:DATA_SHOW_TITLE_COLUM];
    if ([data objectForKey:DATA_SHOW_VALUE_COLUM] == nil ||
        [[data objectForKey:DATA_SHOW_VALUE_COLUM] isEqual:[NSNull null]] ||
        [[data objectForKey:DATA_SHOW_VALUE_COLUM] isEqualToString:@""]) {
        valueLabel.text = @"无";
    }else{
        valueLabel.text = [data objectForKey:DATA_SHOW_VALUE_COLUM];
    }
    
    NSString *textStr = [data objectForKey:DATA_SHOW_VALUE_COLUM];
    
    
    NSDictionary *attribute = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [UIFont systemFontOfSize:15.0f],NSFontAttributeName,nil];
    CGFloat height = DEVICE_MAINSCREEN_WIDTH/2-10.0f+30.0f;
    CGRect rect = [textStr boundingRectWithSize:CGSizeMake(height, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine
                                     attributes:attribute
                                        context:nil];
    [attribute release];
    if (rect.size.height > CELL_ROW_HEIGHT) {
        [seperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake((rect.size.height+10-1), 0, 0, 0));
        }];
    }else{
        [seperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
        }];
    }
    return cell;
}


@end
