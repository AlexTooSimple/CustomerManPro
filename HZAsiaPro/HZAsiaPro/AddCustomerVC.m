//
//  AddCustomerVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/15.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "AddCustomerVC.h"
#import "AddCustomerView.h"
#import "ItemPickerView.h"
#import "MyDatePickerView.h"

@interface AddCustomerVC ()<MyDatePickerViewDelegate,ItemPickerDelegate,AddCustomerViewDelegate>
{
    AddCustomerView *addContentView;
    NSMutableArray *plusShowDataList;
    
    MyDatePickerView *datePicker;
    ItemPickerView *itemPicker;
}
@property (nonatomic ,retain)NSMutableArray *plusShowDataList;
@property (nonatomic ,retain)AddCustomerView *addContentView;
@property (nonatomic ,retain)MyDatePickerView *datePicker;
@property (nonatomic ,retain)ItemPickerView *itemPicker;
@end

@implementation AddCustomerVC

@synthesize plusShowDataList;
@synthesize addContentView;
@synthesize itemPicker;
@synthesize datePicker;

- (void)dealloc
{
    [datePicker release];
    [itemPicker release];
    
    [addContentView release];
    [plusShowDataList release];
    
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
    self.title = @"新增客户";
    
    [self setNavBarCommitItem];
    
    [self layoutContentView];
    [self initData];
    
    [self.addContentView reloadCustomerView:self.plusShowDataList];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void)layoutContentView
{
    AddCustomerView  *customerView = [[AddCustomerView alloc] initWithFrame:CGRectZero];
    customerView.backgroundColor = [UIColor whiteColor];
    customerView.delegate = self;
    self.addContentView = customerView;
    [self.view addSubview:customerView];
    [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    [customerView release];
}


- (void)closeViewResponse
{
    [self.datePicker dismiss];
    [self.itemPicker dismiss];
}

- (void)setNavBarCommitItem
{
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithTitle:@"上报审批"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(commitClicked:)];
    self.navigationItem.rightBarButtonItem = commitItem;
    [commitItem release];
}

- (void)commitClicked:(id)sender
{

}

#pragma mark
#pragma mark - 初始化数据
- (void)initData
{
    NSMutableArray *itemList = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *nameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"客户姓名",PLUS_CUSTOMER_TITLE,
                                    CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:nameDic];
    [nameDic release];
    
    NSMutableDictionary *suoxieDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"缩写", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:suoxieDic];
    [suoxieDic release];
    
    NSMutableDictionary *engishNameDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"英文名", PLUS_CUSTOMER_TITLE,
                                         CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:engishNameDic];
    [engishNameDic release];
    
    NSMutableDictionary *sexDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"性别",PLUS_CUSTOMER_TITLE,
                                   CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:sexDic];
    [sexDic release];
    
    NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"移动电话", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:phoneDic];
    [phoneDic release];
    
    
    NSMutableDictionary *certTypeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"证件类型",PLUS_CUSTOMER_TITLE,
                                        CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:certTypeDic];
    [certTypeDic release];
    
    NSMutableDictionary *certIDDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"证件号码", PLUS_CUSTOMER_TITLE,
                                     CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:certIDDic];
    [certIDDic release];
    
    NSMutableDictionary *jianzhanjieduanDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"进展阶段", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:jianzhanjieduanDic];
    [jianzhanjieduanDic release];
    
    NSMutableDictionary *birthdayDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"出生日期", PLUS_CUSTOMER_TITLE,
                                       CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:birthdayDic];
    [birthdayDic release];
    
    NSMutableDictionary *companyDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"公司", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:companyDic];
    [companyDic release];
    
    NSMutableDictionary *addressDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"联系地址", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:addressDic];
    [addressDic release];
    
    NSMutableDictionary *countryDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"国籍", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:countryDic];
    [countryDic release];
    
    NSMutableDictionary *areaDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"区域", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:areaDic];
    [areaDic release];
    
    NSMutableDictionary *professionDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"职业", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:professionDic];
    [professionDic release];
    
    NSMutableDictionary *hangyeDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"行业", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:hangyeDic];
    [hangyeDic release];
    
    NSMutableDictionary *marryDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"婚否", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:marryDic];
    [marryDic release];
    
    NSMutableDictionary *xueliDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"学历", PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_SELECT_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:xueliDic];
    [xueliDic release];
    
    NSMutableDictionary *remarkDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      @"备注",PLUS_CUSTOMER_TITLE,
                                      CUSTOMER_TEXTFIELD_TYPE,PLUS_CUSTOMER_TYPE,nil];
    [itemList addObject:remarkDic];
    [remarkDic release];
    
    self.plusShowDataList = itemList;
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
//    [self.contentView reloadViewShowData:itemStr];
}

#pragma mark
#pragma mark - MyDatePickerViewDelegate
-(void)viewDidDismiss
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.datePicker];
}
-(void)clickMyDatePickerViewOk:(NSString*)selectedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-mm-dd";
    if ([[df dateFromString:selectedDate] compare:[NSDate date]] == NSOrderedDescending) {
        AlertShowView *alertView = [[AlertShowView alloc] initWithAlertViewTitle:@"提示消息"
                                                                         message:@"输入的时间不能大于今天"
                                                                        delegate:self
                                                                             tag:0
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
        [alertView show];
        [self.datePicker show];
        [df release];
        return;
    }else{
//        [self.contentView reloadViewDate:selectedDate];
    }
}

#pragma mark
#pragma mark - AddCustomerViewDelegate
- (void)customerViewDidShowItemPickerWithRow:(NSInteger)row
{
    [self.itemPicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.itemPicker];

}

- (void)customerViewDidShowDate
{
    [self.datePicker setMaxDate:[NSDate date]];
    [self.datePicker setMinDate:nil];
    
    [self.datePicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.datePicker];

}

- (void)customerViewDidShowTextField
{
    [self closeViewResponse];
}


@end
