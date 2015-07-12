//
//  VerifyCustomerVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/23.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "VerifyCustomerVC.h"
#import "ItemPickerView.h"
#import "bussineDataService.h"
#import "AddCustomerVC.h"

#define CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG           101
#define CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG            102
#define CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG           103
#define CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG           104

#define ROW_HEIGHT          40.0f

@interface VerifyCustomerVC ()<ItemPickerDelegate,
                               UIGestureRecognizerDelegate,
                               UITextFieldDelegate,
                               HttpBackDelegate,
                               AlertShowViewDelegate>
{
    ItemPickerView *itemPicker;
    
    UITextField *nameField;
    UITextField *phoneField;
    UILabel *typeLabel;
    
    NSArray *clientTypeSourceList;
    NSInteger selectClientType;
}
@property (nonatomic ,retain)ItemPickerView *itemPicker;
@property (nonatomic ,retain)UITextField *nameField;
@property (nonatomic ,retain)UITextField *phoneField;
@property (nonatomic ,retain)UILabel *typeLabel;
@property (nonatomic ,retain)NSArray *clientTypeSourceList;
@end

@implementation VerifyCustomerVC

@synthesize itemPicker;
@synthesize nameField;
@synthesize phoneField;
@synthesize typeLabel;
@synthesize clientTypeSourceList;

- (void)dealloc
{
    [clientTypeSourceList release];
    [phoneField release];
    [nameField release];
    [typeLabel release];
    [itemPicker release];
    
    [super dealloc];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"校验客户";
    
    [self setNavBarNextItem];
    
    
    
    ItemPickerView *searchItemPicker = [[ItemPickerView alloc] initWithFrame:CGRectMake(0, DEVICE_MAINSCREEN_HEIGHT-220-DEVICE_TABBAR_HEIGTH+9, DEVICE_MAINSCREEN_WIDTH, 220)];
    searchItemPicker.delegate = self;
    self.itemPicker = searchItemPicker;
    [self.view addSubview:searchItemPicker];
    [searchItemPicker release];
    
    
    NSDictionary *clientType1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"个人客户",SOURCE_DATA_NAME_COULUM,
                                 @"0",SOURCE_DATA_ID_COLUM,nil];
    NSDictionary *clientType2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"企业客户",SOURCE_DATA_NAME_COULUM,
                                 @"1",SOURCE_DATA_ID_COLUM,nil];
       NSArray *itemList = [[NSArray alloc] initWithObjects:clientType1,clientType2, nil];
    [clientType1 release]; [clientType2 release];
    
    self.clientTypeSourceList = itemList;
    [itemList release];

    selectClientType = 0;
    
    
    [self layoutContentView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleFromTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBarNextItem
{
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(nextStep:)];
    self.navigationItem.rightBarButtonItem = nextItem;
    [nextItem release];
}

- (void)nextStep:(id)sender
{
    if (self.nameField.text == nil || [self.nameField.text isEqualToString:@""]) {
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:@"客户姓名不能为空"
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (self.phoneField.text == nil || [self.phoneField.text isEqualToString:@""]) {
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:@"手机号码不能为空"
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    
    NSString *clientType = [[self.clientTypeSourceList objectAtIndex:selectClientType] objectForKey:SOURCE_DATA_ID_COLUM];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.nameField.text,@"cname",
                          self.phoneField.text,@"mobile",
                          clientType,@"clientType",nil];
    
    [bussineService checkCustomer:data];
    [data release];
}


- (void)layoutContentView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(80, 8, 0, 8));
    }];
    
    //布局客户名称
    UIView *clientNameView = [self customCellWithTextFieldToSuperView:contentView
                                                                duarY:0];
    
    UILabel *titleLabel = (UILabel *)[clientNameView viewWithTag:CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG];
    titleLabel.text = @"客户名称：";
    UITextField *txtField = (UITextField *)[clientNameView viewWithTag:CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG];
    self.nameField = txtField;
    
    //布局手机号码
    UIView  *phoneView = [self customCellWithTextFieldToSuperView:contentView
                                                            duarY:40];
    titleLabel = (UILabel *)[phoneView viewWithTag:CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG];
    titleLabel.text = @"手机号码：";
    txtField = (UITextField *)[phoneView viewWithTag:CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG];
    self.phoneField = txtField;
    
    //布局客户类型
    UIView *clientTypeView = [self customerCellWithSelectViewToSuperView:contentView
                                                                   duarY:80
                                                               buttonTag:0];
    titleLabel = (UILabel *)[clientTypeView viewWithTag:CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG];
    titleLabel.text = @"客户类型：";
    UILabel *valueLabel = (UILabel *)[clientTypeView viewWithTag:CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG];
    valueLabel.text = [[self.clientTypeSourceList objectAtIndex:selectClientType] objectForKey:SOURCE_DATA_NAME_COULUM];
    self.typeLabel = valueLabel;
    
    [contentView release];
}


