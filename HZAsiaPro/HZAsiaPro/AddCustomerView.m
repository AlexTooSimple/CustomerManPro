//
//  AddCustomerView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/16.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "AddCustomerView.h"
#import "ComponentsFactory.h"
#define CELL_ROW_HEIGHT                         40.0f
#define CELL_MORE_FIELD_ROW_HEIGHT              156/2.0f+5

#define CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG       101
#define CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG        102

#define CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG       103
#define CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG       104

#define CELL_TYPE_THREE_ROW_TITLE_LABEL_TAG     105
#define CELL_TYPE_THREE_ROW_TEXT_VIEW_TAG       106

#define CLICKED_BUTTON_TAG                      200


#define CELL_CUSTOMER_TEXTFIELD                 @"detailField"
#define CELL_CUSTOMER_LABEL                     @"detailLabel"

@implementation AddCustomerView

@synthesize contentTable;
@synthesize itemShowList;
@synthesize delegate;
@synthesize changeFieldY;
@synthesize isShowHeader;
@synthesize sectionHei;
@synthesize headerTitle;
@synthesize selectViewRow;
@synthesize initContentY;

- (void)dealloc
{
    [contentTable release];
    if (itemShowList != nil) {
        [itemShowList release];
    }
    
    if (headerTitle != nil) {
        [headerTitle release];
    }
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.scrollEnabled = YES;
    contentView.pagingEnabled = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = YES;
    self.contentTable = contentView;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [contentView release];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleFromTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    [self.contentTable addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyWindowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

}



#pragma mark
#pragma mark -  对外接口
//刷新页面布局
- (void)reloadCustomerView:(NSMutableArray *)itemDatas WithShowSection:(NSString *)sectionTitle
{
    self.itemShowList = itemDatas;
    if (sectionTitle != nil && ![sectionTitle isEqualToString:@""]) {
        self.sectionHei = 20.0f;
        self.isShowHeader = YES;
        self.headerTitle = sectionTitle;
    }else{
        self.sectionHei = 0.0f;
        self.isShowHeader = NO;
        self.headerTitle = nil;
    }
    [self setEditCustomerView];
}

//获取信息
- (NSDictionary *)commitGetAllCustomerData
{
    NSMutableDictionary *customerData = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    NSInteger cnt = [self.itemShowList count];
    BOOL isNext = YES;
    NSMutableString *message = [[NSMutableString alloc] initWithCapacity:0];
    for (int i=0; i<cnt; i++) {
        NSDictionary *itemData = [self.itemShowList objectAtIndex:i];
        NSString *dataType = [itemData objectForKey:PLUS_CUSTOMER_TYPE];
        if ([dataType isEqualToString:CUSTOMER_SELECT_TYPE]) {
            NSString *title = [itemData objectForKey:PLUS_CUSTOMER_TITLE];
            NSNumber  *detailNumber = [itemData objectForKey:PLUS_INIT_VALUE];
            NSArray *detailSource = [itemData objectForKey:PLUS_SELECT_DATA_SOURCE];
            NSDictionary *detailDic = [detailSource objectAtIndex:[detailNumber integerValue]];
            NSString *plusForce = [itemData objectForKey:PLUS_VALUE_IS_PUT_FORCE];
            if ([plusForce isEqualToString:PUT_FORCE_YES]) {
                if ([[detailDic objectForKey:SOURCE_DATA_NAME_COULUM] isEqualToString:@""]) {
                    isNext = NO;
                    [message appendFormat:@"%@不能为空,请选择%@!",title,title];
                    break;
                }
            }
            
            [customerData setObject:[detailDic objectForKey:SOURCE_DATA_ID_COLUM]
                             forKey:title];
        }else if ([dataType isEqualToString:CUSTOMER_TEXTFIELD_TYPE]){
            UITextField *detailField = [itemData objectForKey:CELL_CUSTOMER_TEXTFIELD];
            NSString *title = [itemData objectForKey:PLUS_CUSTOMER_TITLE];
            NSString *detailText = detailField.text;
            NSString *plusForce = [itemData objectForKey:PLUS_VALUE_IS_PUT_FORCE];
            if ([plusForce isEqualToString:PUT_FORCE_YES]) {
                if (detailText == nil || [detailText isEqualToString:@""]) {
                    isNext = NO;
                    [message appendFormat:@"%@不能为空,请输入%@!",title,title];
                    break;
                }
            }
            
            [customerData setObject:detailText forKey:title];
            
        }else if ([dataType isEqualToString:CUSTOMER_TEXTVIEW_TYPE]){
            UITextView *detailField = [itemData objectForKey:CELL_CUSTOMER_TEXTFIELD];
            NSString *title = [itemData objectForKey:PLUS_CUSTOMER_TITLE];
            NSString *detailText = detailField.text;
            NSString *plusForce = [itemData objectForKey:PLUS_VALUE_IS_PUT_FORCE];
            if ([plusForce isEqualToString:PUT_FORCE_YES]) {
                if (detailText == nil || [detailText isEqualToString:@""]) {
                    isNext = NO;
                    [message appendFormat:@"%@不能为空,请输入%@!",title,title];
                    break;
                }
            }
            
            [customerData setObject:detailText forKey:title];
        
        }else if ([dataType isEqualToString:CUSTOMER_DATE_SELECT_TYPE]){
            NSString *title = [itemData objectForKey:PLUS_CUSTOMER_TITLE];
            NSString *detailText = [itemData objectForKey:PLUS_INIT_VALUE];
            NSString *plusForce = [itemData objectForKey:PLUS_VALUE_IS_PUT_FORCE];
            if ([plusForce isEqualToString:PUT_FORCE_YES]) {
                if (detailText == nil || [detailText isEqualToString:@""]) {
                    isNext = NO;
                    [message appendFormat:@"%@不能为空,请选择%@!",title,title];
                    break;
                }
            }
            [customerData setObject:detailText forKey:title];
        
        }else if ([dataType isEqualToString:CUSTOMER_TIME_SELECT_TYPE]){
            NSString *title = [itemData objectForKey:PLUS_CUSTOMER_TITLE];
            NSString *detailText = [itemData objectForKey:PLUS_INIT_VALUE];
            NSString *plusForce = [itemData objectForKey:PLUS_VALUE_IS_PUT_FORCE];
            if ([plusForce isEqualToString:PUT_FORCE_YES]) {
                if (detailText == nil || [detailText isEqualToString:@""]) {
                    isNext = NO;
                    [message appendFormat:@"%@不能为空,请选择%@!",title,title];
                    break;
                }
            }
            [customerData setObject:detailText forKey:title];
        }
    }
    
    if (isNext == NO) {
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"警告"
                                                                     message:message
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        return nil;
    }
    
    return customerData;
}

//刷新选中Picker的信息
- (void)reloadViewDataWithSelectRow:(NSInteger)row
{
    NSMutableDictionary *data = [self.itemShowList objectAtIndex:self.selectViewRow];
    [data setObject:[NSNumber numberWithInteger:row] forKey:PLUS_INIT_VALUE];
    UILabel *valueLabel = [data objectForKey:CELL_CUSTOMER_LABEL];
    valueLabel.text = [[[data objectForKey:PLUS_SELECT_DATA_SOURCE] objectAtIndex:row] objectForKey:SOURCE_DATA_NAME_COULUM];
    
}

//刷新选中时间
- (void)reloadViewDataSelectDate:(NSString *)selectDate
{
    NSMutableDictionary *data = [self.itemShowList objectAtIndex:self.selectViewRow];
    [data setObject:selectDate forKey:PLUS_INIT_VALUE];
    UILabel *valueLabel = [data objectForKey:CELL_CUSTOMER_LABEL];
    valueLabel.text = selectDate;
}
#pragma mark
#pragma mark - 获取初始值
- (NSString *)getInitValueWithDicIndex:(NSInteger)index
{
    NSDictionary *data = [self.itemShowList objectAtIndex:index];
    NSString *itemCellType = [data objectForKey:PLUS_CUSTOMER_TYPE];
    NSString *initValue;
    if ([itemCellType isEqualToString:CUSTOMER_TEXTFIELD_TYPE] || [itemCellType isEqualToString:CUSTOMER_TEXTVIEW_TYPE]) {
        if ([data objectForKey:PLUS_INIT_VALUE] != nil) {
            initValue = [data objectForKey:PLUS_INIT_VALUE];
        }else{
            initValue = @"";
        }
    }else if ([itemCellType isEqualToString:CUSTOMER_TIME_SELECT_TYPE]){
        if ([data objectForKey:PLUS_INIT_VALUE] != nil) {
            initValue = [data objectForKey:PLUS_INIT_VALUE];
        }else{
            initValue = @"";
        }
    }else if ([itemCellType isEqualToString:CUSTOMER_DATE_SELECT_TYPE]){
        if ([data objectForKey:PLUS_INIT_VALUE] != nil) {
            initValue = [data objectForKey:PLUS_INIT_VALUE];
        }else{
            initValue = @"";
        }
    }else if ([itemCellType isEqualToString:CUSTOMER_SELECT_TYPE]){
        if ([data objectForKey:PLUS_INIT_VALUE] != nil) {
            NSNumber *value = [data objectForKey:PLUS_INIT_VALUE];
            NSInteger selectIndex = [value integerValue];
            initValue = [[[data objectForKey:PLUS_SELECT_DATA_SOURCE] objectAtIndex:selectIndex] objectForKey:SOURCE_DATA_NAME_COULUM];
        }else{
            initValue = @"";
        }
    }
    
    return initValue;
}

#pragma mark
#pragma mark - 布局视图内容
- (void)setEditCustomerView
{
    NSInteger  cnt = [self.itemShowList count];
    if (self.isShowHeader) {
        [self customerCellWithTitleLabelToSuper:self.contentTable
                                          duarY:0];
    }
    for (int i=0; i<cnt; i++) {
        NSMutableDictionary *itemData = [self.itemShowList objectAtIndex:i];
        NSString *itemCellType = [itemData objectForKey:PLUS_CUSTOMER_TYPE];
        if ([itemCellType isEqualToString:CUSTOMER_TEXTFIELD_TYPE]) {
            UIView *sectionView = [self customCellWithTextFieldToSuperView:self.contentTable
                                                                     duarY:(CELL_ROW_HEIGHT*i+self.sectionHei)];
            UILabel *titleLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG];
            UITextField *textField = (UITextField *)[sectionView viewWithTag:CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG];
            
            NSString *showTitle = [[NSString alloc] initWithFormat:@"%@:",[itemData objectForKey:PLUS_CUSTOMER_TITLE]];
            titleLabel.text = showTitle;
            [showTitle release];
           
            if ([itemData objectForKey:CELL_CUSTOMER_TEXTFIELD] == nil) {
                textField.text = [self getInitValueWithDicIndex:i];
                [itemData setObject:textField forKey:CELL_CUSTOMER_TEXTFIELD];
            }
        }else if ([itemCellType isEqualToString:CUSTOMER_SELECT_TYPE]){
            UIView *sectionView = [self customerCellWithSelectViewToSuperView:self.contentTable
                                                                        duarY:(CELL_ROW_HEIGHT*i+self.sectionHei)
                                                                    buttonTag:CLICKED_BUTTON_TAG+i];
            UILabel *titleLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG];
            UILabel *valueLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG];
            
            NSString *showTitle = [[NSString alloc] initWithFormat:@"%@:",[itemData objectForKey:PLUS_CUSTOMER_TITLE]];
            titleLabel.text = showTitle;
            [showTitle release];
            
            if ([itemData objectForKey:CELL_CUSTOMER_LABEL] == nil) {
                valueLabel.text = [self getInitValueWithDicIndex:i];
                [itemData setObject:valueLabel forKey:CELL_CUSTOMER_LABEL];
            }
            
        }else if ([itemCellType isEqualToString:CUSTOMER_DATE_SELECT_TYPE]){
            UIView *sectionView = [self customerCellWithSelectViewToSuperView:self.contentTable
                                                                        duarY:(CELL_ROW_HEIGHT*i+self.sectionHei)
                                                                    buttonTag:CLICKED_BUTTON_TAG+i];
            UILabel *titleLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG];
            UILabel *valueLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG];
            
            NSString *showTitle = [[NSString alloc] initWithFormat:@"%@:",[itemData objectForKey:PLUS_CUSTOMER_TITLE]];
            titleLabel.text = showTitle;
            [showTitle release];
            
            if ([itemData objectForKey:CELL_CUSTOMER_LABEL] == nil) {
                valueLabel.text = [self getInitValueWithDicIndex:i];
                [itemData setObject:valueLabel forKey:CELL_CUSTOMER_LABEL];
            }
            
        }else if ([itemCellType isEqualToString:CUSTOMER_TIME_SELECT_TYPE]){
            UIView *sectionView = [self customerCellWithSelectViewToSuperView:self.contentTable
                                                                        duarY:(CELL_ROW_HEIGHT*i+self.sectionHei)
                                                                    buttonTag:CLICKED_BUTTON_TAG+i];
            UILabel *titleLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG];
            UILabel *valueLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG];
            
            NSString *showTitle = [[NSString alloc] initWithFormat:@"%@:",[itemData objectForKey:PLUS_CUSTOMER_TITLE]];
            titleLabel.text = showTitle;
            [showTitle release];
            
            if ([itemData objectForKey:CELL_CUSTOMER_LABEL] == nil) {
                valueLabel.text = [self getInitValueWithDicIndex:i];
                [itemData setObject:valueLabel forKey:CELL_CUSTOMER_LABEL];
            }
            
        }else if ([itemCellType isEqualToString:CUSTOMER_TEXTVIEW_TYPE]){
            UIView *sectionView = [self customerCellWithMoreTextFieldToSuper:self.contentTable
                                                                       duarY:(CELL_ROW_HEIGHT*i+self.sectionHei)];
            UILabel *titleLabel = (UILabel *)[sectionView viewWithTag:CELL_TYPE_THREE_ROW_TITLE_LABEL_TAG];
            NSString *showTitle = [[NSString alloc] initWithFormat:@"%@:",[itemData objectForKey:PLUS_CUSTOMER_TITLE]];
            titleLabel.text = showTitle;
            [showTitle release];
            
            UITextView *textField = (UITextView *)[sectionView viewWithTag:CELL_TYPE_THREE_ROW_TEXT_VIEW_TAG];
            if ([itemData objectForKey:CELL_CUSTOMER_TEXTFIELD] == nil) {
                textField.text = [self getInitValueWithDicIndex:i];
                [itemData setObject:textField forKey:CELL_CUSTOMER_TEXTFIELD];
            }

            self.sectionHei += CELL_MORE_FIELD_ROW_HEIGHT - CELL_ROW_HEIGHT;
        }
    }
    
    [self.contentTable setContentSize:CGSizeMake(DEVICE_MAINSCREEN_WIDTH, CELL_ROW_HEIGHT*cnt+self.sectionHei)];
}

