//
//  ShowRepeatClientVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ShowRepeatClientVC.h"
#import "DetailInfoVC.h"
#import "AddCustomerVC.h"

#define CELL_NAME_LABEL_TAG         121
#define CELL_PHONE_LABEL_TAG        122

#define CELL_ROW_HEIGHT             44.0f


@interface ShowRepeatClientVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentTable;
}
@property (nonatomic ,retain)UITableView *contentTable;
@end

@implementation ShowRepeatClientVC

@synthesize newClientInfo;
@synthesize contentTable;
@synthesize repeatClientList;

- (void)dealloc
{
    if (repeatClientList != nil) {
        [repeatClientList release];
    }
    if (newClientInfo != nil) {
        [newClientInfo release];
    }
    [contentTable release];
    [super dealloc];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重复客户";
    
    [self setNavBarnewUserItem];
    
    [self layoutContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutContentView
{
    //布局提示
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.numberOfLines = 0;
    promptLabel.lineBreakMode = NSLineBreakByCharWrapping;
    promptLabel.font = [UIFont systemFontOfSize:15.0f];
    promptLabel.text = @"下表为和您新增的客户同名（或同电话）的客户列表，为避免资料重复，请查看下列客户中是否包括您新增的客户，如果包括，则点击该客户信息，进入详细信息后点击修改，选择登记联系信息，进行纪录；如果不包括，则选择“新建”完成客户信息的登记。";
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(54);
        make.left.equalTo(self.view).with.offset(8);
        make.right.equalTo(self.view).with.offset(-8);
        make.height.mas_equalTo(150);
    }];
    
    //布局客户列表
    UIView *upSeperView = [[UIView alloc] initWithFrame:CGRectZero];
    upSeperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
    [self.view addSubview:upSeperView];
    [upSeperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).with.offset(18);
        make.left.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(1.0f);
    }];
    [upSeperView release];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTable = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptLabel.mas_bottom).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-46);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [tableView release];
    [promptLabel release];
}


- (void)setNavBarnewUserItem
{
    UIBarButtonItem *newUserItem = [[UIBarButtonItem alloc] initWithTitle:@"新建"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(setUpNewUserClicked:)];
    self.navigationItem.rightBarButtonItem = newUserItem;
    [newUserItem release];
}

- (void)setUpNewUserClicked:(id)sender
{
    AddCustomerVC *VC = [[AddCustomerVC alloc] init];
    VC.customerInsertInfo = newClientInfo;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}


#pragma mark
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repeatClientList count];
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
    return CELL_ROW_HEIGHT;
}

#pragma mark
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        
        
        [iconView release];
        [nameLabel release];
        [phoneLabel release];
        
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
    NSDictionary *itemData = [self.repeatClientList objectAtIndex:row];
    
    
    if ([itemData objectForKey:@"cname"] != nil && ![[itemData objectForKey:@"cname"] isEqual:[NSNull null]]) {
        nameLabel.text = [itemData objectForKey:@"cname"];
    }
    
    if ([itemData objectForKey:@"mobile"] != nil && ![[itemData objectForKey:@"mobile"] isEqual:[NSNull null]]) {
        phoneLabel.text = [itemData objectForKey:@"mobile"];
    }else{
        if ([itemData objectForKey:@"firstPhone"] != nil && ![[itemData objectForKey:@"firstPhone"] isEqual:[NSNull null]]) {
            phoneLabel.text = [itemData objectForKey:@"firstPhone"];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectCustomer = [self.repeatClientList objectAtIndex:indexPath.row];
    
    DetailInfoVC *VC = [[DetailInfoVC alloc] init];
    VC.detailType = allInfoType;
    VC.customerInfo = selectCustomer;
    VC.isFromApprove = NO;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectCustomer = [self.repeatClientList objectAtIndex:indexPath.row];
    
    DetailInfoVC *VC = [[DetailInfoVC alloc] init];
    VC.detailType = allInfoType;
    VC.customerInfo = selectCustomer;
    VC.isFromApprove = NO;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];

}
@end
