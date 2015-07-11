//
//  LoginVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"
#import "bussineDataService.h"
#import "PureLayout.h"
#import "AppDelegate.h"
#import "YTKKeyValueStore.h"

@interface LoginVC ()<LoginViewDelegate,HttpBackDelegate,AlertShowViewDelegate>

@end

@implementation LoginVC

- (void)loadView
{
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:mainFrame];
    rootView.backgroundColor = [UIColor clearColor];
    self.view = rootView;
    [rootView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LoginView *loginView = [[LoginView alloc] initForAutoLayout];
    loginView.delegate = self;
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    
    [loginView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [loginView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma mark - 存取数据
- (void)initCustomerUserInfo:(NSDictionary *)data
{
    NSString *tableName = CUSTOMER_DB_TABLE;
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    [store createTableWithName:tableName];
    
    [store putObject:data
              withId:CUSTOMER_USERINFO
           intoTable:tableName];
    [store release];
}

- (void)initCustomerStaticData:(NSDictionary *)data
{
    NSString *tableName = CUSTOMER_DB_TABLE;
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    [store createTableWithName:tableName];
    
    NSDictionary *vistData  = [data objectForKey:@"访问类型"];
    NSArray *visitArray = [self assembData:vistData];
    [store putObject:visitArray
              withId:CUSTOMER_VISIT_TYPE_LIST
           intoTable:tableName];
    
    NSDictionary *saleCondition  = [data objectForKey:@"销售情况"];
    NSArray *saleConditionArray = [self assembData:saleCondition];
    [store putObject:saleConditionArray
              withId:CUSTOMER_SALE_CONDITION_LIST
           intoTable:tableName];
    
    NSDictionary *clientType  = [data objectForKey:@"客户类型"];
    NSArray *clientTypeArray = [self assembData:clientType];
    [store putObject:clientTypeArray
              withId:CUSTOMER_SALE_CONDITION_LIST
           intoTable:tableName];
    
    NSDictionary *purpose  = [data objectForKey:@"购买意向"];
    NSArray *purposeArray = [self assembData:purpose];
    [store putObject:purposeArray
              withId:CUSTOMER_PURPOSE_LIST
           intoTable:tableName];
    
    NSDictionary *progress = [data objectForKey:@"进展阶段"];
    [store putObject:progress
              withId:CUSTOMER_JINZHAN_JIEDUAN_DIC
           intoTable:tableName];
    
    NSArray *progressArray = [self assembData:progress];
    [store putObject:progressArray
              withId:CUSTOMER_JINZHAN_JIEDUAN_LIST
           intoTable:tableName];
    
    NSDictionary *idType = [data objectForKey:@"证件类型"];
    [store putObject:idType
              withId:CUSTOMER_ID_TYPE_DIC
           intoTable:tableName];
    
    NSArray *idTypeArray = [self assembData:idType];
    [store putObject:idTypeArray
              withId:CUSTOMER_ID_TYPE_LIST
           intoTable:tableName];
    
    NSDictionary *profession = [data objectForKey:@"职业"];
    [store putObject:profession
              withId:CUSTOMER_PROFESSION_DIC
           intoTable:tableName];
    
    NSArray *professionArray = [self assembData:profession];
    [store putObject:professionArray
              withId:CUSTOMER_PROFESSION_LIST
           intoTable:tableName];
    
    
    NSDictionary *industry = [data objectForKey:@"行业性质"];
    [store putObject:industry
              withId:CUSTOMER_INDUSTRY_DIC
           intoTable:tableName];
    
    NSArray *industryArray = [self assembData:industry];
    [store putObject:industryArray
              withId:CUSTOMER_INDUSTRY_LIST
           intoTable:tableName];
    
    NSDictionary *education = [data objectForKey:@"学历"];
    [store putObject:education
              withId:CUSTOMER_EDUCATION_DIC
           intoTable:tableName];
    
    NSArray *educationArray = [self assembData:education];
    [store putObject:educationArray
              withId:CUSTOMER_EDUCATION_LIST
           intoTable:tableName];
    
    
    [store close];
    [store release];
    
}

- (void)initCustomerNoneConnectData:(id)data
{
    NSString *tableName = CUSTOMER_DB_TABLE;
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    [store createTableWithName:tableName];
    
    [store putObject:data
              withId:CUSTOMER_NONECONNECT_LIST
           intoTable:tableName];
    
    [store close];
    [store release];
    
}

- (NSArray *)assembData:(NSDictionary *)data
{
    NSArray *allKey = [data allKeys];
    NSInteger cnt = [allKey count];
    NSMutableArray *itemList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for(int i=0; i<cnt; i++){
        NSString *keyString = [allKey objectAtIndex:i];
        NSString *valueString = [data objectForKey:keyString];
        NSDictionary *oneItem = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 keyString,SOURCE_DATA_ID_COLUM,
                                 valueString,SOURCE_DATA_NAME_COULUM,nil];
        [itemList addObject:oneItem];
        [oneItem release];
    }
    return itemList;
}

#pragma mark
#pragma mark - LoginViewDelegate
- (void)loginWithUserName:(NSString *)userName Passwd:(NSString *)passWd
{
    NSDictionary *paramer = [[NSDictionary alloc] initWithObjectsAndKeys:
                             userName,@"UserName",
                             passWd,@"PassWd",nil];
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService login:paramer];
    [paramer release];
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *errorCode = [info objectForKey:@"errorCode"];
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *MSG = [info objectForKey:@"MSG"];
    if ([bussineCode isEqualToString:[LoginJsonMessage getBizCode]]) {
        if ([[errorCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]) {
            
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            
            NSString *data = [rspInfo objectForKey:@"data"];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];

            [self initCustomerUserInfo:dic];
            
            bussineDataService *bussineService = [bussineDataService sharedDataService];
            bussineService.target = self;
            [bussineService getStaticData:nil];
            
        }else{
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                         message:MSG
                                                                        delegate:self
                                                                             tag:0
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else if ([bussineCode isEqualToString:[StaticDataMessage getBizCode]]){
        if ([[errorCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]) {
            
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            
            NSString *data = [rspInfo objectForKey:@"data"];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            [self initCustomerStaticData:dic];
            
            
            bussineDataService *bussineService = [bussineDataService sharedDataService];
            bussineService.target = self;
            [bussineService uploadAllCustomer:nil];
            
        }else{
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                         message:MSG
                                                                        delegate:self
                                                                             tag:0
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else if ([bussineCode isEqualToString:[UploadAllCustomerMessage getBizCode]]){
        if ([[errorCode lowercaseString] isEqualToString:RESPONE_RESULT_TRUE]) {
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo; //获取客户的未联系客户
            
            NSString *data = [rspInfo objectForKey:@"data"];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            [self initCustomerNoneConnectData:dic];
            
            [(AppDelegate *)([UIApplication sharedApplication].delegate) setHomeTabVC];
        }else{
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                         message:MSG
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
    NSString *MSG = [info objectForKey:@"MSG"];
    if ([bussineCode isEqualToString:[LoginJsonMessage getBizCode]]) {
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:MSG
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if ([bussineCode isEqualToString:[StaticDataMessage getBizCode]]) {
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:MSG
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if ([bussineCode isEqualToString:[UploadAllCustomerMessage getBizCode]]) {
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:MSG
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark
#pragma mark - AlterShowViewDelegate
- (void)alertViewWillPresent:(UIAlertController *)alertController
{
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

@end
