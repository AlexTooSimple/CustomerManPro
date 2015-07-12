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
#import "DetailInfoVC.h"

@interface HomeInfoVC ()<UIScrollViewDelegate>

@property(nonatomic,strong)UserView *userV;
@property(nonatomic,strong)UIScrollView *scvHome;
@property(nonatomic,strong)UIPageControl *page;
@property(nonatomic,strong)KehuView *kehuNoCall;
//@property(nonatomic,strong)KehuView *kehuTimeUp;
@property(nonatomic,strong)NSMutableArray *titleMArr;

@end

@implementation HomeInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpView];
}

- (void)setUpView {
    [self.titleMArr removeAllObjects];
    CGFloat width = 0.0;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo] boolValue]){
        self.userV.hidden = NO;
        self.userV.frame = CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvHome.bounds));
        width += DEVICE_MAINSCREEN_WIDTH;
        [self.titleMArr addObject:@"首页"];
    } else {
        self.userV.hidden = YES;
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:Nocontent] boolValue]){
        self.kehuNoCall.hidden = NO;
        self.kehuNoCall.frame = CGRectMake(width, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvHome.bounds));
        width += DEVICE_MAINSCREEN_WIDTH;
        [self.titleMArr addObject:@"未联系客户"];
    } else {
        self.kehuNoCall.hidden = YES;
    }
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:TimeUp] boolValue]){
//        self.kehuTimeUp.hidden = NO;
//        self.kehuTimeUp.frame = CGRectMake(width, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvHome.bounds));
//        width += DEVICE_MAINSCREEN_WIDTH;
//        [self.titleMArr addObject:@"到期客户"];
//    } else {
//        self.kehuTimeUp.hidden = YES;
//    }
    self.scvHome.contentSize = CGSizeMake(width, DEVICE_MAINSCREEN_HEIGHT-64-50);
    self.page.numberOfPages = width/DEVICE_MAINSCREEN_WIDTH;
    if(self.page.numberOfPages == 1){
        self.page.hidden = YES;
    } else {
        self.page.hidden = NO;
    }
    [self setUpdata];
}

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
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    //用户信息
    NSDictionary *userInfoSource = [store getObjectById:CUSTOMER_USERINFO
                                            fromTable:CUSTOMER_DB_TABLE];

    self.userV.tabMDic = [NSMutableDictionary dictionaryWithDictionary:userInfoSource];
    [self.userV reloadView];
    
    //未联系客户
    NSArray *contactTypeSource = [store getObjectById:CUSTOMER_NONECONNECT_LIST
                                            fromTable:CUSTOMER_DB_TABLE];

    self.kehuNoCall.tabMArr = [NSMutableArray arrayWithArray:contactTypeSource];
//    self.kehuTimeUp.tabMArr = [NSMutableArray arrayWithArray:contactTypeSource];
    [self.kehuNoCall reloadView];
//    [self.kehuTimeUp reloadView];
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
    self.kehuNoCall.tbvHome.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.scvHome addSubview:self.kehuNoCall];
    
    self.kehuNoCall.tapBlk = ^(NSIndexPath *index){
        DetailInfoVC *detail = [[DetailInfoVC alloc] init];
        detail.detailType = allInfoType;
        detail.isFromApprove = NO;
        NSMutableDictionary *MDic = [NSMutableDictionary dictionaryWithDictionary:[self.kehuNoCall.searchMArr objectAtIndex:index.row]];
        [MDic setObject:[[self.kehuNoCall.searchMArr objectAtIndex:index.row] objectForKey:@"client_code"] forKey:@"clientCode"];
        detail.customerInfo = MDic;
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    };
    
//    self.kehuTimeUp = [[KehuView alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH*2, 0, DEVICE_MAINSCREEN_WIDTH, CGRectGetHeight(self.scvHome.bounds))];
//    self.kehuTimeUp.tbvHome.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//    [self.scvHome addSubview:self.kehuTimeUp];
//    self.kehuTimeUp.tapBlk = ^(NSIndexPath *index){
//        DetailInfoVC *detail = [[DetailInfoVC alloc] init];
//        detail.detailType = allInfoType;
//        detail.isFromApprove = NO;
//        [self.navigationController pushViewController:detail animated:YES];
//        [detail release];
//    };
    [self setUpdata];
    
    
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH *1/6, DEVICE_MAINSCREEN_HEIGHT - 50 -30, DEVICE_MAINSCREEN_WIDTH * 2/3, 30)];
    self.page.backgroundColor = [UIColor clearColor];
    self.page.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.page.pageIndicatorTintColor = [UIColor grayColor];
    self.page.numberOfPages = 2;
    [self.view addSubview:self.page];
    
    self.titleMArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self.titleMArr setArray:@[@"首页",@"未联系客户",@"到期客户"]];
}

- (void)dealloc {
    [self.userV release];
    [self.scvHome release];
    [self.titleMArr release];
    [self.page release];
    [self.kehuNoCall release];
//    [self.kehuTimeUp release];
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
        self.navigationItem.title = [self.titleMArr objectAtIndex:page1];
        switch (page1) {
            case 0:{
                [self.kehuNoCall.scbHome resignFirstResponder];
//                [self.kehuTimeUp.scbHome resignFirstResponder];
                break;
            }
            case 1:{
//                [self.kehuTimeUp.scbHome resignFirstResponder];
                break;
            }
            case 2:{
                [self.kehuNoCall.scbHome resignFirstResponder];
                break;
            }
            default:
                break;
        }
    }
}

@end
