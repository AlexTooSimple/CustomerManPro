//
//  AlertShowView.h
//  IOSCodeTest
//
//  Created by wuhui on 14-11-20.
//  Copyright (c) 2014年 wuhui. All rights reserved.
//
// 适配IOS 8的 UIAlertView 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AlertShowViewDelegate;
@interface AlertShowView : NSObject<UIAlertViewDelegate>
{
@private
    id<AlertShowViewDelegate> alertDelegate;
    NSInteger index;  //视图的tag
    
    UIAlertView *alertView;
    UIAlertController *contentAlert;
}
#if !__has_feature(objc_arc)
@property (nonatomic ,retain) UIAlertView *alertView;
@property (nonatomic ,retain) UIAlertController *contentAlert;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,assign) id<AlertShowViewDelegate> alertDelegate;
#else
@property (nonatomic ,strong) UIAlertView *alertView;
@property (nonatomic ,strong) UIAlertController *contentAlert;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,weak) id<AlertShowViewDelegate> alertDelegate;
#endif

-(instancetype)initWithAlertViewTitle:(NSString*)title
                              message:(NSString*)message
                             delegate:(id)delegate
                                  tag:(NSInteger)tag
                    cancelButtonTitle:(NSString*)cancelButtonTitle
                    otherButtonTitles:(NSString*)otherButtonTitles,...;
- (void)show;
- (void)dismiss;
@end


@protocol AlertShowViewDelegate <NSObject>
@optional
- (void)alertShowView:(AlertShowView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)alertViewWillPresent:(UIAlertController *)alertController;
@end

