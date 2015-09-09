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
#define CELL_COUNT_LABEL_TAG        124
#define HEADER_COUNT_LABEL_TAG      123


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
        selectRow = -1;
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
    [singleView addTableViewHeader];
    self.contentTable = singleView;
    [self addSubview:singleView];
    
    self.contentTable.contentTable.separatorColor = [UIColor clearColor];
    self.contentTable.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //self.contentTable.contentTable.tableHeaderView = [self layoutContentTableHeader];
    
    [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    [singleView release];
}

- (void)reloadData:(NSArray *)itemData WithCount:(NSString *)itemCount
{
    selectRow = -1;
    [self.contentTable resetViewDataStream];
    [self.contentTable reloadViewData:itemData];
    
//    UILabel *countLable = (UILabel *)[[self.contentTable.contentTable tableHeaderView] viewWithTag:HEADER_COUNT_LABEL_TAG];
//    countLable.text = [NSString stringWithFormat:@"共有位%@客户",itemCount];
    [self.contentTable endRefresh];
}

- (UIView *)layoutContentTableHeader
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, 44)] autorelease];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *countLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, 44)];
    countLable.backgroundColor = [UIColor clearColor];
    countLable.textAlignment = NSTextAlignmentCenter;
    countLable.tag = HEADER_COUNT_LABEL_TAG;
    countLable.font = [UIFont systemFontOfSize:28.0f];
    countLable.textColor = [UIColor blackColor];
    countLable.contentMode = UIViewContentModeCenter;
    [headerView addSubview:countLable];
    [countLable release];
    
    return headerView;
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
        
        UIImageView *countImageView = [[UIImageView alloc] init];
        countImageView.backgroundColor = [UIColor clearColor];
        countImageView.image = [[UIImage imageNamed:@"corner.png"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:10.0f];
        [cell.contentView addSubview:countImageView];
        [countImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(25.0f, 25.0f));
        }];
       
        
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.textAlignment = NSTextAlignmentLeft;
        countLabel.textColor = [UIColor blackColor];
        countLabel.contentMode = UIViewContentModeCenter;
        countLabel.font = [UIFont systemFontOfSize:8.0f];
        countLabel.tag = CELL_COUNT_LABEL_TAG;
        [cell.contentView addSubview:countLabel];
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(countImageView);
        }];
        
        [countLabel release];
        [countImageView release];
        
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
        arrowView.image = [UIImage imageNamed:@"tools_call.png"];
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
            make.right.equalTo(cell.contentView).with.offset(-40.0f);
        }];
        
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(phoneLabel.mas_right).with.offset(3.0f);
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
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
    UILabel *countLabel = (UILabel *)[cell.contentView viewWithTag:CELL_COUNT_LABEL_TAG];
    
    
    NSInteger row = [indexPath row];
    
    countLabel.text = [NSString stringWithFormat:@"%ld",row+1];
    NSDictionary *itemData = [self.customerList objectAtIndex:row];
    

    if ([itemData objectForKey:CUSTOMER_DIC_NAME_KEY] != nil && ![[itemData objectForKey:CUSTOMER_DIC_NAME_KEY] isEqual:[NSNull null]]) {
        nameLabel.text = [itemData objectForKey:CUSTOMER_DIC_NAME_KEY];
    }
    
    if ([itemData objectForKey:CUSTOMER_DIC_PHONE_KEY] != nil && ![[itemData objectForKey:CUSTOMER_DIC_PHONE_KEY] isEqual:[NSNull null]]) {
        phoneLabel.text = [itemData objectForKey:CUSTOMER_DIC_PHONE_KEY];
    }
    
    NSString *created = [itemData objectForKey:@"created"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  senddate= [NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:created];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
    
    int days = ((int)time)/(3600*24);
    if (days >= -7) {
        nameLabel.textColor = [ComponentsFactory createColorByHex:@"#FF8000"];
        phoneLabel.textColor = [ComponentsFactory createColorByHex:@"#FF8000"];
    }else{
        nameLabel.textColor = [UIColor blackColor];
        phoneLabel.textColor = [UIColor blackColor];
    }
    return cell;
}


- (void)refreshSingleView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectRow = indexPath.row;
    ActionSheetView *sheet = [[ActionSheetView alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"拨打电话"
                                                  otherButtonTitles:@"发送短信",nil];
    [sheet show];
}

- (void)refreshSingleView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
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

- (void)upHeaderRefreshData
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerWillRefresh)]) {
        [self.delegate customerWillRefresh];
    }
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

#pragma mark
#pragma mark - ActionSheetViewDelegate
- (void)actionSheetView:(ActionSheetView *)sheetView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //拨打电话
            UIWebView *callWebView = [[UIWebView alloc] init];
            NSString *phone = [[self.customerList objectAtIndex:selectRow] objectForKey:CUSTOMER_DIC_PHONE_KEY];
            NSString *telStr = [[NSString alloc] initWithFormat:@"tel:%@",phone];
            NSURL *telURL = [NSURL URLWithString:telStr];
            [telStr release];
            
            [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
            
        }
            break;
        case 1:
        {
            //发送短信
            NSString *phone = [[self.customerList objectAtIndex:selectRow] objectForKey:CUSTOMER_DIC_PHONE_KEY];
            NSArray *phones = [[NSArray alloc] initWithObjects:phone, nil];
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerDidSendSMS:)]) {
                [self.delegate customerDidSendSMS:phones];
            }
            [phones release];
        }
            break;
        default:
            break;
    }
}

- (void)actionSheetViewWillPresent:(UIAlertController *)alertController
{
    UIViewController  *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentVC presentViewController:alertController
                            animated:YES
                          completion:nil];
}


#pragma mark
#pragma mark -

@end
