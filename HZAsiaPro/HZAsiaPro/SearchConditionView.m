//
//  SearchConditionView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "SearchConditionView.h"
#import "ComponentsFactory.h"

typedef enum BussinessType{
    click_visit_type,
    click_sale_man,
    click_client_type,
    click_sale_status,
} BussineType;

typedef enum ClickedDateType{
    startDate_from,
    startDate_to,
    endDate_from,
    endDate_to,
} ClickedDateType;

#define CONDITION_VIEW_WIDTH                270.0f
#define SECTION_VIEW_HEIGHT                 40.0f
#define CELL_VIEW_HEIGHT                    40.0f
#define SECTION_CONTNET_HEIGHT              30.0f
#define DATA_CONTENT_HEIGHT                 80.0f


#define CONDITION_INPUT_VIEW_TAG            102
#define CONDITION__DOWN_VIEW_TAG            104
#define CONDITION__FIELD_TAG                101
#define CONDITION__LABEL_TAG                103

#define SINGLE_CLICKED_BUTTON_BASE_TAG      200

#define DATE_CLICKED_BUTTON_BASE_TAG        300

@interface SearchConditionView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *contentTable;
    
    BOOL isChangeCustomer;
    
    UITextField *nameField;
    UITextField *phoneField;
    
    UITextField *startDateFromField;
    UITextField *startDateToField;
    UITextField *endDateFromField;
    UITextField *endDateToField;
    
    
    UILabel *visitTypeLabel;
    UILabel *salesmanLabel;
    UILabel *clientTypeLabel;
    UILabel *saleStatusLabel;
    
    UILabel *purposeLabel;
    
    
    //中间缓冲变量
    BussineType clickedBussiness;
    ClickedDateType dateType;
}
@property (nonatomic ,retain)UITableView *contentTable;
@property (nonatomic ,assign)BOOL isChangeCustomer;

@property (nonatomic ,retain)UITextField *nameField;
@property (nonatomic ,retain)UITextField *phoneField;
@property (nonatomic ,retain)UITextField *startDateFromField;
@property (nonatomic ,retain)UITextField *startDateToField;
@property (nonatomic ,retain)UITextField *endDateFromField;
@property (nonatomic ,retain)UITextField *endDateToField;

@property (nonatomic ,retain)UILabel *visitTypeLabel;
@property (nonatomic ,retain)UILabel *salesmanLabel;
@property (nonatomic ,retain)UILabel *clientTypeLabel;
@property (nonatomic ,retain)UILabel *saleStatusLabel;
@property (nonatomic ,retain)UILabel *purposeLabel;

@property (nonatomic ,assign)BussineType clickedBussiness;
@property (nonatomic ,assign)ClickedDateType dateType;

@end

@implementation SearchConditionView

@synthesize contentTable;
@synthesize isChangeCustomer;

@synthesize nameField;
@synthesize phoneField;
@synthesize startDateFromField;
@synthesize startDateToField;
@synthesize endDateFromField;
@synthesize endDateToField;

@synthesize visitTypeLabel;
@synthesize salesmanLabel;
@synthesize clientTypeLabel;
@synthesize saleStatusLabel;

@synthesize purposeLabel;

@synthesize clickedBussiness;
@synthesize dateType;

@synthesize delegate;

- (void)dealloc
{
    [nameField release];
    [phoneField release];
    [startDateToField release];
    [startDateFromField release];
    [endDateToField release];
    [endDateFromField release];
    
    [visitTypeLabel release];
    [saleStatusLabel release];
    [salesmanLabel release];
    [clientTypeLabel release];
    
    [purposeLabel release];
    
    [contentTable release];
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        isChangeCustomer = NO;
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pagingEnabled = NO;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:tableView];
    self.contentTable = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    [tableView release];
}

