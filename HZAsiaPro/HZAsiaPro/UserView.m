//
//  UserView.m
//  HZAsiaPro
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "UserView.h"

#define labOneTag   111
#define labTwoTag   222

@implementation UserView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)reloadView {
    [self.tbvHome performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)setUpView{
    self.tabMDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.tbvHome = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT - 64 -50) style:UITableViewStylePlain];
    self.tbvHome.delegate = self;
    self.tbvHome.dataSource = self;
    self.tbvHome.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvHome.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tbvHome];
    [self reloadView];
}

- (void)dealloc{
    [self.tabMDic release];
    [self.tbvHome release];
    [super dealloc];
}

- (void)setLabOne:(NSString *)one LabTwo:(NSString *)two Withlab:(UILabel *)labOne otherlab:(UILabel *)labTwo {
    if ([one isEqualToString:@"code"]) {
        labOne.text = @"业务员编码";
        labTwo.text = two;
    } else if([one isEqualToString:@"username"]) {
        labOne.text = @"用户名";
        labTwo.text = two;
    } else if([one isEqualToString:@"password"]) {
        labOne.text = @"密码";
        labTwo.text = two;
    } else if([one isEqualToString:@"status"]) {
        labOne.text = @"状态";
        labTwo.text = two;
    } else if([one isEqualToString:@"isadmin"]) {
        labOne.text = @"是否管理员";
        labTwo.text = [two isEqualToString:@"1"]?@"是":@"否";
    } else if([one isEqualToString:@"ownname"]) {
        labOne.text = @"姓名";
        labTwo.text = two;
    } else if([one isEqualToString:@"phone"]) {
        labOne.text = @"电话";
        labTwo.text = two;
    }  else {
        labOne.text = one;
        labTwo.text = two;
    }
}

#pragma mark tableviewDele & tableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.tabMDic allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_MAINSCREEN_WIDTH *1/4 , 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentRight;
        lab.tag = labOneTag;
        [cell addSubview:lab];
        [lab release];
        
        UILabel *labTwo = [[UILabel alloc] initWithFrame:CGRectMake(20+DEVICE_MAINSCREEN_WIDTH *1/4, 0,DEVICE_MAINSCREEN_WIDTH *3/5 , 44)];
        labTwo.backgroundColor = [UIColor clearColor];
        labTwo.font = [UIFont systemFontOfSize:14];
        labTwo.textAlignment = NSTextAlignmentLeft;
        labTwo.tag = labTwoTag;
        [cell addSubview:labTwo];
        [labTwo release];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, DEVICE_MAINSCREEN_WIDTH, 1)];
        view.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell addSubview:view];
        [view release];
    }
    UILabel *labOne = (UILabel *)[cell viewWithTag:labOneTag];
    UILabel *labTwo = (UILabel *)[cell viewWithTag:labTwoTag];
    NSString *str1 = [NSString stringWithFormat:@"%@",[[self.tabMDic allKeys] objectAtIndex:indexPath.row]];
    NSString *str2 = [NSString stringWithFormat:@"%@",[self.tabMDic objectForKey:str1]];
    [self setLabOne:str1 LabTwo:str2 Withlab:labOne otherlab:labTwo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
