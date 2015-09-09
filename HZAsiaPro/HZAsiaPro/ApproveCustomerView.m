//
//  ApproveCustomerView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/29.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ApproveCustomerView.h"
#import "ComponentsFactory.h"

#define CELL_ROW_HEIGHT                 40.0f

#define CELL_TITLE_LABEL_TAG            101
#define CELL_TYPE_LABEL_TAG             102
#define CELL_APPROVE_BUTTON_BASE_TAG    200

@implementation ApproveCustomerView
@synthesize contentTable;
@synthesize itemList;
@synthesize delegate;

- (void)dealloc
{
    [contentTable release];
    if (itemList != nil) {
        [itemList release];
    }
    if (approves != NULL) {
        free(approves);
    }
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        approves = NULL;
        [self layoutContentView];
    }
    return self;
}

#pragma mark
#pragma mark - 布局视图
- (void)layoutContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    self.contentTable = tableView;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.size.equalTo(self);
    }];
    [tableView release];
}

- (void)reloadDataView:(NSArray *)itemDatas
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:itemDatas
                                                        copyItems:YES];
    self.itemList = items;
    [items release];
    
    if (approves != NULL) {
        free(approves);
    }
    NSInteger cnt = [itemDatas count];
    approves = malloc(sizeof(BOOL)*cnt);
    memset(approves, NO, cnt);
    [self.contentTable reloadData];
}

- (void)resetRowCell:(NSInteger)row
{
    approves[row] = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.contentTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark
#pragma mark - UIAction
- (void)approveClicked:(id)sender
{
    UIButton *clickedBtn = (UIButton *)sender;
    NSInteger index = clickedBtn.tag - CELL_APPROVE_BUTTON_BASE_TAG;
    if (!approves[index]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(approveView:didClickedApprove:)]) {
            [self.delegate approveView:self didClickedApprove:index];
        }
    }
}

#pragma mark
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *approveCell = @"approveCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:approveCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:approveCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = CELL_TITLE_LABEL_TAG;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).with.offset(40);
            make.width.mas_equalTo(70);
        }];
        
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.font = [UIFont systemFontOfSize:14.0f];
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.adjustsFontSizeToFitWidth = YES;
        typeLabel.tag = CELL_TYPE_LABEL_TAG;
        [cell.contentView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(titleLabel.mas_right).with.offset(8);
            make.bottom.equalTo(cell.contentView);
            make.width.mas_equalTo(150);
            
        }];
        
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
        }];
        [seperView release];
        
        [titleLabel release];
        [typeLabel release];
        
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TYPE_LABEL_TAG];
    
    NSInteger row = indexPath.row;
    NSDictionary *data = [self.itemList objectAtIndex:row];
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *userDic = [store getObjectById:CUSTOMER_USER_ID_DIC
                                  fromTable:CUSTOMER_DB_TABLE];
    
    NSString *operator = [[NSString alloc] initWithFormat:@"%ld",[[data objectForKey:@"operator"] longValue]];
    titleLabel.text = [userDic objectForKey:operator];
    
    NSString *typeString = [[NSString alloc] initWithFormat:@"新增%@",[data objectForKey:@"cname"]];
    typeLabel.text = typeString;
    [typeString release];
    
    [store release];
    [operator release];
    
    //布局审批按钮
    UIButton *approveBtn = (UIButton *)[cell.contentView viewWithTag:CELL_APPROVE_BUTTON_BASE_TAG+row];
    if (approveBtn != nil) {
        [approveBtn removeFromSuperview];
        approveBtn = nil;
    }
    approveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    approveBtn.backgroundColor = [UIColor clearColor];
    [approveBtn setBackgroundImage:[[UIImage imageNamed:@"new_user_picker_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                          forState:UIControlStateNormal];
    approveBtn.tag = CELL_APPROVE_BUTTON_BASE_TAG+row;
    if (approves[row]) {
        [approveBtn setTitle:@"已审批" forState:UIControlStateNormal];
    }else{
        [approveBtn setTitle:@"审批" forState:UIControlStateNormal];
    }
    [approveBtn addTarget:self
                   action:@selector(approveClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [approveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.contentView addSubview:approveBtn];
    [approveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_right).with.offset(-80);
        make.right.equalTo(cell.contentView).with.offset(-10);
        make.centerY.equalTo(cell.contentView);
        make.height.mas_equalTo(60/2.0f);
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, 20.0f)] autorelease];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"th.png"]];
    
    UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 50, 20.0f)];
    personLabel.textColor =[UIColor whiteColor];
    personLabel.textAlignment = NSTextAlignmentCenter;
    personLabel.font = [UIFont boldSystemFontOfSize:13.5];
    personLabel.backgroundColor = [UIColor clearColor];
    personLabel.text = @"业务员";
    [headerView addSubview:personLabel];
    [personLabel release];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 0, 60, 20.0f)];
    typeLabel.textColor =[UIColor whiteColor];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.font = [UIFont boldSystemFontOfSize:13.5];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.text = @"业务类型";
    [headerView addSubview:typeLabel];
    [typeLabel release];

    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //跟进业务类型查看修改内容
    NSInteger row = indexPath.row;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(approveView:didShowApproveDetail:)]) {
        [self.delegate approveView:self didShowApproveDetail:row];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = indexPath.row;
        [self.itemList removeObjectAtIndex:row];
        [self.contentTable reloadData];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(approveView:didDeleteApprove:)]) {
            [self.delegate approveView:self didDeleteApprove:row];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_ROW_HEIGHT;
}

@end