#pragma mark
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = nil;
    switch (section) {
        case 0:
        {
            sectionView = [self customeSectionWithTextFieldWithTitle:@"客户姓名:"
                                                            WithDesc:@"请输入客户姓名"];
            
            if (self.nameField == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UITextField *txtField = (UITextField *)[inputView viewWithTag:CONDITION__FIELD_TAG];
                self.nameField = txtField;
            }
        }
            break;
        case 1:
        {
            sectionView = [self customeSectionWithTextFieldWithTitle:@"手机号码:"
                                                            WithDesc:@"请输入手机号码"];
            if (self.phoneField == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UITextField *txtField = (UITextField *)[inputView viewWithTag:CONDITION__FIELD_TAG];
                self.phoneField = txtField;
            }
        }
            break;
        case 2:
        {
            //购买意向
            sectionView = [self customerSectionChangeViewWithTitle:@"购买意向:"];
            if (self.purposeLabel == nil) {
                UILabel *txtField = (UILabel *)[sectionView viewWithTag:CONDITION__LABEL_TAG];
                self.purposeLabel = txtField;
            }
        }
            break;
        case 3:
        {
            sectionView = [self customerSectionDataSelectWithTitle:@"初访时间:"
                                                       WithFromTag:DATE_CLICKED_BUTTON_BASE_TAG+startDate_from
                                                             ToTag:DATE_CLICKED_BUTTON_BASE_TAG+startDate_to];
            if (self.startDateFromField == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UITextField *txtField = (UITextField *)[inputView viewWithTag:CONDITION__FIELD_TAG];
                self.startDateFromField = txtField;
            }
            if (self.startDateToField == nil) {
                UIView *downView = [sectionView viewWithTag:CONDITION__DOWN_VIEW_TAG];
                UITextField *txtField = (UITextField *)[downView viewWithTag:CONDITION__FIELD_TAG];
                self.startDateToField = txtField;
            }
        }
            break;
        case 4:
        {
            //最后来访时间
            sectionView = [self customerSectionDataSelectWithTitle:@"最后来访时间:"
                                                       WithFromTag:DATE_CLICKED_BUTTON_BASE_TAG+endDate_from
                                                             ToTag:DATE_CLICKED_BUTTON_BASE_TAG+endDate_to];
            if (self.endDateFromField == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UITextField *txtField = (UITextField *)[inputView viewWithTag:CONDITION__FIELD_TAG];
                self.endDateFromField = txtField;
            }
            if (self.endDateToField == nil) {
                UIView *downView = [sectionView viewWithTag:CONDITION__DOWN_VIEW_TAG];
                UITextField *txtField = (UITextField *)[downView viewWithTag:CONDITION__FIELD_TAG];
                self.endDateToField = txtField;
            }
        }
            break;
        case 5:
        {
            sectionView = [self customerSectionSelectViewWithTitle:@"访问类型:"
                                                           withTag:SINGLE_CLICKED_BUTTON_BASE_TAG + click_visit_type];
            if (self.visitTypeLabel == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
                self.visitTypeLabel = txtField;
            }
        }
            break;
        case 6:
        {
            sectionView = [self customerSectionSelectViewWithTitle:@"业务员:"
                                                           withTag:SINGLE_CLICKED_BUTTON_BASE_TAG + click_sale_man];
            if (self.salesmanLabel == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
                self.salesmanLabel = txtField;
            }
        }
            break;
        case 7:
        {
            sectionView = [self customerSelectSlideViewWithTitle:@"变动客户:"];
        }
            break;
            
        case 8:
        {
            sectionView = [self customerSectionSelectViewWithTitle:@"客户类别:"
                                                           withTag:SINGLE_CLICKED_BUTTON_BASE_TAG + click_client_type];
            if (self.clientTypeLabel == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
                self.clientTypeLabel = txtField;
            }
        }
            break;
        case 9:
        {
            sectionView = [self customerSectionSelectViewWithTitle:@"销售情况:"
                                                           withTag:SINGLE_CLICKED_BUTTON_BASE_TAG + click_sale_status];
            if (self.saleStatusLabel == nil) {
                UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
                UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
                self.saleStatusLabel = txtField;
            }
        }
            break;
        default:
            break;
    }
    
    if (section != 9) {
        CGFloat sectionHei = SECTION_VIEW_HEIGHT - 1;
        if (section == 3 || section == 4) {
            sectionHei = DATA_CONTENT_HEIGHT - 1;
        }
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHei, CONDITION_VIEW_WIDTH, 1)];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [sectionView addSubview:seperView];
        [seperView release];
    }
    
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 2) {
//        return 4;
//    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3 || section == 4) {
        return DATA_CONTENT_HEIGHT;
    }
    return SECTION_VIEW_HEIGHT;
}

