//
//  ActionSheetView.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/23.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActionSheetViewDelegate;

@interface ActionSheetView : NSObject
{
    id<ActionSheetViewDelegate> actionDelegate;
    NSInteger tag;  //视图的tag
@private
    UIAlertController *contentSheet;
}
#if !__has_feature(objc_arc)
@property (nonatomic ,retain) UIAlertController *contentSheet;
@property (nonatomic ,assign) NSInteger tag;
@property (nonatomic ,assign) id<ActionSheetViewDelegate> actionDelegate;
#else
@property (nonatomic ,strong) UIAlertController *contentSheet;
@property (nonatomic ,assign) NSInteger tag;
@property (nonatomic ,weak) id<ActionSheetViewDelegate> actionDelegate;
#endif
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<ActionSheetViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelTitle
       destructiveButtonTitle:(NSString *)destructiveTitle
            otherButtonTitles:(NSString *)otherTitle, ...;
- (void)show;
@end

@protocol ActionSheetViewDelegate <NSObject>
- (void)actionSheetView:(ActionSheetView *)sheetView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)actionSheetViewWillPresent:(UIAlertController *)alertController;
@end
