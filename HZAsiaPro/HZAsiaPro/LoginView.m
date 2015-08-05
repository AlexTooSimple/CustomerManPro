//
//  LoginView.m
//  HZAsiaPro
//
//  Created by wuhui on 15-3-4.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "LoginView.h"
#import "ComponentsFactory.h"

#define REMEMBER_VIEW_TAP_TAG      101

@interface LoginView()
@property (nonatomic,retain)UITextField *userField;
@property (nonatomic,retain)UITextField *passwdField;
@property (nonatomic,retain)UIButton *loginBtn;
@property (nonatomic,assign)BOOL isRememberUser;
@end

@implementation LoginView

@synthesize userField;
@synthesize passwdField;
@synthesize loginBtn;
@synthesize delegate;
@synthesize isRememberUser;

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
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_REMEMBER_USER_NAME] != nil) {
        user_Field.text = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_REMEMBER_USER_NAME];
    }
    
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
    passwd_Field.secureTextEntry = YES;
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

    //布局记住密码视图
    UIView *registerPasswdView = [[UIView alloc] initWithFrame:CGRectZero];
    registerPasswdView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:registerPasswdView];
    [registerPasswdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seperView2.mas_bottom).with.offset(5.0f);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@25);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleFromTap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [registerPasswdView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    isRememberUser = YES;
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectView.backgroundColor = [UIColor clearColor];
    selectView.tag = REMEMBER_VIEW_TAP_TAG;
    selectView.image = [UIImage imageNamed:@"bg_content_select_hover.png"];
    [registerPasswdView addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerPasswdView).with.offset(30.0f);
        make.top.equalTo(registerPasswdView).with.offset(2.5f);
        make.width.mas_equalTo(20.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    
   
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"记住用户名";
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor blackColor];
    [registerPasswdView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectView.mas_right).with.offset(8);
        make.right.equalTo(registerPasswdView).with.offset(-50);
        make.top.equalTo(registerPasswdView);
        make.bottom.equalTo(registerPasswdView);
    }];
    
    [titleLabel release];
    [selectView release];
    
    //布局登录按钮
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
        make.top.equalTo(registerPasswdView.mas_bottom).with.offset(20);
        make.centerX.equalTo(contentView);
        make.size.mas_equalTo(CGSizeMake(300.0f, 45.0f));
    }];
    
    
    [nameView release];
    [pwdView release];
    [seperView release];
    [seperView2 release];
    [registerPasswdView release];
    [contentView release];
   
}

#pragma mark
#pragma mark - UIAction
- (void)handleFromTap:(UIGestureRecognizer *)recognizer
{
    UIView *touchView = [recognizer view];
    UIImageView *selectView = (UIImageView *)[touchView viewWithTag:REMEMBER_VIEW_TAP_TAG];
    self.isRememberUser = !self.isRememberUser;
    if (self.isRememberUser) {
        selectView.image = [UIImage imageNamed:@"bg_content_select_hover.png"];
    }else{
        selectView.image = [UIImage imageNamed:@"bg_content_select_n.png"];
    }
}

- (void)login:(id)sender
{
    
    if (self.isRememberUser) {
        if (self.userField.text != nil && ![self.userField.text isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.userField.text forKey:LOGIN_REMEMBER_USER_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_REMEMBER_USER_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(loginWithUserName:Passwd:)]) {
        [self.delegate loginWithUserName:self.userField.text
                                  Passwd:self.passwdField.text];
    }
}


@end
