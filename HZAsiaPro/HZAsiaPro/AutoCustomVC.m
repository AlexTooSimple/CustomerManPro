//
//  AutoCustomVC.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "AutoCustomVC.h"
#import "KehuView.h"
#import "UserDetailViewController.h"
#import "DetailInfoVC.h"

@interface AutoCustomVC ()

@property (nonatomic,strong)KehuView *kehu;

@end

@implementation AutoCustomVC

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
    self.title = @"客户池管理";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layOutKehu];
    // Do any additional setup after loading the view.
}

- (void)layOutKehu {
    self.kehu = [[KehuView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT-64)];
    [self.view addSubview:self.kehu];
    self.kehu.tapBlk = ^(NSIndexPath *index){
        DetailInfoVC *detail = [[DetailInfoVC alloc] init];
        detail.detailType = allInfoType;
        detail.isFromApprove = NO;
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    };

    [self setUpdata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpdata{
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
    [tabMArr1 addObject:dic51];
    [tabMArr1 addObject:dic51];
    [tabMArr1 addObject:dic51];
    self.kehu.tabMArr = tabMArr1;
    [self.kehu reloadView];
    [tabMArr1 release];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
