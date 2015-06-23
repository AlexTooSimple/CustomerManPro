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

#define CELL_IMAGE_VIEW_TAG                 151
#define CELL_TITLE_VIEW_TAG                 152

#define SINGLE_CLICKED_BUTTON_BASE_TAG      200

#define DATE_CLICKED_BUTTON_BASE_TAG        300

@interface SearchConditionView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *contentTable;
    
    BOOL isChangeCustomer;
    
    UITextField *nameField;
    UITextField *phoneField;
    
    UITextField *startDateFromField;
    UITextField *startDateToField;
    UITextField *endDateFromField;
    UITextField *endDateToField;
    
    NSString *purposeShowStr;
    NSInteger visitSelectRow;
    NSInteger saleStateSelectRow;
    NSInteger clientTypeSelectRow;
    
    //中间缓冲变量
    BussineType clickedBussiness;
    ClickedDateType dateType;
    BOOL isShowPurpose;
    
    //选择条件数据
    NSArray *purposeData;
    NSArray *visitDataSource;
    NSArray *saleStatesDataSource;
    NSArray *clientTypeDataSource;
}
@property (nonatomic ,retain)UITableView *contentTable;
@property (nonatomic ,assign)BOOL isChangeCustomer;

@property (nonatomic ,retain)UITextField *nameField;
@property (nonatomic ,retain)UITextField *phoneField;
@property (nonatomic ,retain)UITextField *startDateFromField;
@property (nonatomic ,retain)UITextField *startDateToField;
@property (nonatomic ,retain)UITextField *endDateFromField;
@property (nonatomic ,retain)UITextField *endDateToField;

@property (nonatomic ,retain)NSString *purposeShowStr;

@property (nonatomic ,assign)BussineType clickedBussiness;
@property (nonatomic ,assign)ClickedDateType dateType;

@property (nonatomic ,retain)NSArray *purposeData;
@property (nonatomic ,retain)NSArray *visitDataSource;
@property (nonatomic ,retain)NSArray *saleStatesDataSource;
@property (nonatomic ,retain)NSArray *clientTypeDataSource;

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

@synthesize purposeShowStr;

@synthesize clickedBussiness;
@synthesize dateType;

@synthesize delegate;

@synthesize purposeData;
@synthesize visitDataSource;
@synthesize saleStatesDataSource;
@synthesize clientTypeDataSource;

- (void)dealloc
{
    [nameField release];
    [phoneField release];
    [startDateToField release];
    [startDateFromField release];
    [endDateToField release];
    [endDateFromField release];
    
    if (purposeShowStr != nil) {
        [purposeShowStr release];
    }
    
    [contentTable release];
    
    if (purposeData != nil) {
        [purposeData release];
    }
    if (visitDataSource != nil) {
        [visitDataSource release];
    }
    if (saleStatesDataSource != nil) {
        [saleStatesDataSource release];
    }
    if (clientTypeDataSource != nil) {
        [clientTypeDataSource release];
    }
    
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        isChangeCustomer = NO;
        isShowPurpose = NO;
        
        clientTypeSelectRow = 0;
        saleStateSelectRow = 0;
        visitSelectRow = 0;
        
        [self initData];
        
        [self layoutContentView];
    }
    return self;
}

