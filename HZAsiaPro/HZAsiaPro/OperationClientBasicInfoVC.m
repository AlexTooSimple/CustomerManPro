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

@interface OperationClientBasicInfoVC ()<AddCustomerViewDelegate,
                                         ItemPickerDelegate,
                                         MyDatePickerViewDelegate>
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
#pragma mark - 初始化数据
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
        if ([sourceTitle isEqualToString:linkName]) {
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
                returnObject = [data objectForKey:DATA_SHOW_VALUE_COLUM];
            }
            break;
        }
    }
    return returnObject;
}

- (void)reloadInitData:(NSArray *)sourceInitData
{
    //布局基本信息
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
                              @"1",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *sexData2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"女",SOURCE_DATA_NAME_COULUM,
                              @"2",SOURCE_DATA_ID_COLUM, nil];
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
                                     initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:phoneDic];
    [phoneDic release];
    
    
    //布局证件类型数据源
    NSDictionary *certType1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *certType2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"身份证",SOURCE_DATA_NAME_COULUM,
                               @"1",SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *certType3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"军人证",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *certType4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"户口簿",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *certType5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"驾驶证",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *certType6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"回乡证",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *certType7 = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"护照",SOURCE_DATA_NAME_COULUM,
                               @"0",SOURCE_DATA_ID_COLUM,nil];
    NSArray *certTypeSource = [[NSArray alloc] initWithObjects:
                               certType1,certType2,certType3,certType4,certType5,certType6,certType7, nil];
    [certType1 release];
    [certType2 release];
    [certType3 release];
    [certType4 release];
    [certType5 release];
    [certType6 release];
    [certType7 release];
    
    
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
    [certTypeSource release];
    
    initValue = [self getSourceInitValue:sourceInitData
                            WithLinkName:@"证件号码"
                           WithValueType:CUSTOMER_TEXTFIELD_TYPE
                        WithSelectSource:nil];
    NSMutableDictionary *certIDDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"证件号码", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,
                                      initValue,PLUS_INIT_VALUE,nil];
    [itemList addObject:certIDDic];
    [certIDDic release];
    
    //进展阶段数据源
    NSDictionary *jinzhanjieduan1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"", SOURCE_DATA_NAME_COULUM,
                                     @"0", SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *jinzhanjieduan2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"初次接触", SOURCE_DATA_NAME_COULUM,
                                     @"0", SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *jinzhanjieduan3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"洽谈过程", SOURCE_DATA_NAME_COULUM,
                                     @"0", SOURCE_DATA_ID_COLUM,nil];
    
    NSDictionary *jinzhanjieduan4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"已经成交", SOURCE_DATA_NAME_COULUM,
                                     @"0", SOURCE_DATA_ID_COLUM,nil];
    NSArray *jinzhanSource = [[NSArray alloc] initWithObjects:jinzhanjieduan1,
                              jinzhanjieduan2,jinzhanjieduan3,jinzhanjieduan4,nil];
    
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
    [jinzhanSource release];
    
    
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
    NSDictionary *profession1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"",SOURCE_DATA_NAME_COULUM,
                                 @"0",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *profession2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"公务员",SOURCE_DATA_NAME_COULUM,
                                 @"0",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *profession3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"私营企业",SOURCE_DATA_NAME_COULUM,
                                 @"0",SOURCE_DATA_ID_COLUM, nil];
    NSArray *professionSource = [[NSArray alloc] initWithObjects:profession1,profession2,profession3, nil];
    [profession1 release];
    [profession2 release];
    [profession3 release];
    
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
    [professionSource release];
    
    //行业数据源
    NSDictionary *hangye1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"旅游",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"金融",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"制造",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"物流",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"餐饮",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye7 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"娱乐",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye8 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"服装",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye9 = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"外贸",SOURCE_DATA_NAME_COULUM,
                             @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye10 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"政府",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye11 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"军队",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye12 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"食品",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye13 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"教育",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye14 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"建筑",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye15 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"计算机",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye16 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"信息",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye17 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"服务",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *hangye18 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"医疗卫生",SOURCE_DATA_NAME_COULUM,
                              @"0",SOURCE_DATA_ID_COLUM,nil];
    NSArray *hangyeSource = [[NSArray alloc] initWithObjects:
                             hangye1,hangye2,hangye3,hangye4,hangye5,hangye6,hangye7,hangye8,hangye9,
                             hangye10,hangye11,hangye12,hangye13,hangye14,hangye15,hangye16,hangye17,hangye18,nil];
    [hangye1 release];[hangye2 release];[hangye3 release];[hangye4 release];[hangye5 release];
    [hangye6 release];[hangye7 release];[hangye8 release];[hangye9 release];[hangye10 release];
    [hangye11 release];[hangye12 release];[hangye13 release];[hangye14 release];[hangye15 release];
    [hangye16 release];[hangye17 release];[hangye18 release];
    
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
    [hangyeSource release];
    
    //婚烟数据源
    NSDictionary *marry1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"",SOURCE_DATA_NAME_COULUM,
                            @"0",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *marry2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"已婚",SOURCE_DATA_NAME_COULUM,
                            @"1",SOURCE_DATA_ID_COLUM, nil];
    NSDictionary *marry3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"未婚",SOURCE_DATA_NAME_COULUM,
                            @"2",SOURCE_DATA_ID_COLUM, nil];
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
    NSDictionary *xueli1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"",SOURCE_DATA_NAME_COULUM,
                            @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *xueli2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"中专高中",SOURCE_DATA_NAME_COULUM,
                            @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *xueli3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"专科",SOURCE_DATA_NAME_COULUM,
                            @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *xueli4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"本科",SOURCE_DATA_NAME_COULUM,
                            @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *xueli5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"研究生",SOURCE_DATA_NAME_COULUM,
                            @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *xueli6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"其他",SOURCE_DATA_NAME_COULUM,
                            @"0",SOURCE_DATA_ID_COLUM,nil];
    NSArray *xueliSource = [[NSArray alloc] initWithObjects:xueli1,xueli2,xueli3,xueli4,xueli5,xueli6, nil];
    [xueli1 release];[xueli2 release];[xueli3 release];[xueli4 release];[xueli5 release];[xueli6 release];
    
    
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
    [xueliSource release];
    
    
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

- (void)customerViewDidShowAlertView:(UIAlertController *)alertController
{
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

@end
