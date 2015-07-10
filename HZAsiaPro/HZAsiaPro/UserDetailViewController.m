//
//  UserDetailViewController.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "UserDetailViewController.h"
#import "BaseTabView.h"

@interface UserDetailViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scvManager;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)BaseTabView *baseTab;
@property(nonatomic,strong)BaseTabView *comandTab;

@end

@implementation UserDetailViewController

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
    self.title = @"客户详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self layOutScv];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layOutScv {
    self.scvManager = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT)];
    self.scvManager.delegate = self;
    self.scvManager.pagingEnabled = YES;
    self.scvManager.backgroundColor = [UIColor clearColor];
    self.scvManager.showsHorizontalScrollIndicator = NO;
    self.scvManager.contentSize = CGSizeMake(DEVICE_MAINSCREEN_WIDTH*2, DEVICE_MAINSCREEN_HEIGHT-64);
    [self.view addSubview:self.scvManager];
    
    self.baseTab = [[BaseTabView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvManager.bounds))];
    [self.scvManager addSubview:self.baseTab];
    
    self.comandTab = [[BaseTabView alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvManager.bounds))];
    [self.scvManager addSubview:self.comandTab];
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH *1/6, DEVICE_MAINSCREEN_HEIGHT  -30, DEVICE_MAINSCREEN_WIDTH * 2/3, 30)];
    self.page.backgroundColor = [UIColor clearColor];
    self.page.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.page.pageIndicatorTintColor = [UIColor grayColor];
    self.page.numberOfPages = 2;
    [self.view addSubview:self.page];
}

//- (void)setUpdata{
//    NSMutableArray *tabMArr = [[NSMutableArray alloc] initWithCapacity:0];
//    NSDictionary *dic1 = @{@"name":@"客户姓名",@"source":@"张三"};
//    NSDictionary *dic2 = @{@"name":@"移动电话",@"source":@"男"};
//    NSDictionary *dic3 = @{@"name":@"客户状态",@"source":@"业务员"};
//    NSDictionary *dic4 = @{@"name":@"缩写",@"source":@"13678898765"};
//    NSDictionary *dic5 = @{@"name":@"英文名",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"原始姓名",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"原始电话",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"证件类型",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"证件号码",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"出生日期",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"国籍",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"区域",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"职业",@"source":@"123456"};
//    NSDictionary *dic5 = @{@"name":@"公司",@"source":@"123456"};
//    [tabMArr addObject:dic1];
//    [tabMArr addObject:dic2];
//    [tabMArr addObject:dic3];
//    [tabMArr addObject:dic4];
//    [tabMArr addObject:dic5];
//    self.userV.tabMArr = tabMArr;
//    [tabMArr release];
//    [self.userV reloadView];
//    
//    NSMutableArray *tabMArr1 = [[NSMutableArray alloc] initWithCapacity:0];
//    NSDictionary *dic11 = @{@"name":@"张三",@"source":@"13656687678"};
//    NSDictionary *dic21 = @{@"name":@"李四",@"source":@"13656687679"};
//    NSDictionary *dic31 = @{@"name":@"王五",@"source":@"13656687677"};
//    NSDictionary *dic41 = @{@"name":@"赵六",@"source":@"13678898765"};
//    NSDictionary *dic51 = @{@"name":@"李七",@"source":@"13656687676"};
//    [tabMArr1 addObject:dic11];
//    [tabMArr1 addObject:dic21];
//    [tabMArr1 addObject:dic31];
//    [tabMArr1 addObject:dic41];
//    [tabMArr1 addObject:dic51];
//    [tabMArr1 addObject:dic51];
//    [tabMArr1 addObject:dic51];
//    [tabMArr1 addObject:dic51];
//    [tabMArr1 addObject:dic51];
//    [tabMArr1 addObject:dic51];
//    self.kehuNoCall.tabMArr = tabMArr1;
//    self.kehuTimeUp.tabMArr = tabMArr1;
//    [self.kehuNoCall reloadView];
//    [self.kehuTimeUp reloadView];
//    [tabMArr1 release];
//}


#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scvManager){
        CGFloat pageWidth = scrollView.frame.size.width;
        int page1 = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.page.currentPage = page1;
    }
}


@end
