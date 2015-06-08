//
//  LoginView.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginView.h"
#import "PureLayout.h"

@interface LoginView()
@property (nonatomic,retain)UITextField *userField;
@property (nonatomic,retain)UITextField *passwdField;
@property (nonatomic,retain)UIButton *loginBtn;
@end

@implementation LoginView

@synthesize userField;
@synthesize passwdField;
@synthesize loginBtn;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

#pragma mark
#pragma mark - 布局视图
- (void)layoutContentView
{
    UIView *contentView = [[UIView alloc] initForAutoLayout];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    
    UILabel *userLabel = [[UILabel alloc] initForAutoLayout];
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.text = @"账号";
    userLabel.font = [UIFont systemFontOfSize:15.0f];
    userLabel.textAlignment = NSTextAlignmentRight;
    userLabel.contentMode = UIViewContentModeCenter;
    [contentView addSubview:userLabel];
    
    
    UITextField  *user_Field = [[UITextField alloc] initForAutoLayout];
    user_Field.backgroundColor = [UIColor clearColor];
    user_Field.borderStyle = UITextBorderStyleRoundedRect;
    user_Field.font = [UIFont systemFontOfSize:15.0f];
    user_Field.textAlignment = NSTextAlignmentLeft;
    user_Field.contentMode = UIViewContentModeCenter;
    user_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contentView addSubview:user_Field];
    self.userField = user_Field;
    
    
    UILabel *passwdLabel = [[UILabel alloc] initForAutoLayout];
    passwdLabel.backgroundColor = [UIColor clearColor];
    passwdLabel.text = @"密码";
    passwdLabel.font = [UIFont systemFontOfSize:15.0f];
    passwdLabel.textAlignment = NSTextAlignmentRight;
    passwdLabel.contentMode = UIViewContentModeCenter;
    [contentView addSubview:passwdLabel];
    
    
    UITextField  *passwd_Field = [[UITextField alloc] initForAutoLayout];
    passwd_Field.backgroundColor = [UIColor clearColor];
    passwd_Field.borderStyle = UITextBorderStyleRoundedRect;
    passwd_Field.font = [UIFont systemFontOfSize:15.0f];
    passwd_Field.textAlignment = NSTextAlignmentLeft;
    passwd_Field.contentMode = UIViewContentModeCenter;
    passwd_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [contentView addSubview:passwd_Field];
    self.passwdField = passwd_Field;
    
    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    login_btn.translatesAutoresizingMaskIntoConstraints = NO;
    login_btn.backgroundColor = [UIColor clearColor];
    [login_btn addTarget:self
                  action:@selector(login:)
        forControlEvents:UIControlEventTouchUpInside];
    [login_btn setTitle:@"登录"
               forState:UIControlStateNormal];
    [contentView addSubview:login_btn];
    
    //中心居中
    [contentView autoAlignAxis:ALAxisVertical
              toSameAxisOfView:self];
    [contentView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                  withInset:60];
    [contentView autoSetDimensionsToSize:CGSizeMake(290.0f, 100.0f)];
    
    [userLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 0, 80, 230.0f)];
    [userField autoPinEdge:ALEdgeLeft
                    toEdge:ALEdgeRight
                    ofView:userLabel
                withOffset:5.0f];
    [userField autoPinEdge:ALEdgeRight
                    toEdge:ALEdgeRight
                    ofView:contentView
                withOffset:5.0f
                  relation:NSLayoutRelationEqual];
    [userField autoPinEdge:ALEdgeTop
                    toEdge:ALEdgeTop
                    ofView:contentView];
    [userField autoSetDimension:ALDimensionHeight
                         toSize:20.0f];
    
    
    [passwdLabel autoPinEdge:ALEdgeTop
                      toEdge:ALEdgeBottom
                      ofView:userLabel
                  withOffset:15
                    relation:NSLayoutRelationEqual];
    [passwdLabel autoPinEdge:ALEdgeLeft
                      toEdge:ALEdgeLeft
                      ofView:userLabel];
    [passwdLabel autoMatchDimension:ALDimensionWidth
                        toDimension:ALDimensionWidth
                             ofView:userLabel];
    [passwdLabel autoMatchDimension:ALDimensionHeight
                        toDimension:ALDimensionHeight
                             ofView:userLabel];
    [passwdField autoPinEdge:ALEdgeLeft
                      toEdge:ALEdgeLeft
                      ofView:userField];
    [passwdField autoPinEdge:ALEdgeTop
                      toEdge:ALEdgeTop
                      ofView:passwdLabel];
    [passwdField autoMatchDimension:ALDimensionWidth
                        toDimension:ALDimensionWidth
                             ofView:userField];
    [passwdField autoMatchDimension:ALDimensionHeight
                        toDimension:ALDimensionHeight
                             ofView:userField];
    
    [login_btn autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                withInset:5.0f];
    [login_btn autoAlignAxis:ALAxisVertical
            toSameAxisOfView:contentView];
    [login_btn autoSetDimensionsToSize:CGSizeMake(180.0f, 20.0f)];
    
    [userLabel release];
    [passwdLabel release];
    [user_Field release];
    [passwd_Field release];
    [contentView release];
    
    
   
}

#pragma mark
#pragma mark - UIAction
- (void)login:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginWithUserName:Passwd:)]) {
        [self.delegate loginWithUserName:self.userField.text
                                  Passwd:self.passwdField.text];
    }
}


@end
