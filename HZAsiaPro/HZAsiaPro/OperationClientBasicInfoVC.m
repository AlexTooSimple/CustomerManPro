//
//  OperationClientBasicInfoVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/21.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "OperationClientBasicInfoVC.h"
#import "ItemPickerView.h"
#import "AddCustomerView.h"
#import "MyDatePickerView.h"
#import "bussineDataService.h"

#define ALTER_SUCCESS_BACK_TAG      205

@interface OperationClientBasicInfoVC ()<AddCustomerViewDelegate,
                                         ItemPickerDelegate,
                                         MyDatePickerViewDelegate,
                                         AlertShowViewDelegate,
                                         UIAlertViewDelegate,
                                         HttpBackDelegate>
{
    MyDatePickerView *datePicker;
    ItemPickerView *itemPicker;
    AddCustomerView *basicInfoView;
    
    NSMutableArray *basicInfoShowDataList;
}
@property (nonatomic ,retain)AddCustomerView *basicInfoView;
@property (nonatomic ,retain)MyDatePickerView *datePicker;
@property (nonatomic ,retain)ItemPickerView *itemPicker;
@property (nonatomic ,retain)NSMutableArray *basicInfoShowDataList;

@end

@implementation OperationClientBasicInfoVC

@synthesize customerInfo;
@synthesize datePicker;
@synthesize itemPicker;
@synthesize basicInfoShowDataList;
@synthesize basicInfoView;

- (void)dealloc
{
    [datePicker release];
    [itemPicker release];
    [basicInfoView release];
    [basicInfoShowDataList release];
    
    if (customerInfo != nil) {
        [customerInfo release];
    }
    
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
    self.title = @"修改客户基本信息";
    [self setNavBarCommitItem];
    [self layoutContentView];
    
    [self.basicInfoView reloadCustomerView:self.basicInfoShowDataList
                           WithShowSection:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBarCommitItem
{
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(commitClicked:)];
    self.navigationItem.rightBarButtonItem = commitItem;
    [commitItem release];
}

- (void)commitClicked:(id)sender
{
    NSDictionary *addCustomerInfo = [self.basicInfoView commitGetAllCustomerData];
    if (addCustomerInfo != nil) {
        NSString *clientType = [self.customerInfo objectForKey:@"clientType"];
        if ([clientType isEqualToString:@"0"]) {
            //个人客户
            [self sendUpdateIndvialMessage:addCustomerInfo];
        }else if ([clientType isEqualToString:@"1"]){
            //企业客户
            [self sendUpdateBusinessMessage:addCustomerInfo];
        }
    }
}


- (void)layoutContentView
{
    AddCustomerView  *customerView = [[AddCustomerView alloc] init];
    customerView.backgroundColor = [UIColor whiteColor];
    customerView.delegate = self;
    self.basicInfoView = customerView;
    [self.view addSubview:customerView];
    [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).with.offset(-DEVICE_TABBAR_HEIGTH);
    }];
    [customerView release];
    
    ItemPickerView *searchItemPicker = [[ItemPickerView alloc] initWithFrame:CGRectMake(0, DEVICE_MAINSCREEN_HEIGHT-220-DEVICE_TABBAR_HEIGTH+9, DEVICE_MAINSCREEN_WIDTH, 220)];
    searchItemPicker.delegate = self;
    self.itemPicker = searchItemPicker;
    [self.view addSubview:searchItemPicker];
    [searchItemPicker release];
    
    MyDatePickerView *datePickerView = [[MyDatePickerView alloc]initWithFrame:CGRectMake(0, DEVICE_MAINSCREEN_HEIGHT-220-DEVICE_TABBAR_HEIGTH+9, DEVICE_MAINSCREEN_WIDTH, 220)];
    datePickerView.delegate = self;
    self.datePicker = datePickerView;
    [self.view addSubview:datePickerView];
    [datePickerView release];
}

- (void)closeViewResponse
{
    [self.datePicker dismiss];
    [self.itemPicker dismiss];
}

