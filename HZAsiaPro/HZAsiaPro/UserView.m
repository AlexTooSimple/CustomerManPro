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
        [labTwo release];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, DEVICE_MAINSCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:view];
        [view release];
    }
    UILabel *labOne = (UILabel *)[cell viewWithTag:labOneTag];
    UILabel *labTwo = (UILabel *)[cell viewWithTag:labTwoTag];
    labOne.text = [NSString stringWithFormat:@"%@",[[self.tabMDic allKeys] objectAtIndex:indexPath.row]];
    labTwo.text = [NSString stringWithFormat:@"%@",[self.tabMDic objectForKey:labOne.text]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
