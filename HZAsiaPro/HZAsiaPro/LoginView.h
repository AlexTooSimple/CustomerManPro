//
//  LoginView.h
//  HZAsiaPro
//
//  Created by wuhui on 15-3-4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate <NSObject>
- (void)loginWithUserName:(NSString *)userName Passwd:(NSString *)passWd;
@end

@interface LoginView : UIView
{
    id<LoginViewDelegate> delegate;
    NSInteger count;
}
@property (nonatomic ,assign) id<LoginViewDelegate> delegate;
@end