#pragma mark
#pragma mark - 键盘高度获取通知
- (void)handleKeyWindowNotification:(NSNotification *)noti
{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize size = [value CGRectValue].size;
    if (self.changeFieldY > (DEVICE_MAINSCREEN_HEIGHT - size.height)) {
        CGFloat changY = self.changeFieldY - (DEVICE_MAINSCREEN_HEIGHT - size.height);
        CGPoint currentPoint = self.contentTable.contentOffset;
        CGFloat currentY = currentPoint.y;
        currentY += changY;
        
        CGPoint changePoint = CGPointMake(currentPoint.x, currentY);
        
        [self.contentTable setContentOffset:changePoint animated:YES];
        
        self.changeFieldY = 0.0f;
    }
}


#pragma mark
#pragma mark - 下键盘操作
- (void)hiddleKeyWidows
{
    NSInteger cnt = [self.itemShowList count];
    for (int i=0; i<cnt; i++) {
        NSDictionary *data = [self.itemShowList objectAtIndex:i];
        if ([[data objectForKey:PLUS_CUSTOMER_TYPE] isEqualToString:CUSTOMER_TEXTFIELD_TYPE]) {
            UITextField *detailField = [data objectForKey:CELL_CUSTOMER_TEXTFIELD];
            if (detailField != nil && [detailField isFirstResponder]) {
                [detailField resignFirstResponder];
                
//                if (i == cnt-1) {
//                    //如果是最后一个
//                }
                break;
            }
        }else if ([[data objectForKey:PLUS_CUSTOMER_TYPE] isEqualToString:CUSTOMER_TEXTVIEW_TYPE]){
            UITextView *detailField = [data objectForKey:CELL_CUSTOMER_TEXTFIELD];
            if (detailField != nil && [detailField isFirstResponder]) {
                [detailField resignFirstResponder];
                break;
            }
        }else{
            continue;
        }
    }
}

