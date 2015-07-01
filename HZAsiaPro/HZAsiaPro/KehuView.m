//
//  KehuView.m
//  HZAsiaPro
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "KehuView.h"
#import "DetailInfoVC.h"

#define labOneTag   111
#define labTwoTag   222

@implementation KehuView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)reloadView {
    if([self.tabMArr count]<10){
        self.scbHome.hidden = YES;
        self.tbvHome.frame = CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT -64 -50);
    } else {
        self.scbHome.hidden = NO;
        self.tbvHome.frame = CGRectMake(0, 40, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT -64 -50 -40);
    }
    [self.tbvHome performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)setUpView{
    self.scbHome = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, 40)];
    self.scbHome.delegate = self;
    [self addSubview:self.scbHome];
    
    self.tabMArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.tbvHome = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT -64 -50 -40) style:UITableViewStylePlain];
    self.tbvHome.delegate = self;
    self.tbvHome.dataSource = self;
    self.tbvHome.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvHome.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tbvHome];
    [self reloadView];
}

#pragma mark tableviewDele & tableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tabMArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_MAINSCREEN_WIDTH *1/5 , 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentCenter;
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
    labOne.text = [[self.tabMArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    labTwo.text = [[self.tabMArr objectAtIndex:indexPath.row] objectForKey:@"source"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.tapBlk){
        DetailInfoVC *detail = [[DetailInfoVC alloc] init];
        detail.detailType = allInfoType;
        detail.isFromApprove = NO;
        self.tapBlk(detail);
    }
}

@end