- (void)initData
{
    //购买意向数据源
    NSMutableArray *itemData = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary *purData1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"初步意向",@"title",
                                     @"0",@"select",nil];
    [itemData addObject:purData1];
    [purData1 release];
    
    NSMutableDictionary *purData2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"决定购买",@"title",
                                     @"0",@"select",nil];
    [itemData addObject:purData2];
    [purData2 release];
    
    NSMutableDictionary *purData3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"强烈意向",@"title",
                                     @"0",@"select",nil];
    [itemData addObject:purData3];
    [purData3 release];
    
    NSMutableDictionary *purData4 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"多次来访",@"title",
                                     @"0",@"select",nil];
    [itemData addObject:purData4];
    [purData4 release];
    
    self.purposeData = itemData;
    [itemData release];
    
    //来访模式数据源
    NSMutableArray *visitDatas = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *visitData1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"0",@"key",
                                @"全部",@"value",nil];
    [visitDatas addObject:visitData1];
    [visitData1 release];
    
    NSDictionary *visitData2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"1",@"key",
                                @"来访",@"value",nil];
    [visitDatas addObject:visitData2];
    [visitData2 release];
    
    NSDictionary *visitData3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"2",@"key",
                                @"来电",@"value",nil];
    [visitDatas addObject:visitData3];
    [visitData3 release];
    
    NSDictionary *visitData4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"3",@"key",
                                @"去电",@"value",nil];
    [visitDatas addObject:visitData4];
    [visitData4 release];
    
    NSDictionary *visitData5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"4",@"key",
                                @"来函",@"value",nil];
    [visitDatas addObject:visitData5];
    [visitData5 release];
    
    NSDictionary *visitData6 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"5",@"key",
                                @"其他类型",@"value",nil];
    [visitDatas addObject:visitData6];
    [visitData6 release];
    
    self.visitDataSource = visitDatas;
    [visitDatas release];
    
    //客户类型数据源
    NSMutableArray *clientTypeDatas = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *clientTypeData1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"0",@"key",
                                @"全部",@"value",nil];
    [clientTypeDatas addObject:clientTypeData1];
    [clientTypeData1 release];
    
    NSDictionary *clientTypeData2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"1",@"key",
                                @"个人客户",@"value",nil];
    [clientTypeDatas addObject:clientTypeData2];
    [clientTypeData2 release];
    
    NSDictionary *clientTypeData3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"2",@"key",
                                @"企业客户",@"value",nil];
    [clientTypeDatas addObject:clientTypeData3];
    [clientTypeData3 release];
    
    self.clientTypeDataSource = clientTypeDatas;
    [clientTypeDatas release];
    
    //销售状态数据源
    NSMutableArray *saleStateDatas = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *saleStateData1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"0",@"key",
                                     @"全部",@"value",nil];
    [saleStateDatas addObject:saleStateData1];
    [saleStateData1 release];
    
    NSDictionary *saleStateData2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"1",@"key",
                                     @"预约客户",@"value",nil];
    [saleStateDatas addObject:saleStateData2];
    [saleStateData2 release];
    
    NSDictionary *saleStateData3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"2",@"key",
                                     @"小订客户",@"value",nil];
    [saleStateDatas addObject:saleStateData3];
    [saleStateData3 release];
    
    NSDictionary *saleStateData4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"1",@"key",
                                    @"大订客户",@"value",nil];
    [saleStateDatas addObject:saleStateData4];
    [saleStateData4 release];
    
    NSDictionary *saleStateData5 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"2",@"key",
                                    @"合同客户",@"value",nil];
    [saleStateDatas addObject:saleStateData5];
    [saleStateData5 release];

    self.saleStatesDataSource = saleStateDatas;
    [saleStateDatas release];
    
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
    static NSString *staticPurposeCell = @"staticPurposeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:staticPurposeCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:staticPurposeCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectZero];
        selectView.backgroundColor = [UIColor clearColor];
        selectView.tag = CELL_IMAGE_VIEW_TAG;
        [cell.contentView addSubview:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_right).with.offset(-44.0f);
            make.top.equalTo(cell.contentView).with.offset((SECTION_CONTNET_HEIGHT - 20)/2.0f);
            make.width.mas_equalTo(20.0f);
            make.height.mas_equalTo(20.0f);
        }];
        [selectView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = CELL_TITLE_VIEW_TAG;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [ComponentsFactory createColorByHex:@"#F9C600"];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(8);
            make.right.equalTo(cell.contentView).with.offset(-50);
            make.top.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
        }];
        [titleLabel release];
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(SECTION_CONTNET_HEIGHT -1, 0, 0, 0));
        }];
        [seperView release];
    }
    
    UIImageView *selectView = (UIImageView *)[cell.contentView viewWithTag:CELL_IMAGE_VIEW_TAG];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TITLE_VIEW_TAG];
    
    NSInteger row = [indexPath row];
    NSDictionary *data = [self.purposeData objectAtIndex:row];
    
    titleLabel.text = [data objectForKey:@"title"];
    
    NSString *selectFlag = [data objectForKey:@"select"];
    if ([selectFlag isEqualToString:@"0"]) {
        selectView.image = [UIImage imageNamed:@"bg_content_select_n.png"];
    }else{
        selectView.image = [UIImage imageNamed:@"bg_content_select_hover.png"];
    }
    
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
            
            UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
            UITextField *txtField = (UITextField *)[inputView viewWithTag:CONDITION__FIELD_TAG];
            if (self.nameField == nil) {
                self.nameField = txtField;
            }else{
                txtField.text = self.nameField.text;
            }
        }
            break;
        case 1:
        {
            sectionView = [self customeSectionWithTextFieldWithTitle:@"手机号码:"
                                                            WithDesc:@"请输入手机号码"];
            UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
            UITextField *txtField = (UITextField *)[inputView viewWithTag:CONDITION__FIELD_TAG];
            if (self.phoneField == nil) {
                self.phoneField = txtField;
            }else{
                txtField.text = self.phoneField.text;
            }
        }
            break;
        case 2:
        {
            //购买意向
            sectionView = [self customerSectionChangeViewWithTitle:@"购买意向:"];
            UILabel *txtField = (UILabel *)[sectionView viewWithTag:CONDITION__LABEL_TAG];
            if (self.purposeShowStr == nil) {
                txtField.text = @"";
            }else{
                txtField.text = self.purposeShowStr;
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
            UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
            UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
            txtField.text = [[self.visitDataSource objectAtIndex:visitSelectRow] objectForKey:@"value"];
        }
            break;
        case 6:
        {
            sectionView = [self customerSectionSelectViewWithTitle:@"业务员:"
                                                           withTag:SINGLE_CLICKED_BUTTON_BASE_TAG + click_sale_man];
            UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
            UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
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
            UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
            UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
            txtField.text = [[self.clientTypeDataSource objectAtIndex:clientTypeSelectRow] objectForKey:@"value"];
        }
            break;
        case 9:
        {
            sectionView = [self customerSectionSelectViewWithTitle:@"销售情况:"
                                                           withTag:SINGLE_CLICKED_BUTTON_BASE_TAG + click_sale_status];
            UIView *inputView = [sectionView viewWithTag:CONDITION_INPUT_VIEW_TAG];
            UILabel *txtField = (UILabel *)[inputView viewWithTag:CONDITION__LABEL_TAG];
            txtField.text = [[self.saleStatesDataSource objectAtIndex:saleStateSelectRow] objectForKey:@"value"];
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 2) {
        NSMutableDictionary *data = [self.purposeData objectAtIndex:row];
        NSString *selectFlag = [data objectForKey:@"select"];
        if ([selectFlag isEqualToString:@"0"]) {
            [data setValue:@"1" forKey:@"select"];
        }else{
            [data setValue:@"0" forKey:@"select"];
        }
        
        NSMutableString *purposeStr = [[NSMutableString alloc] initWithCapacity:0];
        NSInteger cnt = [self.purposeData count];
        for (int i=0; i<cnt; i++) {
            NSDictionary *updateData = [self.purposeData objectAtIndex:i];
            if ([[updateData objectForKey:@"select"] isEqualToString:@"1"]) {
                if ([purposeStr length] == 0) {
                    [purposeStr appendFormat:@"%@",[updateData objectForKey:@"title"]];
                }else{
                    [purposeStr appendFormat:@",%@",[updateData objectForKey:@"title"]];
                }
            }else{
                continue;
            }
        }
        if ([purposeStr length] > 0) {
            self.purposeShowStr = purposeStr;
        }
        [purposeStr release];
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        if (isShowPurpose) {
            return [self.purposeData count];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 2) {
        if (isShowPurpose) {
            return SECTION_CONTNET_HEIGHT;
        }
    }
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
    [txtField setDelegate:self];
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
    sectionView.backgroundColor = [UIColor whiteColor];
    
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
    
    UIButton  *clickedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickedBtn.backgroundColor = [UIColor clearColor];
    clickedBtn.frame = CGRectMake(0, 0, CONDITION_VIEW_WIDTH, SECTION_VIEW_HEIGHT);
    [clickedBtn addTarget:self
                   action:@selector(clickedPurpose:)
         forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:clickedBtn];
    
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
- (NSDictionary *)getSearchCondition
{
    NSMutableDictionary *conditionData = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    //初访时间开始
    if (self.startDateFromField.text != nil && ![self.startDateFromField.text isEqualToString:@""]) {
        [conditionData setObject:self.startDateFromField.text forKey:@"startFromData"];
    }
    //初访时间结束
    if (self.startDateToField.text != nil && ![self.startDateToField.text isEqualToString:@""]) {
        [conditionData setObject:self.startDateToField.text forKey:@"startToData"];
    }
    //最后来访时间开始
    if (self.endDateFromField.text != nil && ![self.endDateFromField.text isEqualToString:@""]) {
        [conditionData setObject:self.endDateFromField.text forKey:@"endFromData"];
    }
    //最后来访时间结束
    if (self.endDateToField.text != nil && ![self.endDateToField.text isEqualToString:@""]) {
        [conditionData setObject:self.endDateToField.text forKey:@"endToData"];
    }
    //客户姓名
    if (self.nameField.text != nil && ![self.nameField.text isEqualToString:@""]) {
        [conditionData setObject:self.nameField.text forKey:@"name"];
    }
    //手机号码
    if (self.phoneField.text != nil && ![self.phoneField.text isEqualToString:@""]) {
        [conditionData setObject:self.phoneField.text forKey:@"phone"];
    }
    //客户类型
    [conditionData setObject:[self.clientTypeDataSource objectAtIndex:clientTypeSelectRow]
                      forKey:@"clientType"];
    //访问类型
    [conditionData setObject:[self.visitDataSource objectAtIndex:visitSelectRow]
                      forKey:@"visit"];
    //销售情况
    [conditionData setObject:[self.saleStatesDataSource objectAtIndex:saleStateSelectRow]
                      forKey:@"saleState"];
    //变动客户标识
    [conditionData setObject:[NSNumber numberWithBool:isChangeCustomer]
                      forKey:@"changeCustomer"];

    //购买意向
    NSInteger cnt = [self.purposeData count];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (int i=0; i<cnt; i++) {
        NSDictionary *data = [self.purposeData objectAtIndex:i];
        NSString *select = [data objectForKey:@"select"];
        if ([select isEqualToString:@"1"]) {
            //表示选定
            [indexSet addIndex:i];
        }
    }
    [conditionData setObject:indexSet forKey:@"purpose"];
    //业务员后期处理
    
    NSLog(@"搜索条件：%@",conditionData);
    
    return conditionData;
}

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
- (void)reloadViewShowData:(NSString *)showData selectRow:(NSInteger)selectRow
{
    switch (clickedBussiness) {
        case click_client_type:
        {
            clientTypeSelectRow = selectRow;
            [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:8]
                             withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case click_sale_man:
        {
            [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:6]
                             withRowAnimation:UITableViewRowAnimationNone];

           
        }
            break;
        case click_visit_type:
        {
            visitSelectRow = selectRow;
            [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:5]
                             withRowAnimation:UITableViewRowAnimationNone];

        }
            break;
        case click_sale_status:
        {
            saleStateSelectRow = selectRow;
            [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:9]
                             withRowAnimation:UITableViewRowAnimationNone];

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
    [self hiddleKeyWindows];
    UISwitch *switchBtn = (UISwitch *)sender;
    self.isChangeCustomer = switchBtn.isOn;
}

- (void)clickedFromDate:(id)sender
{
    [self hiddleKeyWindows];
    UIButton *clickBtn = (UIButton *)sender;
    self.dateType = (ClickedDateType)(clickBtn.tag - DATE_CLICKED_BUTTON_BASE_TAG);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchConditionViewDidShowDatePicker)]) {
        [self.delegate searchConditionViewDidShowDatePicker];
    }
}