#pragma mark
#pragma mark - Send Http Message
//更新企业用户基本信息
- (void)sendUpdateBusinessMessage:(NSDictionary *)basicInfo
{
    //客户编码
    NSString *clientCode = [self.customerInfo objectForKey:@"clientCode"];
    
    NSString *cname = [basicInfo objectForKey:@"公司名称"];
    NSString *mobile = [basicInfo objectForKey:@"联系电话"];
    NSString *shortforname = [basicInfo objectForKey:@"公司简称"];
    NSString *faren = [basicInfo objectForKey:@"法人代表"];
    NSString *contact = [basicInfo objectForKey:@"联系人"];
    NSString *fristName = [self.customerInfo objectForKey:@"cname"];
    NSString *steps = [basicInfo objectForKey:@"进展阶段"];
    NSString *phoneO = [self.customerInfo objectForKey:@"mobile"];
    NSString *zhcaddr = [basicInfo objectForKey:@"注册地址"];
    
    NSString *zczj =  [basicInfo objectForKey:@"注册资金"];
    NSNumber *zhcprice =  [NSNumber numberWithInteger:[zczj integerValue]];//要数字特殊处理
    
    NSString *jyfanwei = [basicInfo objectForKey:@"经营范围"];
    NSString *hyxingzhi = [basicInfo objectForKey:@"行业性质"];
    NSString *hypaiming = [basicInfo objectForKey:@"行业排名"];
    NSString *shjhuguan = [basicInfo objectForKey:@"税籍户管"];
    NSString *idStr = [basicInfo objectForKey:@"工商执照号"];
    NSString *shwno = [basicInfo objectForKey:@"税务执照号"];
    NSString *shwcode = [basicInfo objectForKey:@"税务代码"];
    NSString *address = [basicInfo objectForKey:@"经营地址"];
    NSString *jyqixian = [basicInfo objectForKey:@"经营期限"];
    NSString *post = [basicInfo objectForKey:@"邮政编码"];
    NSString *email = [basicInfo objectForKey:@"E-mail"];
    NSString *fax = [basicInfo objectForKey:@"组织机构代码"];
    NSString *remarks = [basicInfo objectForKey:@"备注"];
    
    
    //最后修改人
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];
    NSString *lastModifyBy = [usrInfo objectForKey:@"code"];
    [store release];
    
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 clientCode,@"clientCode",
                                 cname,@"cname",
                                 mobile,@"mobile",
                                 shortforname,@"shortforname",
                                 faren,@"faren",
                                 contact,@"contact",
                                 fristName,@"fristName",
                                 steps,@"steps",
                                 phoneO,@"phoneO",
                                 zhcaddr,@"zhcaddr",
                                 zhcprice,@"zhcprice",
                                 jyfanwei,@"jyfanwei",
                                 hyxingzhi,@"hyxingzhi",
                                 hypaiming,@"hypaiming",
                                 shjhuguan,@"shjhuguan",
                                 idStr,@"id",
                                 shwno,@"shwno",
                                 shwcode,@"shwcode",
                                 address,@"address",
                                 jyqixian,@"jyqixian",
                                 post,@"post",
                                 email,@"email",
                                 fax,@"fax",
                                 remarks,@"remarks",
                                 lastModifyBy,@"lastModifyBy",
                                 nil];
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService updateCustomer:requestData];
    [requestData release];
}