#pragma mark
#pragma mark - UIAction

- (void)handleFromTap:(UIGestureRecognizer *)tapRecognizer
{
    [self hiddleKeyWidows];
}

- (void)handleShowPickerClicked:(id)sender
{
    //下键盘
    [self hiddleKeyWidows];
    
    UIButton *clickedBtn = (UIButton *)sender;
    NSInteger index = clickedBtn.tag - CLICKED_BUTTON_TAG;
    NSDictionary  *data = [self.itemShowList objectAtIndex:index];
    NSString *itemCellType = [data objectForKey:PLUS_CUSTOMER_TYPE];
    if ([itemCellType isEqualToString:CUSTOMER_SELECT_TYPE]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerView:DidShowItemPickerWithRow:WithSource:)]) {
            self.selectViewRow = index;
            NSArray *sourceList = [[data objectForKey:PLUS_SELECT_DATA_SOURCE] valueForKeyPath:SOURCE_DATA_NAME_COULUM];
            NSInteger selectDataRow = [[data objectForKey:PLUS_INIT_VALUE] integerValue];
            [self.delegate customerView:self DidShowItemPickerWithRow:selectDataRow WithSource:sourceList];
        }
    }else if ([itemCellType isEqualToString:CUSTOMER_DATE_SELECT_TYPE]){
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerView:DidShowDate:)]) {
            self.selectViewRow = index;
            [self.delegate customerView:self DidShowDate:UIDatePickerModeDate];
        }
    }else if ([itemCellType isEqualToString:CUSTOMER_TIME_SELECT_TYPE]){
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerView:DidShowDate:)]) {
            self.selectViewRow = index;
            [self.delegate customerView:self DidShowDate:UIDatePickerModeTime];
        }
    }
}

