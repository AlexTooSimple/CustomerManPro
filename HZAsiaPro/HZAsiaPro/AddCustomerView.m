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

#define CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG       101
#define CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG        102


#define CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG       103
#define CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG       104


#define CELL_CUSTOMER_TEXTFIELD                 @"detailField"


@implementation AddCustomerView

@synthesize contentTable;
@synthesize itemShowList;
@synthesize delegate;
@synthesize changeFieldY;

- (void)dealloc
{
    [contentTable release];
    if (itemShowList != nil) {
        [itemShowList release];
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyWindowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

}




- (void)reloadCustomerView:(NSMutableArray *)itemDatas
{
    self.itemShowList = itemDatas;
    
    [self.contentTable reloadData];
}

- (NSDictionary *)commitGetAllCustomerData
{
    NSMutableDictionary *customerData = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    return customerData;
}


#pragma mark
#pragma mark - 键盘高度获取通知
- (void)handleKeyWindowNotification:(NSNotification *)noti
{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize size = [value CGRectValue].size;
//    NSLog(@"size.w=%lf,size.h=%lf",size.width,size.height);
    
    if (self.changeFieldY > (DEVICE_MAINSCREEN_HEIGHT - size.height)) {
        CGFloat changY = self.changeFieldY - (DEVICE_MAINSCREEN_HEIGHT - size.height);
        CGPoint currentPoint = self.contentTable.contentOffset;
        CGFloat currentY = currentPoint.y;
        currentY += changY;
        
        CGPoint changePoint = CGPointMake(currentPoint.x, currentY);
        
        [self.contentTable setContentOffset:changePoint animated:YES];
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
                break;
            }
        }else{
            continue;
        }
    }
}


#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemShowList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

#pragma mark
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSMutableDictionary *itemData = [self.itemShowList objectAtIndex:row];
    NSString *itemCellType = [itemData objectForKey:PLUS_CUSTOMER_TYPE];
    UITableViewCell *cell = nil;
    if ([itemCellType isEqualToString:CUSTOMER_TEXTFIELD_TYPE]) {
        cell = [self customCellWithTextFieldToTableView:tableView];
        
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG];
        NSString *showTitle = [[NSString alloc] initWithFormat:@"%@:",[itemData objectForKey:PLUS_CUSTOMER_TITLE]];
        titleLabel.text = showTitle;
        [showTitle release];
        if ([itemData objectForKey:CELL_CUSTOMER_TEXTFIELD] == nil) {
            UITextField *textField = (UITextField *)[cell.contentView viewWithTag:CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG];
            [itemData setObject:textField forKey:CELL_CUSTOMER_TEXTFIELD];
        }
        
    }else if ([itemCellType isEqualToString:CUSTOMER_SELECT_TYPE]){
        cell = [self customerCellWithSelectViewToTableView:tableView];
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG];
        NSString *showTitle = [[NSString alloc] initWithFormat:@"%@:",[itemData objectForKey:PLUS_CUSTOMER_TITLE]];
        titleLabel.text = showTitle;
        [showTitle release];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //下键盘
    [self hiddleKeyWidows];
    
    NSInteger row = [indexPath row];
    NSDictionary  *data = [self.itemShowList objectAtIndex:row];
    NSString *itemCellType = [data objectForKey:PLUS_CUSTOMER_TYPE];
    if ([itemCellType isEqualToString:CUSTOMER_SELECT_TYPE]) {
        //时间的话跳出时间选择器
        if ([[data objectForKey:PLUS_CUSTOMER_TITLE] isEqualToString:@"出生日期"]) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerViewDidShowDate)]) {
                [self.delegate customerViewDidShowDate];
            }
        }else{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerViewDidShowItemPickerWithRow:)]) {
                [self.delegate customerViewDidShowItemPickerWithRow:row];
            }
        }
    }
}