#pragma mark
#pragma mark - 自定义SectionView
- (UIView *)customeSectionWithTextFieldWithTitle:(NSString *)title WithDesc:(NSString *)desc
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CONDITION_VIEW_WIDTH, SECTION_VIEW_HEIGHT)] autorelease];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, SECTION_VIEW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectMake(70, 5, CONDITION_VIEW_WIDTH-70-10, SECTION_CONTNET_HEIGHT)];
    inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    inputView.tag = CONDITION_INPUT_VIEW_TAG;
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(4, 0, CONDITION_VIEW_WIDTH-70-14, SECTION_CONTNET_HEIGHT)];
    [txtField setReturnKeyType:UIReturnKeyDone];
    [txtField setBackgroundColor:[UIColor clearColor]];
    [txtField setBorderStyle:UITextBorderStyleNone];
    txtField.tag = CONDITION__FIELD_TAG;
//    [txtField setDelegate:self];
    [txtField setReturnKeyType:UIReturnKeyDone];
    [txtField setFont:[UIFont systemFontOfSize:13.0f]];
    [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [txtField setPlaceholder:desc];
    [inputView addSubview:txtField];
    [txtField release];
    
    [sectionView addSubview:inputView];
    [inputView release];
    
    
    return sectionView;
}

- (UIView *)customerSectionDataSelectWithTitle:(NSString *)title WithFromTag:(NSInteger)fromTag ToTag:(NSInteger)toTag
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CONDITION_VIEW_WIDTH, DATA_CONTENT_HEIGHT)] autorelease];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, SECTION_VIEW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel release];
    
    //布局开始时间
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectMake(70, 5, CONDITION_VIEW_WIDTH-70-10, SECTION_CONTNET_HEIGHT)];
    inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    inputView.tag = CONDITION_INPUT_VIEW_TAG;
    
    UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(4, 0, CONDITION_VIEW_WIDTH-70-14, SECTION_CONTNET_HEIGHT)];
    [txtField setReturnKeyType:UIReturnKeyDone];
    [txtField setBackgroundColor:[UIColor clearColor]];
    [txtField setBorderStyle:UITextBorderStyleNone];
    txtField.userInteractionEnabled = NO;
    txtField.tag = CONDITION__FIELD_TAG;
    [txtField setFont:[UIFont systemFontOfSize:13.0f]];
    [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [inputView addSubview:txtField];
    [txtField release];
    
    UIImageView *downArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CONDITION_VIEW_WIDTH-70-10-16, (SECTION_CONTNET_HEIGHT - 16/2.0f)/2.0f, 23/2.0f, 16/2.0f)];
    downArrowView.image = [UIImage imageNamed:@"down.png"];
    [inputView addSubview:downArrowView];
    [downArrowView release];
    
    [sectionView addSubview:inputView];
    [inputView release];
    
    UIButton *clickedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickedBtn.frame = CGRectMake(70, 5, CONDITION_VIEW_WIDTH-70-10, SECTION_CONTNET_HEIGHT);
    clickedBtn.backgroundColor = [UIColor clearColor];
    clickedBtn.tag = fromTag;
    [clickedBtn addTarget:self
                   action:@selector(clickedFromDate:)
         forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:clickedBtn];
    
    //布局结束时间
    UIImageView *downView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 45, CONDITION_VIEW_WIDTH-70-10, SECTION_CONTNET_HEIGHT)];
    downView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    downView.userInteractionEnabled=YES;
    downView.tag = CONDITION__DOWN_VIEW_TAG;
    
    txtField = [[UITextField alloc] initWithFrame:CGRectMake(4, 0, CONDITION_VIEW_WIDTH-70-14, SECTION_CONTNET_HEIGHT)];
    [txtField setReturnKeyType:UIReturnKeyDone];
    txtField.tag = CONDITION__FIELD_TAG;
    [txtField setBackgroundColor:[UIColor clearColor]];
    [txtField setBorderStyle:UITextBorderStyleNone];
    txtField.userInteractionEnabled = NO;
    [txtField setFont:[UIFont systemFontOfSize:13.0f]];
    [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [downView addSubview:txtField];
    [txtField release];
    
    downArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CONDITION_VIEW_WIDTH-70-10-16, (SECTION_CONTNET_HEIGHT - 16/2.0f)/2.0f, 23/2.0f, 16/2.0f)];
    downArrowView.image = [UIImage imageNamed:@"down.png"];
    [downView addSubview:downArrowView];
    [downArrowView release];
    
    [sectionView addSubview:downView];
    [downView release];
    
    UIButton *clickedToBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickedToBtn.frame = CGRectMake(70, 45, CONDITION_VIEW_WIDTH-70-10, SECTION_CONTNET_HEIGHT);
    clickedToBtn.backgroundColor = [UIColor clearColor];
    clickedToBtn.tag = toTag;
    [clickedToBtn addTarget:self
                     action:@selector(clickedToDate:)
           forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:clickedToBtn];
    
    
    return sectionView;
}