#pragma mark
#pragma mark - 自定义View
- (UIView *)customerCellWithMoreTextFieldToSuper:(UIView *)superView duarY:(CGFloat)duarY
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    sectionView.backgroundColor = [UIColor clearColor];
    [superView addSubview:sectionView];
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.top.equalTo(superView).with.offset(duarY);
        make.height.mas_equalTo(CELL_MORE_FIELD_ROW_HEIGHT);
        make.width.equalTo(superView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.tag = CELL_TYPE_THREE_ROW_TITLE_LABEL_TAG;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView);
        make.top.equalTo(sectionView);
        make.size.mas_equalTo(CGSizeMake(65.0f, CELL_ROW_HEIGHT));
    }];
    [titleLabel release];

    
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectZero];
    inputView.image = [[UIImage imageNamed:@"input_moreline_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    [sectionView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).with.offset(70.0f);
        make.top.equalTo(sectionView).with.offset((CELL_MORE_FIELD_ROW_HEIGHT-156/2.0f)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(CELL_MORE_FIELD_ROW_HEIGHT-156/2.0f)/2.0f);
        make.right.equalTo(sectionView).with.offset(-10.0f);
    }];
    [inputView release];
    
    UITextView *txtField = [[UITextView alloc] initWithFrame:CGRectZero];
    [txtField setReturnKeyType:UIReturnKeyDone];
    [txtField setBackgroundColor:[UIColor clearColor]];
    [txtField setDelegate:self];
    txtField.tag = CELL_TYPE_THREE_ROW_TEXT_VIEW_TAG;
    txtField.textAlignment = NSTextAlignmentLeft;
    [txtField setFont:[UIFont systemFontOfSize:13.0f]];
    [sectionView addSubview:txtField];
    [txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).with.offset(74.0f);
        make.top.equalTo(sectionView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);
        make.right.equalTo(sectionView).with.offset(-14.0f);
    }];
    [txtField release];
    
    UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
    seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
    [sectionView addSubview:seperView];
    [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_MORE_FIELD_ROW_HEIGHT-1, 0, 0, 0));
    }];
    [seperView release];
    
    return sectionView;
}

