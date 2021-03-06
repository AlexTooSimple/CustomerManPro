//
//  AutoCustomVC.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/9.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "AutoCustomVC.h"
#import "ManageView.h"
#import "UserDetailViewController.h"
#import "DetailInfoVC.h"
#import "SalesmanSelectVC.h"

@interface AutoCustomVC ()

@property (nonatomic,strong)ManageView *kehu;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layOutKehu {
    self.kehu = [[ManageView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT-64)];
    [self.view addSubview:self.kehu];
    self.kehu.tapBlk = ^(NSIndexPath *index){
        NSLog(@"点击了第%@行",self.kehu);
//        DetailInfoVC *detail = [[DetailInfoVC alloc] init];
//        detail.detailType = allInfoType;
//        detail.isFromApprove = NO;
//        NSMutableDictionary *MDic = [NSMutableDictionary dictionaryWithDictionary:[self.kehu.searchMArr objectAtIndex:index.row]];
//        detail.customerInfo = MDic;
//        [self.navigationController pushViewController:detail animated:YES];
//        [detail release];
    };

    self.kehu.btnTapBlk = ^(SalesmanSelectVC *saleVC){
        saleVC.tapBlk = ^(id sender){
            [self searchSimpleCustomer];
        };
        [self.navigationController pushViewController:saleVC animated:YES];
    };
    [self searchSimpleCustomer];
}

- (void)searchSimpleCustomer
{
//    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
//    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
//                                       fromTable:CUSTOMER_DB_TABLE];
//    
    NSMutableDictionary *searchCondition = [[NSMutableDictionary alloc] initWithCapacity:0];
//    NSString *operatorCode = [usrInfo objectForKey:@"code"];
    [searchCondition setObject:@"100000"
                        forKey:@"operator"];
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService searchCustomerListWithCondition:searchCondition];
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    NSString *errorCode = [info objectForKey:@"errorCode"];
    if([[SearchCustomerWithConditionMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            NSString *data = [rspInfo objectForKey:@"data"];
            
            NSArray *rspCustomerList = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
            [self.kehu.tabMArr  setArray:rspCustomerList];
            [self.kehu reloadView];
        }else{
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                         message:msg
                                                                        delegate:self
                                                                             tag:0
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
}

- (void)requestFailed:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    if([[SearchCustomerWithConditionMessage getBizCode] isEqualToString:bussineCode]){
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:msg
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark
#pragma mark - AlertShowViewDelegate
- (void)alertViewWillPresent:(UIAlertController *)alertController
{
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma mark
#pragma mark -  取消显示Alert
- (void)cancelAlterTimer:(NSTimer *)timer
{
    AlertShowView *alter = (AlertShowView *)[timer userInfo];
    [alter dismiss];
}

@end