- (UIView *)customCellWithTextFieldToSuperView:(UIView *)superView duarY:(CGFloat)duarY
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    sectionView.backgroundColor = [UIColor clearColor];
    [superView addSubview:sectionView];
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.top.equalTo(superView).with.offset(duarY);
        make.height.mas_equalTo(ROW_HEIGHT);
        make.width.equalTo(superView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.tag = CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView);
        make.top.equalTo(sectionView);
        make.size.mas_equalTo(CGSizeMake(65.0f, ROW_HEIGHT));
    }];
    [titleLabel release];
    
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectZero];
    inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    [sectionView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).with.offset(70.0f);
        make.top.equalTo(sectionView).with.offset((ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(ROW_HEIGHT-35)/2.0f);
        make.right.equalTo(sectionView).with.offset(-10.0f);
    }];
    [inputView release];
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectZero];
    [txtField setReturnKeyType:UIReturnKeyDone];
    [txtField setBackgroundColor:[UIColor clearColor]];
    [txtField setBorderStyle:UITextBorderStyleNone];
    txtField.tag = CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG;
    txtField.delegate = self;
    [txtField setFont:[UIFont systemFontOfSize:13.0f]];
    [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [sectionView addSubview:txtField];
    [txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).with.offset(74.0f);
        make.top.equalTo(sectionView).with.offset((ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(ROW_HEIGHT-35)/2.0f);
        make.right.equalTo(sectionView).with.offset(-14.0f);
    }];
    [txtField release];

    return sectionView;
}

- (UIView *)customerCellWithSelectViewToSuperView:(UIView *)superView duarY:(CGFloat)duarY buttonTag:(NSInteger)tag
{
    
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    sectionView.backgroundColor = [UIColor clearColor];
    [superView addSubview:sectionView];
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.top.equalTo(superView).with.offset(duarY);
        make.height.mas_equalTo(ROW_HEIGHT);
        make.width.equalTo(superView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.tag = CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView);
        make.top.equalTo(sectionView);
        make.size.mas_equalTo(CGSizeMake(65.0f, ROW_HEIGHT));
    }];
    [titleLabel release];
    
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectZero];
    inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    [sectionView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView.mas_right).with.offset(-150.0f);
        make.top.equalTo(sectionView).with.offset((ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(ROW_HEIGHT-35)/2.0f);
        make.right.equalTo(sectionView).with.offset(-10.0f);
    }];
    
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.tag = CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG;
    valueLabel.font = [UIFont systemFontOfSize:13.0f];
    valueLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputView).with.offset(4.0f);
        make.right.equalTo(inputView).with.offset(-(23/2.0f+7));
        make.top.equalTo(sectionView).with.offset((ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(ROW_HEIGHT-35)/2.0f);
        
    }];
    [valueLabel release];
    
    UIImageView *downArrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
    downArrowView.image = [UIImage imageNamed:@"down.png"];
    [sectionView addSubview:downArrowView];
    [downArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(valueLabel.mas_right).with.offset(4.0f);
        make.top.equalTo(sectionView).with.offset((ROW_HEIGHT-8)/2.0f);
        make.size.mas_equalTo(CGSizeMake(23/2.0f, 16/2.0f));
    }];
    [downArrowView release];
    
    
    UIButton *clickedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickedBtn.backgroundColor = [UIColor clearColor];
    clickedBtn.tag = tag;
    [clickedBtn addTarget:self
                   action:@selector(handleShowPickerClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:clickedBtn];
    [clickedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputView);
        make.top.equalTo(sectionView);
        make.right.equalTo(sectionView);
        make.height.equalTo(sectionView);
    }];
    
    [inputView release];

    return sectionView;
}

#pragma mark
#pragma mark - UIAction
- (void)handleShowPickerClicked:(id)sender
{
    if ([self.nameField isFirstResponder]) {
        [self.nameField resignFirstResponder];
    }
    if ([self.phoneField isFirstResponder]) {
        [self.phoneField resignFirstResponder];
    }
    
    [[[UIApplication sharedApplication].windows firstObject] addSubview:self.itemPicker];
    [self.itemPicker reloadPickerData:[self.clientTypeSourceList valueForKeyPath:SOURCE_DATA_NAME_COULUM]];
    [self.itemPicker selectPickerRow:selectClientType];
    [self.itemPicker show];
}

- (void)handleFromTap:(UIGestureRecognizer *)recogizer
{
    if ([self.nameField isFirstResponder]) {
        [self.nameField resignFirstResponder];
    }
    if ([self.phoneField isFirstResponder]) {
        [self.phoneField resignFirstResponder];
    }
}


#pragma mark
#pragma mark - ItemPickerDelegate
- (void)viewDidDismiss:(ItemPickerView *)itemView
{
    [[[UIApplication sharedApplication].windows firstObject] willRemoveSubview:self.itemPicker];
}

- (void)itemPickerView:(ItemPickerView *)itemPicker selectRow:(NSInteger)row selectData:(NSString *)itemStr
{
    selectClientType = row;
    self.typeLabel.text = itemStr;
}

#pragma mark
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UIButton class]] ||
        [[touch view] isKindOfClass:[UITextField class]]) {
        return NO;
    }
    return YES;
}

#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.itemPicker dismiss];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *errorCode = [info objectForKey:@"errorCode"];
    if([[CheckClientMessage getBizCode] isEqualToString:bussineCode]){
        if ([errorCode isEqualToString:RESPONE_RESULT_TRUE]) {
            message *msg = [info objectForKey:@"message"];
            NSDictionary *rspInfo = msg.rspInfo;
            NSString *data = [rspInfo objectForKey:@"data"];
            
            NSArray *rspCustomerList = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                        error:nil];
            if (rspCustomerList == nil || [rspCustomerList isEqual:[NSNull null]] || [rspCustomerList count] == 0) {
                AddCustomerVC *VC = [[AddCustomerVC alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                [VC release];
            }else{
            
            }
        }else{
            AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                         message:@"校验客户失败"
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
    if([[CheckClientMessage getBizCode] isEqualToString:bussineCode]){
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:@"校验客户失败"
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
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
}


@end
