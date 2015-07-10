//
//  BaseTabView.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "BaseTabView.h"

#define labOneTag   111
#define labTwoTag   222

@implementation BaseTabView

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
//    self.tbvHome.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvHome.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tbvHome];
    [self reloadView];
}

#pragma mark tableviewDele & tableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(tableView.frame), 20)];
    headView.backgroundColor = [UIColor grayColor];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetHeight(tableView.frame)-10, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    lab.text = [[self.tabMDic allKeys] objectAtIndex:section];
    [headView addSubview:lab];
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.tabMDic allKeys] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.tabMDic objectForKey:[[self.tabMDic allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_MAINSCREEN_WIDTH *1/3 , 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentRight;
        lab.tag = labOneTag;
        [cell addSubview:lab];
        [lab release];
        
        UILabel *labTwo = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH *2/5, 0,DEVICE_MAINSCREEN_WIDTH *3/5 , 44)];
        labTwo.backgroundColor = [UIColor clearColor];
        labTwo.font = [UIFont systemFontOfSize:14];
        labTwo.textAlignment = NSTextAlignmentLeft;
        labTwo.tag = labTwoTag;
        [cell addSubview:labTwo];
    }
    UILabel *labOne = (UILabel *)[cell viewWithTag:labOneTag];
    UILabel *labTwo = (UILabel *)[cell viewWithTag:labTwoTag];
    NSArray *arr = [self.tabMDic objectForKey:[[self.tabMDic allKeys] objectAtIndex:indexPath.section]];
    labOne.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"name"];
    labTwo.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"source"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