#pragma mark
#pragma mark - 自定义CELL
- (UITableViewCell *)customCellWithTextFieldToTableView:(UITableView *)tableView
{
    static NSString *customerTextFieldAddCell = @"customerTextFieldAddCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerTextFieldAddCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:customerTextFieldAddCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.tag = CELL_TYPE_ONE_ROW_TITLE_LABEL_TAG;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(65.0f, CELL_ROW_HEIGHT));
        }];
        [titleLabel release];
        
        UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectZero];
        inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
        inputView.userInteractionEnabled=YES;
        [cell.contentView addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(70.0f);
            make.top.equalTo(cell.contentView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
            make.bottom.equalTo(cell.contentView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
        }];
        [inputView release];
        
        UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectZero];
        [txtField setReturnKeyType:UIReturnKeyDone];
        [txtField setBackgroundColor:[UIColor clearColor]];
        [txtField setBorderStyle:UITextBorderStyleNone];
        txtField.tag = CELL_TYPE_ONE_ROW_TEXT_FIELD_TAG;
        [txtField setReturnKeyType:UIReturnKeyDone];
        txtField.delegate = self;
        [txtField setFont:[UIFont systemFontOfSize:13.0f]];
        [txtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [cell.contentView addSubview:txtField];
        [txtField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(74.0f);
            make.top.equalTo(cell.contentView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
            make.bottom.equalTo(cell.contentView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);
            make.right.equalTo(cell.contentView).with.offset(-14.0f);
        }];
        [txtField release];
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
        }];
        [seperView release];
    }
    return cell;
}

- (UITableViewCell *)customerCellWithSelectViewToTableView:(UITableView *)tableView
{
    static NSString *customerSelectCell = @"customerSelectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customerSelectCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:customerSelectCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.tag = CELL_TYPE_TWO_ROW_TITLE_LABEL_TAG;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(65.0f, CELL_ROW_HEIGHT));
        }];
        [titleLabel release];
        
        UIImageView *inputView=[[UIImageView alloc] initWithFrame:CGRectZero];
        inputView.image = [[UIImage imageNamed:@"input_bg.png"] stretchableImageWithLeftCapWidth:50.0f topCapHeight:15.0f];
        inputView.userInteractionEnabled=YES;
        [cell.contentView addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_right).with.offset(-150.0f);
            make.top.equalTo(cell.contentView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
            make.bottom.equalTo(cell.contentView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);
            make.right.equalTo(cell.contentView).with.offset(-10.0f);
        }];
        [inputView release];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.tag = CELL_TYPE_TWO_ROW_VALUE_LABEL_TAG;
        valueLabel.font = [UIFont systemFontOfSize:13.0f];
        valueLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(inputView).with.offset(4.0f);
            make.right.equalTo(inputView).with.offset(-(23/2.0f+7));
            make.top.equalTo(cell.contentView).with.offset((CELL_ROW_HEIGHT-35)/2.0f);
            make.bottom.equalTo(cell.contentView).with.offset(-(CELL_ROW_HEIGHT-35)/2.0f);

        }];
        [valueLabel release];

        UIImageView *downArrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        downArrowView.image = [UIImage imageNamed:@"down.png"];
        [cell.contentView addSubview:downArrowView];
        [downArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(valueLabel.mas_right).with.offset(4.0f);
            make.top.equalTo(cell.contentView).with.offset((CELL_ROW_HEIGHT-8)/2.0f);
            make.size.mas_equalTo(CGSizeMake(23/2.0f, 16/2.0f));
        }];
        [downArrowView release];
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
        }];
        [seperView release];
    }
    return cell;
}


#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(customerViewDidShowTextField)]) {
        [self.delegate customerViewDidShowTextField];
    }
    //坐标上移
    UIView *superView = nil;
    if (IS_IOS_8_LATER) {
        superView = textField.superview.superview;
    }else{
        superView = textField.superview.superview.superview;
    }
    CGFloat y = superView.frame.origin.y;
    CGFloat contY = self.contentTable.contentOffset.y;
    
    self.changeFieldY = y+CELL_ROW_HEIGHT-(contY);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