//更新个人用户基本信息
- (void)sendUpdateIndvialMessage:(NSDictionary *)basicInfo
{
    //客户编码
    NSString *clientCode = [self.customerInfo objectForKey:@"clientCode"];
    
    NSString *cname = [basicInfo objectForKey:@"客户姓名"];
    NSString *shortforname = [basicInfo objectForKey:@"缩写"];
    NSString *enname = [basicInfo objectForKey:@"英文名"];
    NSString *sex = [basicInfo objectForKey:@"性别"];
    NSString *mobile = [basicInfo objectForKey:@"移动电话"];
    NSString *idtype = [basicInfo objectForKey:@"证件类型"];
    NSString *idStr = [basicInfo objectForKey:@"证件号码"];
    NSString *steps = [basicInfo objectForKey:@"进展阶段"];
    NSString *birthdayStr = [basicInfo objectForKey:@"出生日期"];
    NSString *business = [basicInfo objectForKey:@"职业"];
    NSString *company = [basicInfo objectForKey:@"公司"];
    NSString *address = [basicInfo objectForKey:@"联系地址"];
    NSString *hangye = [basicInfo objectForKey:@"行业"];
    NSString *marige = [basicInfo objectForKey:@"婚否"];
    NSString *xueli = [basicInfo objectForKey:@"学历"];
    NSString *remarks = [basicInfo objectForKey:@"备注"];
    NSString *fristName = [self.customerInfo objectForKey:@"cname"];
    NSString *fristPhone = [self.customerInfo objectForKey:@"mobile"];
   
    //最后修改人
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];
    NSString *lastModifyBy = [usrInfo objectForKey:@"code"];
    [store release];

    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 clientCode,@"clientCode",
                                 cname,@"cname",
                                 shortforname,@"shortforname",
                                 enname,@"enname",
                                 sex,@"sex",
                                 mobile,@"mobile",
                                 idtype,@"idtype",
                                 idStr,@"id",
                                 steps,@"steps",
                                 company,@"company",
                                 business,@"business",
                                 address,@"address",
                                 hangye,@"hangye",
                                 marige,@"marige",
                                 xueli,@"xueli",
                                 remarks,@"remarks",
                                 fristName,@"fristName",
                                 fristPhone,@"fristPhone",
                                 lastModifyBy,@"lastModifyBy",
                                 birthdayStr,@"birthdayStr",
                                 nil];

    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService updateCustomer:requestData];
    [requestData release];
}

#pragma mark
#pragma mark - 初始化数据
- (void)reloadInitData:(NSArray *)sourceInitData
{
    NSString *clientType = [self.customerInfo objectForKey:@"clientType"];
    if ([clientType isEqualToString:@"0"]) {
        //个人客户
        [self assembIndvialData:sourceInitData];
    }else if ([clientType isEqualToString:@"1"]){
        //企业客户
        [self assembBussineData:sourceInitData];
    }
}


- (NSObject *)getSourceInitValue:(NSArray *)sourceData
                    WithLinkName:(NSString *)linkName
                   WithValueType:(NSString *)valueType
                WithSelectSource:(NSArray *)destSelectSource
{
    NSInteger cnt = [sourceData count];
    NSObject *returnObject = nil;
    for(int i=0; i<cnt; i++){
        NSDictionary *data = [sourceData objectAtIndex:i];
        NSString *sourceTitle = [data objectForKey:DATA_SHOW_TITLE_COLUM];
        NSString *linkName_o = [[NSString alloc] initWithFormat:@"%@:",linkName];
        if ([sourceTitle isEqualToString:linkName_o]) {
            if ([valueType isEqualToString:CUSTOMER_SELECT_TYPE]) {
                NSString *value = [data objectForKey:DATA_SHOW_VALUE_COLUM];
                NSInteger sourceCnt = [destSelectSource count];
                for (int j=0; j<sourceCnt; j++) {
                    NSDictionary *oneItem = [destSelectSource objectAtIndex:j];
                    if ([value isEqualToString:[oneItem objectForKey:SOURCE_DATA_NAME_COULUM]]) {
                        returnObject = [NSNumber numberWithInteger:j];
                        break;
                    }
                }
            }else{
                if ([data objectForKey:DATA_SHOW_VALUE_COLUM] == nil ||
                    [[data objectForKey:DATA_SHOW_VALUE_COLUM] isEqual:[NSNull null]]) {
                    returnObject = @"";
                }else{
                    returnObject = [data objectForKey:DATA_SHOW_VALUE_COLUM];
                }
            }
            break;
        }
        [linkName_o release];
    }
    return returnObject;
}