- (UIView *)customerSectionSelectViewWithTitle:(NSString *)title withTag:(NSInteger)tag
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CONDITION_VIEW_WIDTH, SECTION_VIEW_HEIGHT)] autorelease];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, SECTION_VIEW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel release];
 
    UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectMake(70, 5, CONDITION_VIEW_WIDTH-70-10, SECTION_CONTNET_HEIGHT)];
    inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
    inputView.userInteractionEnabled=YES;
    inputView.tag = CONDITION_INPUT_VIEW_TAG;
    
    UILabel *txtField = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, CONDITION_VIEW_WIDTH-70-14, SECTION_CONTNET_HEIGHT)];
    [txtField setBackgroundColor:[UIColor clearColor]];
    txtField.userInteractionEnabled = NO;
    txtField.tag = CONDITION__LABEL_TAG;
    [txtField setFont:[UIFont systemFontOfSize:13.0f]];
    txtField.contentMode = UIViewContentModeCenter;
    txtField.textAlignment = NSTextAlignmentLeft;
    [inputView addSubview:txtField];
    [txtField release];
    
    UIImageView *downArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CONDITION_VIEW_WIDTH-70-10-16, (SECTION_CONTNET_HEIGHT - 16/2.0f)/2.0f, 23/2.0f, 16/2.0f)];
    downArrowView.image = [UIImage imageNamed:@"down.png"];
    [inputView addSubview:downArrowView];
    [downArrowView release];
    
    [sectionView addSubview:inputView];
    [inputView release];
    
    UIButton *clickedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickedBtn.frame = CGRectMake(0, 0, CONDITION_VIEW_WIDTH, SECTION_VIEW_HEIGHT);
    clickedBtn.backgroundColor = [UIColor clearColor];
    clickedBtn.tag = tag;
    [clickedBtn addTarget:self
                   action:@selector(selectBtnClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:clickedBtn];

    
    return sectionView;

}

- (UIView *)customerSectionChangeViewWithTitle:(NSString *)title
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CONDITION_VIEW_WIDTH, SECTION_VIEW_HEIGHT)] autorelease];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, SECTION_VIEW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, CONDITION_VIEW_WIDTH-70-30, SECTION_VIEW_HEIGHT)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.text = title;
    valueLabel.tag = CONDITION__LABEL_TAG;
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.font = [UIFont systemFontOfSize:13.0f];
    valueLabel.adjustsFontSizeToFitWidth = YES;
    valueLabel.textColor = [ComponentsFactory createColorByHex:@"#F9C600"];
    [sectionView addSubview:valueLabel];
    [valueLabel release];
    
    UIImageView *downArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(CONDITION_VIEW_WIDTH-30+(30-23/2.0f)/2.0f, (SECTION_VIEW_HEIGHT - 16/2.0f)/2.0f, 23/2.0f, 16/2.0f)];
    downArrowView.image = [UIImage imageNamed:@"down.png"];
    [sectionView addSubview:downArrowView];
    [downArrowView release];
    
    return sectionView;
}

