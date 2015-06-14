//
//  ItemPickerView.h
//  SaleToolsKit
//
//  Created by wuhui on 14-7-14.
//
//  带有确定和取消功能的 UIPickerView

#import <UIKit/UIKit.h>

@protocol ItemPickerDelegate;
@interface ItemPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *itemPicker;
    NSArray *itemAry;
    
    BOOL isShow;
    
    NSInteger selectRow;
    CGRect openRect;
    CGRect closeRect;
    
    id<ItemPickerDelegate> delegate;
}
#if !__has_feature(objc_arc)
@property (nonatomic ,retain)UIPickerView *itemPicker;
@property (nonatomic ,retain)NSArray *itemAry;
@property (nonatomic ,assign)id<ItemPickerDelegate> delegate;
#else
@property (nonatomic ,strong)UIPickerView *itemPicker;
@property (nonatomic ,strong)NSArray *itemAry;
@property (nonatomic ,weak)id<ItemPickerDelegate> delegate;
#endif

- (id)initWithFrame:(CGRect)frame;
- (void)dismiss;
- (void)show;
- (void)reloadPickerData:(NSArray *)itemDatas;
- (void)selectPickerRow:(NSInteger)row;
@end

@protocol ItemPickerDelegate <NSObject>
@optional
- (void)viewDidShow:(ItemPickerView *)itemView;
- (void)viewDidDismiss:(ItemPickerView *)itemView;

- (void)itemPickerView:(ItemPickerView *)itemPicker selectRow:(NSInteger)row selectData:(NSString *)itemStr;

@end