- (void)assembBussineData:(NSArray *)sourceInitData
{
    //布局企业基本信息
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSObject *initValue = [self getSourceInitValue:sourceInitData
                                      WithLinkName:@"公司名称"
                                     WithValueType:CUSTOMER_TEXTFIELD_TYPE
                                  WithSelectSource:nil];
    NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"公司名称",PLUS_CUSTOMER_TITLE,
                                    CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                    PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,
                                    initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:nameDic];
    [nameDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"联系电话"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *suoxieDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"联系电话", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,
                                      KEY_WINDOWS_NUMBER,PLUS_FIELD_KEYWINDOW_TYPE,
                                      @"11",PLUS_LIMIT_LENGTH,nil];
    [itemList addObject:suoxieDic];
    [suoxieDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"E-mail"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *emialDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"E-mail",PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                     initValue,PLUS_INIT_VALUE,
                                     KEY_WINDOWS_ASCII,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:emialDic];
    [emialDic release];

    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"公司简称"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *engishNameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"公司简称", PLUS_CUSTOMER_TITLE,
                                          CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                          initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:engishNameDic];
    [engishNameDic release];
    
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"法人代表"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    
    NSMutableDictionary *farenDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"法人代表", PLUS_CUSTOMER_TITLE,
                                    CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                    initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:farenDic];
    [farenDic release];

    
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"联系人"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"联系人", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                     initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:phoneDic];
    [phoneDic release];
    
    //进展阶段数据源
    NSArray *jinzhanSource = [store getObjectById:CUSTOMER_JINZHAN_JIEDUAN_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"进展阶段"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:jinzhanSource];
    
    NSMutableDictionary *jianzhanjieduanDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"进展阶段", PLUS_CUSTOMER_TITLE,
                                               CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                               jinzhanSource,PLUS_SELECT_DATA_SOURCE,
                                               initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:jianzhanjieduanDic];
    [jianzhanjieduanDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"注册地址"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *companyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"注册地址", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                       initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:companyDic];
    [companyDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"注册资金"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    
    NSMutableDictionary *addressDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"注册资金", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                       initValue,PLUS_INIT_VALUE,
                                       KEY_WINDOWS_NUMBER,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:addressDic];
    [addressDic release];
    
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"经营范围"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    
    NSMutableDictionary *jyfwDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"经营范围", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                       initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:jyfwDic];
    [jyfwDic release];
    
    
    //行业数据源
    NSArray *hangyeSource = [store getObjectById:CUSTOMER_INDUSTRY_LIST
                                       fromTable:CUSTOMER_DB_TABLE];
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"行业性质"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:hangyeSource];
    
    NSMutableDictionary *hangyeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"行业性质", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                      hangyeSource,PLUS_SELECT_DATA_SOURCE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:hangyeDic];
    [hangyeDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"行业排名"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *hypmDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"行业排名",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_NUMBER,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:hypmDic];
    [hypmDic release];
    
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"税籍户管"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *sjhgDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"税籍户管",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:sjhgDic];
    [sjhgDic release];
    

    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"工商执照号"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *gszzDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"工商执照号",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_ASCII,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:gszzDic];
    [gszzDic release];
    

    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"税务执照号"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *swzzDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"税务执照号",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_ASCII,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:swzzDic];
    [swzzDic release];
    

    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"税务代码"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *swdmDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"税务代码",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_ASCII,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:swdmDic];
    [swdmDic release];

    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"经营地址"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *jydzDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"经营地址",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:jydzDic];
    [jydzDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"经营期限"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *jyqxDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"经营期限",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_NUMBER,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:jyqxDic];
    [jyqxDic release];
    

    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"邮政编码"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"邮政编码",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_NUMBER,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:postDic];
    [postDic release];
    
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"组织机构代码"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *zzjgdmDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"组织机构代码",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_ASCII,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:zzjgdmDic];
    [zzjgdmDic release];

    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"备注"
                           WithValueType:CUSTOMER_TEXTVIEW_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *remarkDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"备注",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTVIEW_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:remarkDic];
    [remarkDic release];
    
    self.basicInfoShowDataList = itemList;
    [itemList release];
    
    [store release];
}



