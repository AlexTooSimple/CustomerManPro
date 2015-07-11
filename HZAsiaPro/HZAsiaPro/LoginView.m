//
//  LoginView.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginView.h"
#import "ComponentsFactory.h"

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
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).with.offset(-80);
        make.width.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    

    //布局用户名
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectZero];
    nameView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).with.offset(5.0f);
        make.left.equalTo(contentView);
        make.height.mas_equalTo(50.0f);
        make.width.equalTo(contentView);
    }];
    
    UIImageView *userNameView = [[UIImageView alloc] initWithFrame:CGRectZero];
    userNameView.backgroundColor = [UIColor clearColor];
    userNameView.image = [UIImage imageNamed:@"login_icon_a.png"];
    [nameView addSubview:userNameView];
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView).with.offset((50-32)/2.0f);
        make.left.equalTo(nameView).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(32.0f, 32.0f));
    }];
    
    
    UITextField  *user_Field = [[UITextField alloc] initWithFrame:CGRectZero];
    user_Field.backgroundColor = [UIColor clearColor];
    user_Field.font = [UIFont systemFontOfSize:15.0f];
    user_Field.textAlignment = NSTextAlignmentLeft;
    user_Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    user_Field.contentMode = UIViewContentModeCenter;
    user_Field.placeholder = @"请输入用户名";
    user_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [nameView addSubview:user_Field];
    self.userField = user_Field;
    [user_Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView);
        make.bottom.equalTo(nameView);
        make.left.equalTo(userNameView.mas_right).with.offset(10);
        make.right.equalTo(nameView).with.offset(-40);
    }];
    
    
    [userNameView release];
    [user_Field release];
    
    
    UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
    seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
    [contentView addSubview:seperView];
    [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).with.offset(3.0f);
        make.left.equalTo(contentView).with.offset(25);
        make.right.equalTo(contentView).with.offset(-25);
        make.height.mas_equalTo(1);
    }];
    
    //布局密码页面
    UIView *pwdView = [[UIView alloc] initWithFrame:CGRectZero];
    pwdView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:pwdView];
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seperView.mas_bottom).with.offset(3.0f);
        make.left.equalTo(contentView);
        make.height.mas_equalTo(50.0f);
        make.width.equalTo(contentView);
    }];
    
    UIImageView *pwdImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    pwdImageView.backgroundColor = [UIColor clearColor];
    pwdImageView.image = [UIImage imageNamed:@"login_icon_b.png"];
    [pwdView addSubview:pwdImageView];
    [pwdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdView).with.offset((50-32)/2.0f);
        make.left.equalTo(pwdView).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(32.0f, 32.0f));
    }];
    
    UITextField  *passwd_Field = [[UITextField alloc] initWithFrame:CGRectZero];
    passwd_Field.backgroundColor = [UIColor clearColor];
    passwd_Field.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwd_Field.font = [UIFont systemFontOfSize:15.0f];
    passwd_Field.textAlignment = NSTextAlignmentLeft;
    passwd_Field.placeholder = @"请输入密码";
    passwd_Field.contentMode = UIViewContentModeCenter;
    passwd_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [pwdView addSubview:passwd_Field];
    self.passwdField = passwd_Field;
    [passwd_Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdView);
        make.bottom.equalTo(pwdView);
        make.left.equalTo(pwdImageView.mas_right).with.offset(10);
        make.right.equalTo(pwdView).with.offset(-40);
    }];
    
    [pwdImageView release];
    [passwd_Field release];
    
    UIView *seperView2 = [[UIView alloc] initWithFrame:CGRectZero];
    seperView2.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
    [contentView addSubview:seperView2];
    [seperView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdView.mas_bottom).with.offset(3.0f);
        make.left.equalTo(contentView).with.offset(25);
        make.right.equalTo(contentView).with.offset(-25);
        make.height.mas_equalTo(1);
    }];

    
    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    login_btn.backgroundColor = [UIColor clearColor];
    [login_btn setBackgroundImage:[UIImage imageNamed:@"login_button.png"]
                         forState:UIControlStateNormal];
    [login_btn setBackgroundImage:[UIImage imageNamed:@"login_button_a.png"]
                         forState:UIControlStateHighlighted];
    [login_btn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    login_btn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [login_btn addTarget:self
                  action:@selector(login:)
        forControlEvents:UIControlEventTouchUpInside];
    [login_btn setTitle:@"登录"
               forState:UIControlStateNormal];
    [contentView addSubview:login_btn];
    [login_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seperView2.mas_bottom).with.offset(30);
        make.centerX.equalTo(contentView);
        make.size.mas_equalTo(CGSizeMake(300.0f, 45.0f));
    }];
    
    
    [nameView release];
    [pwdView release];
    [seperView release];
    [seperView2 release];
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
