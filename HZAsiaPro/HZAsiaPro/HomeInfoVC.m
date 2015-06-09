//
//  HomeInfoVC.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/8.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "HomeInfoVC.h"

#define labOneTag   111
#define labTwoTag   222

@interface HomeInfoVC ()

@property(nonatomic,strong)NSMutableArray *tabMArr;
@property(nonatomic,strong)UITableView *tbvHome;

@end

@implementation HomeInfoVC

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor clearColor];
    self.view = rootView;
    [rootView release];
    self.title = @"首页";
}

- (void)setUpdata{
    NSDictionary *dic1 = @{@"name":@"姓名：",@"source":@"张三"};
    NSDictionary *dic2 = @{@"name":@"性别：",@"source":@"男"};
    NSDictionary *dic3 = @{@"name":@"职位：",@"source":@"业务员"};
    NSDictionary *dic4 = @{@"name":@"手机号码：",@"source":@"13678898765"};
    NSDictionary *dic5 = @{@"name":@"工号：",@"source":@"123456"};
    [self.tabMArr addObject:dic1];
    [self.tabMArr addObject:dic2];
    [self.tabMArr addObject:dic3];
    [self.tabMArr addObject:dic4];
    [self.tabMArr addObject:dic5];
    [self.tbvHome performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabMArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.tbvHome = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tbvHome.delegate = self;
    self.tbvHome.dataSource = self;
    self.tbvHome.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tbvHome];
    // Do any additional setup after loading the view.
    [self setUpdata];
}

- (void)dealloc {
    [self.tbvHome release];
    [self.tabMArr release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
    labOne.text = [[self.tabMArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    labTwo.text = [[self.tabMArr objectAtIndex:indexPath.row] objectForKey:@"source"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
