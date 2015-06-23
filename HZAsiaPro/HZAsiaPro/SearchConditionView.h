//
//  SearchConditionView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchConditionViewDelegate;

@interface SearchConditionView : UIView
{
    id<SearchConditionViewDelegate> delegate;
}
@property (nonatomic ,assign)id<SearchConditionViewDelegate> delegate;
- (void)reloadViewDate:(NSString *)showDate;
- (void)reloadViewShowData:(NSString *)showData selectRow:(NSInteger)selectRow;
- (NSDictionary *)getSearchCondition;
@end

@protocol SearchConditionViewDelegate <NSObject>
- (void)searchConditionViewDidShowItemPicker:(NSArray *)itemList WithSelectRow:(NSInteger)selectRow;
- (void)searchConditionViewDidShowDatePicker;
- (void)searchConditionViewDidShowTextField;
@end
