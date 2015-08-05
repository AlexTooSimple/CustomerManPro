//
//  HomePageSetVC.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/6/25.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "HomePageSetVC.h"
#import "MySwitch.h"

#define labOneTag   333
#define switchTag   444

@interface HomePageSetVC ()

@end

@implementation HomePageSetVC

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
    self.title = @"首页提醒设置";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTable];
}

- (void)setTable{
    self.tbvMArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.tbvHomePageSet = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT - 64 -50) style:UITableViewStylePlain];
    self.tbvHomePageSet.delegate = self;
    self.tbvHomePageSet.dataSource = self;
    self.tbvHomePageSet.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvHomePageSet.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tbvHomePageSet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.tbvMArr release];
    [self.tbvHomePageSet release];
    [super dealloc];
}

#pragma mark tableviewDele & tableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DEVICE_MAINSCREEN_WIDTH *2/5 , 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.tag = labOneTag;
        [cell addSubview:lab];
        [lab release];
        
        MySwitch *swtPlay = [[MySwitch alloc] init];
        swtPlay.tag = switchTag;
        swtPlay.onTintColor = [UIColor colorWithRed:1 green:0.32 blue:0 alpha:1];
        swtPlay.center = CGPointMake(DEVICE_MAINSCREEN_WIDTH - 40, 22);
        [swtPlay addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventTouchUpInside];

        [cell addSubview:swtPlay];
        [swtPlay release];
    }
    UILabel *labOne = (UILabel *)[cell viewWithTag:labOneTag];
    MySwitch *switchTwo = (MySwitch *)[cell viewWithTag:switchTag];
    switchTwo.switchTags = indexPath.row;
    if (indexPath.row == 0) {
        labOne.text = @"个人信息";
        if([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo] boolValue]){
            switchTwo.on = YES;
        } else {
            switchTwo.on = NO;
        }
    } else if(indexPath.row == 1) {
        labOne.text = @"未联系客户";
        if([[[NSUserDefaults standardUserDefaults] objectForKey:Nocontent] boolValue]){
            switchTwo.on = YES;
        } else {
            switchTwo.on = NO;
        }
    } else if(indexPath.row == 2) {
        labOne.text = @"审核通过客户";
        if([[[NSUserDefaults standardUserDefaults] objectForKey:Tongguo] boolValue]){
            switchTwo.on = YES;
        } else {
            switchTwo.on = NO;
        }
    }

//    } else if(indexPath.row == 2) {
//        labOne.text = @"到期客户";
//        if([[[NSUserDefaults standardUserDefaults] objectForKey:TimeUp] boolValue]){
//            switchTwo.on = YES;
//        } else {
//            switchTwo.on = NO;
//        }
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)switchIsChanged:(id)sender
{
    MySwitch *swt = (id)sender;
    switch (swt.switchTags) {
        case 0:{
            [[NSUserDefaults standardUserDefaults] setBool:swt.on forKey:UserInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        case 1:{
            [[NSUserDefaults standardUserDefaults] setBool:swt.on forKey:Nocontent];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        case 2:{
            [[NSUserDefaults standardUserDefaults] setBool:swt.on forKey:Tongguo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        default:
            break;
    }
}

@end