- (UIView *)customerSelectSlideViewWithTitle:(NSString *)title
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CONDITION_VIEW_WIDTH, SECTION_VIEW_HEIGHT)] autorelease];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, SECTION_VIEW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = [UIColor blackColor];
    [sectionView addSubview:titleLabel];
    [titleLabel release];

    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(CONDITION_VIEW_WIDTH - 70, 5, 50, SECTION_CONTNET_HEIGHT)];
    [switchView setOn:isChangeCustomer];
    [switchView addTarget:self
                   action:@selector(switchClicked:)
         forControlEvents:UIControlEventValueChanged];
    [sectionView addSubview:switchView];
    [switchView release];
    
    return sectionView;
}


#pragma mark
#pragma mark - InterFace
- (void)reloadViewDate:(NSString *)showDate
{
    switch (dateType) {
        case startDate_from:
        {
            self.startDateFromField.text = showDate;
        }
            break;
        case startDate_to:
        {
            self.startDateToField.text = showDate;
        }
            break;
        case endDate_from:
        {
            self.endDateFromField.text = showDate;
        }
            break;
        case endDate_to:
        {
            self.endDateToField.text = showDate;
        }
            break;
        default:
            break;
    }
}
- (void)reloadViewShowData:(NSString *)showData
{
    switch (clickedBussiness) {
        case click_client_type:
        {
            self.clientTypeLabel.text = showData;
        }
            break;
        case click_sale_man:
        {
            self.salesmanLabel.text = showData;
        }
            break;
        case click_visit_type:
        {
            self.visitTypeLabel.text = showData;
        }
            break;
        case click_sale_status:
        {
            self.saleStatusLabel.text = showData;
        }
            break;
        default:
            break;
    }

}

#pragma mark
#pragma mark - UIAction
- (void)switchClicked:(id)sender
{
    UISwitch *switchBtn = (UISwitch *)sender;
    self.isChangeCustomer = switchBtn.isOn;
}

- (void)clickedFromDate:(id)sender
{
    UIButton *clickBtn = (UIButton *)sender;
    self.dateType = (ClickedDateType)(clickBtn.tag - DATE_CLICKED_BUTTON_BASE_TAG);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchConditionViewDidShowDatePicker)]) {
        [self.delegate searchConditionViewDidShowDatePicker];
    }
}

- (void)clickedToDate:(id)sender
{
    UIButton *clickBtn = (UIButton *)sender;
    self.dateType = (ClickedDateType)(clickBtn.tag - DATE_CLICKED_BUTTON_BASE_TAG);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchConditionViewDidShowDatePicker)]) {
        [self.delegate searchConditionViewDidShowDatePicker];
    }
}

- (void)selectBtnClicked:(id)sender
{
    UIButton *clickedBtn = (UIButton *)sender;
    NSInteger index = clickedBtn.tag - SINGLE_CLICKED_BUTTON_BASE_TAG;
    NSArray *itemList = nil;
    switch (index) {
        case 0:
        {
            self.clickedBussiness = click_visit_type;
        }
            break;
        case 1:
        {
            self.clickedBussiness = click_sale_man;
        }
            break;
        case 2:
        {
            self.clickedBussiness = click_client_type;
        }
            break;
        case 3:
        {
            self.clickedBussiness = click_sale_status;
        }
            break;
        default:
            break;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchConditionViewDidShowItemPicker:)]) {
        [self.delegate searchConditionViewDidShowItemPicker:itemList];
    }
    
    [itemList release];
}

@end