- (void)assembIndvialData:(NSArray *)sourceInitData
{
    //布局基本信息
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSObject *initValue = [self getSourceInitValue:sourceInitData
                                      WithLinkName:@"客户姓名"
                                     WithValueType:CUSTOMER_TEXTFIELD_TYPE
                                  WithSelectSource:nil];
    NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"客户姓名",PLUS_CUSTOMER_TITLE,
                                    CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                    PUT_FORCE_YES,PLUS_VALUE_IS_PUT_FORCE,
                                    initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:nameDic];
    [nameDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"缩写"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *suoxieDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"缩写", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:suoxieDic];
    [suoxieDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"英文名"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *engishNameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"英文名", PLUS_CUSTOMER_TITLE,
                                          CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                          initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:engishNameDic];
    [engishNameDic release];
    
    
    //布局性别数据源
    NSDictionary *sexData1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"男",SOURCE_DATA_NAME_COULUM,
                              @"男",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *sexData2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"女",SOURCE_DATA_NAME_COULUM,
                              @"女",SOURCE_DATA_ID_COLUM, nil];
    NSArray *sexSource = [[NSArray alloc] initWithObjects:sexData1,sexData2, nil];
    [sexData1 release];
    [sexData2 release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"性别"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:sexSource];
    
    NSMutableDictionary *sexDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"性别",PLUS_CUSTOMER_TITLE,
                                   CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                   sexSource,PLUS_SELECT_DATA_SOURCE,
                                   initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:sexDic];
    [sexDic release];
    [sexSource release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"移动电话"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"移动电话", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                     initValue,PLUS_INIT_VALUE,
                                     KEY_WINDOWS_NUMBER,PLUS_FIELD_KEYWINDOW_TYPE,
                                     @"11",PLUS_LIMIT_LENGTH,nil];
    [itemList addObject:phoneDic];
    [phoneDic release];
   
    
    
    //布局证件类型数据源
    NSArray *certTypeSource = [store getObjectById:CUSTOMER_ID_TYPE_LIST
                                         fromTable:CUSTOMER_DB_TABLE];
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"证件类型"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:certTypeSource];
    
    NSMutableDictionary *certTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"证件类型",PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                        certTypeSource,PLUS_SELECT_DATA_SOURCE,
                                        initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:certTypeDic];
    [certTypeDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"证件号码"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *certIDDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"证件号码", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,
                                      KEY_WINDOWS_ASCII,PLUS_FIELD_KEYWINDOW_TYPE,nil];
    [itemList addObject:certIDDic];
    [certIDDic release];
    
    //进展阶段数据源
    NSArray *jinzhanSource = [store getObjectById:CUSTOMER_JINZHAN_JIEDUAN_LIST
                                        fromTable:CUSTOMER_DB_TABLE];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"进展阶段"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:jinzhanSource];
    
    NSMutableDictionary *jianzhanjieduanDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"进展阶段", PLUS_CUSTOMER_TITLE,
                                               CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                               jinzhanSource,PLUS_SELECT_DATA_SOURCE,
                                               initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:jianzhanjieduanDic];
    [jianzhanjieduanDic release];
    
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"出生日期"
                           WithValueType:CUSTOMER_DATE_SELECT_TYPE
                        WithSelectSource:nil];

    NSMutableDictionary *birthdayDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"出生日期", PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_DATE_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                        initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:birthdayDic];
    [birthdayDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"公司"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *companyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"公司", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                       initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:companyDic];
    [companyDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"联系地址"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];

    NSMutableDictionary *addressDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"联系地址", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                       initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:addressDic];
    [addressDic release];
    
    //职业数据源
    NSArray *professionSource = [store getObjectById:CUSTOMER_PROFESSION_LIST
                                           fromTable:CUSTOMER_DB_TABLE];

    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"职业"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:professionSource];

    
    NSMutableDictionary *professionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"职业", PLUS_CUSTOMER_TITLE,
                                          CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                          professionSource,PLUS_SELECT_DATA_SOURCE,
                                          initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:professionDic];
    [professionDic release];
    
    //行业数据源
    NSArray *hangyeSource = [store getObjectById:CUSTOMER_INDUSTRY_LIST
                                       fromTable:CUSTOMER_DB_TABLE];
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"行业"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:hangyeSource];
    
    NSMutableDictionary *hangyeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"行业", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                      hangyeSource,PLUS_SELECT_DATA_SOURCE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:hangyeDic];
    [hangyeDic release];
    
    //婚烟数据源
    NSDictionary *marry1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"",SOURCE_DATA_NAME_COULUM,
                            @"",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *marry2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"已婚",SOURCE_DATA_NAME_COULUM,
                            @"已婚",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *marry3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"未婚",SOURCE_DATA_NAME_COULUM,
                            @"未婚",SOURCE_DATA_ID_COLUM, nil];
    NSArray *marrySource = [[NSArray alloc] initWithObjects:marry1,marry2,marry3, nil];
    [marry1 release];[marry2 release];[marry3 release];
    
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"婚否"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:marrySource];

    NSMutableDictionary *marryDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"婚否", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                     marrySource,PLUS_SELECT_DATA_SOURCE,
                                     initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:marryDic];
    [marryDic release];
    [marrySource release];
    
    //学历数据源
    NSArray *xueliSource = [store getObjectById:CUSTOMER_EDUCATION_LIST
                                      fromTable:CUSTOMER_DB_TABLE];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"学历"
                           WithValueType:CUSTOMER_SELECT_TYPE
                        WithSelectSource:xueliSource];

    NSMutableDictionary *xueliDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"学历", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,
                                     xueliSource,PLUS_SELECT_DATA_SOURCE,
                                     initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:xueliDic];
    [xueliDic release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"备注"
                           WithValueType:CUSTOMER_TEXTVIEW_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *remarkDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"备注",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTVIEW_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:remarkDic];
    [remarkDic release];
    
    self.basicInfoShowDataList = itemList;
    [itemList release];

    [store release];
}

