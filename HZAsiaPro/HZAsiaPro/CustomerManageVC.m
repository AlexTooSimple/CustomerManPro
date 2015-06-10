//
//  CustomerManageVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/8.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "CustomerManageVC.h"
#import "CustomerListView.h"

@interface CustomerManageVC ()<CustomerListViewDelegate>
@property (nonatomic, retain)CustomerListView *customerView;
@property (nonatomic, retain)NSArray *customerDataList;
@end

@implementation CustomerManageVC

@synthesize customerView;
@synthesize customerDataList;

- (void)dealloc
{
    [customerView release];
    [customerDataList release];
    
    [super dealloc];
}
- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor clearColor];
    self.view = rootView;
    [rootView release];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"客户管理";
    
    CustomerListView *listView = [[CustomerListView alloc] init];
    listView.backgroundColor = [UIColor whiteColor];
    self.customerView = listView;
    [self.view addSubview:customerView];
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    [customerView release];
    
    [self initData];
    [self.customerView reloadData:self.customerDataList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    NSDictionary *row1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row7 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row8 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row9 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row10 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row11 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"张三",CUSTOMER_DIC_NAME_KEY,
                          @"13746232132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSDictionary *row12 = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"李四",CUSTOMER_DIC_NAME_KEY,
                          @"15212332132",CUSTOMER_DIC_PHONE_KEY, nil];
    NSArray *itemList = [[NSArray alloc] initWithObjects:
                         row1,
                         row2,
                         row3,
                         row4,
                         row5,
                         row6,
                         row7,
                         row8,
                         row9,
                         row10,
                         row11,
                         row12,
                         nil];
    self.customerDataList = itemList;
    [itemList release];
    [row1 release];
    [row2 release];
    [row3 release];
    [row4 release];
    [row5 release];
    [row6 release];
    [row7 release];
    [row8 release];
    [row9 release];
    [row10 release];
    [row11 release];
    [row12 release];
}

#pragma mark
#pragma mark - CustomerListViewDelegate
- (void)customerListView:(CustomerListView *)listView didSelectRow:(NSInteger)row
{

}


@end