- (UIView *)customerCellWithTitleLabelToSuper:(UIView *)superView duarY:(CGFloat)duarY
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    sectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"th.png"]];;
    [superView addSubview:sectionView];
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.top.equalTo(superView).with.offset(duarY);
        make.height.mas_equalTo(self.sectionHei);
        make.width.equalTo(superView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor =[UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:13.5];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.headerTitle;
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(0.5,0.5);
    titleLabel.backgroundColor = [UIColor clearColor];
    [sectionView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 0));
    }];
    [titleLabel release];
    
    return sectionView;
}

- (UIView *)customCellWithTextFieldToSuperView:(UIView *)superView duarY:(CGFloat)duarY
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    sectionView.backgroundColor = [UIColor clearColor];
    [superView addSubview:sectionView];
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.top.equalTo(superView).with.offset(duarY);
        make.height.mas_equalTo(CELL_ROW_HEIGHT);
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
        make.size.mas_equalTo(CGSizeMake(65.0f, CELL_ROW_HEIGHT));
    }];
    [titleLabel release];
    
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectZero];
    inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    [sectionView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).with.offset(70.0f);
        make.top.equalTo(sectionView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);
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
        make.top.equalTo(sectionView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);
        make.right.equalTo(sectionView).with.offset(-14.0f);
    }];
    [txtField release];
    
    UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
    seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
    [sectionView addSubview:seperView];
    [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
    }];
    [seperView release];
    
    
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
        make.height.mas_equalTo(CELL_ROW_HEIGHT);
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
        make.size.mas_equalTo(CGSizeMake(65.0f, CELL_ROW_HEIGHT));
    }];
    [titleLabel release];
    
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectZero];
    inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    [sectionView addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView.mas_right).with.offset(-150.0f);
        make.top.equalTo(sectionView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);
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
        make.top.equalTo(sectionView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
        make.bottom.equalTo(sectionView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);

    }];
    [valueLabel release];

    UIImageView *downArrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
    downArrowView.image = [UIImage imageNamed:@"down.png"];
    [sectionView addSubview:downArrowView];
    [downArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(valueLabel.mas_right).with.offset(4.0f);
        make.top.equalTo(sectionView).with.offset((CELL_ROW_HEIGHT-8)/2.0f);
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
    
    UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
    seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
    [sectionView addSubview:seperView];
    [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
    }];
    [seperView release];
    
    return sectionView;
}



#pragma mark
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerViewDidShowTextField:)]) {
        [self.delegate customerViewDidShowTextField:self];
    }
    //坐标上移
    UIView *superView = textView.superview;
    
    CGFloat y = superView.frame.origin.y;
    CGFloat contY = self.contentTable.contentOffset.y;
    
    self.changeFieldY = y+CELL_MORE_FIELD_ROW_HEIGHT-(contY)+initContentY;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}
#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerViewDidShowTextField:)]) {
        [self.delegate customerViewDidShowTextField:self];
    }
    //坐标上移
    UIView *superView = textField.superview;
    
    CGFloat y = superView.frame.origin.y;
    CGFloat contY = self.contentTable.contentOffset.y;
    NSLog(@"y=%lf,conty=%lf",y,contY);
    
    self.changeFieldY = y+CELL_ROW_HEIGHT-(contY)+initContentY;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UIButton class]] || [[touch view] isKindOfClass:[UITextField class]]) {
        return NO;
    }
    
    return YES;
}

#pragma mark
#pragma mark - AlertShowViewDelegate
- (void)alertViewWillPresent:(UIAlertController *)alertController
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerViewDidShowAlertView:)]) {
        [self.delegate customerViewDidShowAlertView:alertController];
    }
}

@end
