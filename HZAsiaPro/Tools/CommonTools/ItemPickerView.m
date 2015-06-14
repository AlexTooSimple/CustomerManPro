//
//  ItemPickerView.m
//  SaleToolsKit
//
//  Created by wuhui on 14-7-14.
//
//

#import "ItemPickerView.h"

@implementation ItemPickerView

@synthesize itemAry;
@synthesize itemPicker;
@synthesize delegate;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (itemPicker != nil) {
        [itemPicker release];
    }
    
    if (itemAry != nil) {
        [itemAry release];
    }
    
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        selectRow = -1;
        
        openRect = frame;
        closeRect = CGRectMake(openRect.origin.x, DEVICE_MAINSCREEN_HEIGHT, openRect.size.width, openRect.size.height);
        self.frame = closeRect;
        
        isShow = NO;
        float y = 44;
        float width = frame.size.width;
        float height = frame.size.height;
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, y, width, height)];
        picker.showsSelectionIndicator = YES;
        picker.delegate = self;
        picker.dataSource = self;
        picker.backgroundColor = [UIColor whiteColor];
        self.itemPicker =  picker;
        [self addSubview:picker];
        
        UINavigationBar *nav=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, y)];
        nav.barStyle = UIBarStyleBlack;
        UINavigationItem *item=[[UINavigationItem alloc] init];
        
        UIBarButtonItem *btnOK = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(clickSubmit)];
        
        UIBarButtonItem *btnCancel= [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(clickCancel)];
        item.rightBarButtonItem=btnOK;
        item.leftBarButtonItem=btnCancel;
        
        
        
        [nav pushNavigationItem:item animated:YES];
        
        [self addSubview:nav];
        
#if !__has_feature(objc_arc)
        [btnOK release];
        [btnCancel release];
        [item release];
        [nav release];
#endif
    }
    return self;
}


#pragma mark
#pragma mark - 刷新数据
- (void)reloadPickerData:(NSArray *)itemDatas
{
    selectRow = -1;
    self.itemAry = itemDatas;
    [self.itemPicker reloadAllComponents];
}

- (void)selectPickerRow:(NSInteger)row
{
    [self.itemPicker selectRow:row inComponent:0 animated:YES];
}

#pragma mark
#pragma mark - UIAction
-(void)clickSubmit
{
    [self dismiss];
    if (selectRow != -1) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(itemPickerView:selectRow:selectData:)]) {
            NSString *itemStr = [self.itemAry objectAtIndex:selectRow];
            [self.delegate itemPickerView:self selectRow:selectRow selectData:itemStr];
        }
    }
}

-(void)clickCancel
{
    [self dismiss];
}

#pragma mark
#pragma mark - 界面显示控制
-(void)show
{
    if (isShow == NO){
        isShow = YES;
        
        [UIView beginAnimations:@"showPicker" context:nil];
        [UIView setAnimationDuration:0.4f];
        self.frame=openRect;
        [UIView commitAnimations];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(viewDidShow:)]) {
            [self.delegate viewDidShow:self];
        }
    }
}


-(void)dismiss
{
    if (isShow == YES){
        isShow = NO;
        
        [UIView beginAnimations:@"showPicker" context:nil];
        [UIView setAnimationDuration:0.4f];
        self.frame=closeRect;
        [UIView commitAnimations];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(viewDidDismiss:)]) {
            [self.delegate viewDidDismiss:self];
        }
    }
}

#pragma mark
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.itemAry count];
}

#pragma mark
#pragma mark - UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.itemAry objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow = row;
}

@end