- (void)clickedToDate:(id)sender
{
    [self hiddleKeyWindows];
    UIButton *clickBtn = (UIButton *)sender;
    self.dateType = (ClickedDateType)(clickBtn.tag - DATE_CLICKED_BUTTON_BASE_TAG);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchConditionViewDidShowDatePicker)]) {
        [self.delegate searchConditionViewDidShowDatePicker];
    }
}

- (void)selectBtnClicked:(id)sender
{
    [self hiddleKeyWindows];
    UIButton *clickedBtn = (UIButton *)sender;
    NSInteger index = clickedBtn.tag - SINGLE_CLICKED_BUTTON_BASE_TAG;
    NSArray *itemList = nil;
    NSInteger selectRow = 0;
    switch (index) {
        case 0:
        {
            self.clickedBussiness = click_visit_type;
            itemList = [self.visitDataSource valueForKeyPath:@"value"];
            selectRow = visitSelectRow;
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
            itemList = [self.clientTypeDataSource valueForKeyPath:@"value"];
            selectRow = clientTypeSelectRow;
        }
            break;
        case 3:
        {
            self.clickedBussiness = click_sale_status;
            itemList = [self.saleStatesDataSource valueForKeyPath:@"value"];
            selectRow = saleStateSelectRow;
        }
            break;
        default:
            break;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchConditionViewDidShowItemPicker:WithSelectRow:)]) {
        [self.delegate searchConditionViewDidShowItemPicker:itemList WithSelectRow:selectRow];
    }
}

- (void)clickedPurpose:(id)sender
{
    [self hiddleKeyWindows];
    isShowPurpose = !isShowPurpose;
    [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)hiddleKeyWindows
{
    if ([self.phoneField isFirstResponder]) {
        [self.phoneField resignFirstResponder];
    }
    if ([self.nameField isFirstResponder]) {
        [self.nameField resignFirstResponder];
    }
}

#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(searchConditionViewDidShowTextField)]) {
        [self.delegate searchConditionViewDidShowTextField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
