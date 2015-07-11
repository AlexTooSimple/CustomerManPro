//
//  SalesmanSelectVC.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/10.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "SalesmanSelectVC.h"

#define labOneTag   111
#define labTwoTag   222

@interface SalesmanSelectVC ()

@end

@implementation SalesmanSelectVC

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
    self.title = @"业务员选择";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutTab];
    [self setNavBarOperatorItem];
    // Do any additional setup after loading the view.
}

- (void)layoutTab {
    self.tabMArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectMArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.tbvSaleMan = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tbvSaleMan.delegate = self;
    self.tbvSaleMan.dataSource = self;
    self.tbvSaleMan.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvSaleMan.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tbvSaleMan];
    [self getAllSaleMan];
}

- (void)requestFailed:(NSDictionary *)info
{
    NSString *bussineCode = [info objectForKey:@"bussineCode"];
    NSString *msg = [info objectForKey:@"MSG"];
    if([[SearchCustomerWithConditionMessage getBizCode] isEqualToString:bussineCode]){
        AlertShowView *alert = [[AlertShowView alloc] initWithAlertViewTitle:@"提示"
                                                                     message:msg
                                                                    delegate:self
                                                                         tag:0
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)getAllSaleMan {
    NSDictionary *dic11 = @{@"name":@"张三",@"source":@"13656687678"};
    NSDictionary *dic21 = @{@"name":@"李四",@"source":@"13656687679"};
    NSDictionary *dic31 = @{@"name":@"王五",@"source":@"13656687677"};
    NSDictionary *dic41 = @{@"name":@"赵六",@"source":@"13678898765"};
    NSDictionary *dic51 = @{@"name":@"李七",@"source":@"13656687676"};
    
    [self.tabMArr addObject:dic11];
    [self.tabMArr addObject:dic21];
    [self.tabMArr addObject:dic31];
    [self.tabMArr addObject:dic41];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    [self.tabMArr addObject:dic51];
    for (NSDictionary *dic in self.tabMArr){
        [self.selectMArr addObject:@{@"select":@0}];
    }
    [self.tbvSaleMan performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save:(id)sender {
    if(self.tapBlk){
        self.tapBlk(sender);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - 设置NavLeft按钮
- (void)setNavBarOperatorItem
{
    UIBarButtonItem *operateItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = operateItem;
    [operateItem release];
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
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_MAINSCREEN_WIDTH *1/4 , 44)];
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
    
    if([[[self.selectMArr objectAtIndex:indexPath.row] objectForKey:@"select"] boolValue]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    labOne.text = [[self.tabMArr objectAtIndex:indexPath.row] objectForKey:@"name"];
    labTwo.text = [[self.tabMArr objectAtIndex:indexPath.row] objectForKey:@"source"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selectMArr removeAllObjects];
    for (NSDictionary *dic in self.tabMArr){
        [self.selectMArr addObject:@{@"select":@0}];
    }
    [self.selectMArr replaceObjectAtIndex:indexPath.row withObject:@{@"select":@1}];
    [self.tbvSaleMan performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end
