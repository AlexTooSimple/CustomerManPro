//
//  HomeInfoVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/8.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "HomeInfoVC.h"
#import "UserView.h"
#import "KehuView.h"

@interface HomeInfoVC ()<UIScrollViewDelegate>

@property(nonatomic,strong)UserView *userV;
@property(nonatomic,strong)UIScrollView *scvHome;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)KehuView *kehuNoCall;
@property(nonatomic,strong)KehuView *kehuTimeUp;

@end

@implementation HomeInfoVC

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor clearColor];
    self.view = rootView;
    [rootView release];
    self.title = @"首页";
}

- (void)setUpdata{
    NSMutableArray *tabMArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *dic1 = @{@"name":@"姓名：",@"source":@"张三"};
    NSDictionary *dic2 = @{@"name":@"性别：",@"source":@"男"};
    NSDictionary *dic3 = @{@"name":@"职位：",@"source":@"业务员"};
    NSDictionary *dic4 = @{@"name":@"手机号码：",@"source":@"13678898765"};
    NSDictionary *dic5 = @{@"name":@"工号：",@"source":@"123456"};
    [tabMArr addObject:dic1];
    [tabMArr addObject:dic2];
    [tabMArr addObject:dic3];
    [tabMArr addObject:dic4];
    [tabMArr addObject:dic5];
    self.userV.tabMArr = tabMArr;
    [tabMArr release];
    [self.userV reloadView];
    
    NSMutableArray *tabMArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *dic11 = @{@"name":@"张三",@"source":@"13656687678"};
    NSDictionary *dic21 = @{@"name":@"李四",@"source":@"13656687679"};
    NSDictionary *dic31 = @{@"name":@"王五",@"source":@"13656687677"};
    NSDictionary *dic41 = @{@"name":@"赵六",@"source":@"13678898765"};
    NSDictionary *dic51 = @{@"name":@"李七",@"source":@"13656687676"};
    [tabMArr1 addObject:dic11];
    [tabMArr1 addObject:dic21];
    [tabMArr1 addObject:dic31];
    [tabMArr1 addObject:dic41];
    [tabMArr1 addObject:dic51];
    [tabMArr1 addObject:dic51];
    [tabMArr1 addObject:dic51];
    [tabMArr1 addObject:dic51];
    [tabMArr1 addObject:dic51];
    [tabMArr1 addObject:dic51];
    self.kehuNoCall.tabMArr = tabMArr1;
    self.kehuTimeUp.tabMArr = tabMArr1;
    [self.kehuNoCall reloadView];
    [self.kehuTimeUp reloadView];
    [tabMArr1 release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layOutScv];
}

- (void)layOutScv {
    self.scvHome = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT)];
    self.scvHome.delegate = self;
    self.scvHome.pagingEnabled = YES;
    self.scvHome.backgroundColor = [UIColor clearColor];
    self.scvHome.showsHorizontalScrollIndicator = NO;
    self.scvHome.contentSize = CGSizeMake(DEVICE_MAINSCREEN_WIDTH*3, DEVICE_MAINSCREEN_HEIGHT-64-50);
    [self.view addSubview:self.scvHome];
    
    self.userV = [[UserView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvHome.bounds))];
    [self.scvHome addSubview:self.userV];
    
    self.kehuNoCall = [[KehuView alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvHome.bounds))];
    [self.scvHome addSubview:self.kehuNoCall];
    
    self.kehuTimeUp = [[KehuView alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH*2, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvHome.bounds))];
    [self.scvHome addSubview:self.kehuTimeUp];
    [self setUpdata];
    
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH *1/6, DEVICE_MAINSCREEN_HEIGHT - 50 -30, DEVICE_MAINSCREEN_WIDTH * 2/3, 30)];
    self.page.backgroundColor = [UIColor clearColor];
    self.page.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.page.pageIndicatorTintColor = [UIColor grayColor];
    self.page.numberOfPages = 3;
    [self.view addSubview:self.page];
}

- (void)dealloc {
    [self.userV release];
    [self.scvHome release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scvHome){
        CGFloat pageWidth = scrollView.frame.size.width;
        int page1 = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.page.currentPage = page1;
        switch (page1) {
            case 0:{
                self.navigationItem.title = @"首页";
                [self.kehuNoCall.scbHome resignFirstResponder];
                [self.kehuTimeUp.scbHome resignFirstResponder];
                break;
            }
            case 1:{
                self.navigationItem.title = @"未联系客户";
                [self.kehuTimeUp.scbHome resignFirstResponder];
                break;
            }
            case 2:{
                self.navigationItem.title = @"到期客户";
                [self.kehuNoCall.scbHome resignFirstResponder];
                break;
            }
            default:
                break;
        }
    }
}

@end