#pragma mark
#pragma mark - ItemPickerDelegate
- (void)viewDidDismiss:(ItemPickerView *)itemView
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.itemPicker];
}

- (void)itemPickerView:(ItemPickerView *)itemPicker selectRow:(NSInteger)row selectData:(NSString *)itemStr
{
    [self.basicInfoView reloadViewDataWithSelectRow:row];
}

#pragma mark
#pragma mark - MyDatePickerViewDelegate
-(void)viewDidDismiss
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.datePicker];
}
-(void)clickMyDatePickerViewOk:(NSString*)selectedDate
{
    [self.basicInfoView reloadViewDataSelectDate:selectedDate];
}

#pragma mark
#pragma mark - AddCustomerViewDelegate
- (void)customerView:(AddCustomerView *)addCustomerView DidShowItemPickerWithRow:(NSInteger)row WithSource:(NSArray *)sourceList
{
    [self.itemPicker reloadPickerData:sourceList];
    [self.itemPicker selectPickerRow:row];
    [self.itemPicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.itemPicker];
    
}

- (void)customerView:(AddCustomerView *)addCustomerView DidShowDate:(UIDatePickerMode)pickerMode
{
    [self.datePicker setDateMode:pickerMode];
    [self.datePicker setMaxDate:[NSDate date]];
    [self.datePicker setMinDate:nil];
    
    [self.datePicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.datePicker];
    
}

- (void)customerViewDidShowTextField:(AddCustomerView *)addCustomerView
{
    [self closeViewResponse];
}

#pragma mark
#pragma mark - AlertShowViewDelegate
- (void)alertViewWillPresent:(UIAlertController *)alertController
{
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
}

- (void)alertShowView:(AlertShowView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(ALTER_SUCCESS_BACK_TAG == alertView.index){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark
#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(ALTER_SUCCESS_BACK_TAG == alertView.tag){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    NSString *errorCode = [info objectForKey:@"errorCode"];
    if([[UpdateClientBasicInfoMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_UPDATE_MAIN_VC_NOTIFACTION
                                                                object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_UPDATE_CLIENT_DATA_NOTIFATION
                                                                object:nil];


            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"修改信息成功"
                                                                         message:@"您的客户基本信息修改成功,谢谢！"
                                                                        delegate:self
                                                                             tag:ALTER_SUCCESS_BACK_TAG
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
            [alert show];
            [alert release];
            
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
    if([[UpdateClientBasicInfoMessage getBizCode] isEqualToString:bussineCode]){
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

@end
