//
//  SearchConditionVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/14.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "SearchConditionVC.h"
#import "SearchConditionView.h"
#import "ItemPickerView.h"
#import "MyDatePickerView.h"
#import "AlertShowView.h"
#import "ModelConditionNavVC.h"

@interface SearchConditionVC ()<SearchConditionViewDelegate,ItemPickerDelegate,MyDatePickerViewDelegate,AlertShowViewDelegate>
{
    ItemPickerView *itemPicker;
    MyDatePickerView *datePicker;
    
    SearchConditionView *contentView;
}
@property (nonatomic ,retain)ItemPickerView *itemPicker;
@property (nonatomic ,retain)MyDatePickerView *datePicker;
@property (nonatomic ,retain)SearchConditionView *contentView;
@end

@implementation SearchConditionVC

@synthesize itemPicker;
@synthesize datePicker;
@synthesize contentView;

- (void)dealloc
{
    [contentView release];
    [datePicker release];
    [itemPicker release];
    
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
    self.title = @"搜索条件";
    [self setNavBarSearchItem];
    
    SearchConditionView *conditionView = [[SearchConditionView alloc] init];
    conditionView.backgroundColor = [UIColor whiteColor];
    conditionView.delegate = self;
    [self.view addSubview:conditionView];
    self.contentView = conditionView;
    [conditionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_left).with.offset(270.0f);
    }];
    [conditionView release];
    
    
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


- (void)setNavBarSearchItem
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 74/2.0f, 83/2.0f);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self
                  action:@selector(search:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = searchItem;
    [searchItem release];
}

- (void)search:(id)sender
{
    NSLog(@"search");
    NSDictionary *condition = [self.contentView getSearchCondition];
    
    [((ModelConditionNavVC *)(self.navigationController)).drawer close];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_VC_SEARCH_DONE_NOTIFATION
                                                        object:condition];
}

#pragma mark
#pragma mark - ItemPickerDelegate
- (void)viewDidDismiss:(ItemPickerView *)itemView
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.itemPicker];
}
- (void)itemPickerView:(ItemPickerView *)itemPicker selectRow:(NSInteger)row selectData:(NSString *)itemStr
{
    [self.contentView reloadViewShowData:itemStr selectRow:row];
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
    df.dateFormat = @"yyyy-MM-dd";
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
        [self.contentView reloadViewDate:selectedDate];
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
#pragma mark - SearchConditionViewDelegate
- (void)searchConditionViewDidShowItemPicker:(NSArray *)itemList WithSelectRow:(NSInteger)selectRow
{
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.itemPicker];
    [self.itemPicker reloadPickerData:itemList];
    
    [self.itemPicker selectPickerRow:selectRow];
    
    [self.itemPicker show];
}

- (void)searchConditionViewDidShowDatePicker
{
    [self.datePicker setMaxDate:[NSDate date]];
    [self.datePicker setMinDate:nil];
    
    [self.datePicker show];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.datePicker];
}

- (void)searchConditionViewDidShowTextField
{
    [self closeConditionViewResponse];
}

- (void)closeConditionViewResponse
{
    [self.itemPicker dismiss];
    [self.datePicker dismiss];
}

@end
