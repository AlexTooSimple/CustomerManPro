//
//  AddCustomerView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/16.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CUSTOMER_TEXTFIELD_TYPE         @"1"
#define CUSTOMER_SELECT_TYPE            @"2"


#define PLUS_CUSTOMER_TITLE             @"title"
#define PLUS_CUSTOMER_TYPE              @"type"
#define PLUS_SELECT_DATA_SOURCE         @"source"

@protocol AddCustomerViewDelegate;
@interface AddCustomerView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *contentTable;
    NSMutableArray  *itemShowList;

    id<AddCustomerViewDelegate> delegate;
    
    CGFloat changeFieldY;
}
@property (nonatomic ,retain)UITableView *contentTable;
@property (nonatomic ,retain)NSMutableArray *itemShowList;
@property (nonatomic ,assign)id<AddCustomerViewDelegate> delegate;
@property (nonatomic ,assign)CGFloat changeFieldY;

- (void)reloadCustomerView:(NSMutableArray *)itemDatas;
- (NSDictionary *)commitGetAllCustomerData;
@end


@protocol AddCustomerViewDelegate <NSObject>
- (void)customerViewDidShowItemPickerWithRow:(NSInteger)row;
- (void)customerViewDidShowDate;
- (void)customerViewDidShowTextField;
@end

