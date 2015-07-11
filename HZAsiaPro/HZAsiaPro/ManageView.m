//
//  ManageView.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/7/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ManageView.h"

#define labCodetag  555
#define labOneTag   111
#define labTwoTag   222
#define labThreeTag 333
#define btnTag      444

@implementation ManageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)reloadView {
    [self compareWithSearchStr:self.scbHome.text];
    if([self.searchMArr count]<10){
        self.scbHome.hidden = YES;
        self.tbvHome.frame = CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT -64);
    } else {
        self.scbHome.hidden = NO;
        self.tbvHome.frame = CGRectMake(0, 40, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT -64 -40);
    }
}

- (void)setUpView{
    self.scbHome = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, 40)];
    self.scbHome.delegate = self;
    [self addSubview:self.scbHome];
    
    self.searchMArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.tabMArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.tbvHome = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT -64 -50 -40) style:UITableViewStylePlain];
    self.tbvHome.delegate = self;
    self.tbvHome.dataSource = self;
    self.tbvHome.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvHome.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tbvHome];
    [self reloadView];
}

- (void)compareWithSearchStr:(NSString *)searchStr {
    if(![searchStr isEqualToString:@""]){
        [self.searchMArr removeAllObjects];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for(int i=0; i<[self.tabMArr count]; i++){
            NSDictionary *dic = [self.tabMArr objectAtIndex:i];
            NSRange range = [[dic objectForKey:@"name"] rangeOfString:searchStr];
            if(range.length>0){
                [arr addObject:dic];
                continue;
            } else {
                range = [[dic objectForKey:@"source"] rangeOfString:searchStr];
                if(range.length>0){
                    [arr addObject:dic];
                    continue;
                }
            }
        }
        [self.searchMArr setArray:arr];
        [arr release];
    } else {
        [self.searchMArr setArray:self.tabMArr];
    }
    [self.tbvHome performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)dealloc{
    [self.tabMArr release];
    [self.searchMArr release];
    [self.tbvHome release];
    [self.scbHome release];
    self.tapBlk = nil;
    [super dealloc];
}

#pragma mark tableviewDele & tableviewDataSource
//哪几行可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.searchMArr removeObjectAtIndex:indexPath.row];
//    [self.tbvHome reloadData];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tbvHome deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchMArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        
        UILabel *codelab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,DEVICE_MAINSCREEN_WIDTH *1/5 , 44)];
        codelab.backgroundColor = [UIColor clearColor];
        codelab.font = [UIFont systemFontOfSize:14];
        codelab.textAlignment = NSTextAlignmentLeft;
        codelab.tag = labCodetag;
        [cell addSubview:codelab];
        [codelab release];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20 + DEVICE_MAINSCREEN_WIDTH *1/5, 0,DEVICE_MAINSCREEN_WIDTH *1/5 , 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.tag = labOneTag;
        [cell addSubview:lab];
        [lab release];
        
        UILabel *labTwo = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH *3/5 - 20, 0,DEVICE_MAINSCREEN_WIDTH *2/5 , 44)];
        labTwo.backgroundColor = [UIColor clearColor];
        labTwo.font = [UIFont systemFontOfSize:14];
        labTwo.textAlignment = NSTextAlignmentRight;
        labTwo.tag = labTwoTag;
        [cell addSubview:labTwo];
        [labTwo release];
        
        UILabel *labThree = [[UILabel alloc] initWithFrame:CGRectMake(20, 44,DEVICE_MAINSCREEN_WIDTH *3/5 , 44)];
        labThree.backgroundColor = [UIColor clearColor];
        labThree.font = [UIFont systemFontOfSize:14];
        labThree.textAlignment = NSTextAlignmentLeft;
        labThree.textColor = [UIColor lightGrayColor];
        labThree.tag = labThreeTag;
        [cell addSubview:labThree];
        [labThree release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DEVICE_MAINSCREEN_WIDTH - 100 , 51, 80 , 30);
        btn.backgroundColor = [UIColor blueColor];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn.layer.cornerRadius = 5;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = btnTag;
        [cell addSubview:btn];
//        [btn release];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 87, DEVICE_MAINSCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:view];
        [view release];
    }
    UILabel *labCode = (UILabel *)[cell viewWithTag:labCodetag];
    UILabel *labOne = (UILabel *)[cell viewWithTag:labOneTag];
    UILabel *labTwo = (UILabel *)[cell viewWithTag:labTwoTag];
    UILabel *labThree = (UILabel *)[cell viewWithTag:labThreeTag];
    UIButton *btn = (UIButton *)[cell viewWithTag:btnTag];
    labCode.text = [NSString stringWithFormat:@"%@",[[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"clientCode"]];
    labOne.text = [NSString stringWithFormat:@"%@",[[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"cname"]];
    labTwo.text = [NSString stringWithFormat:@"%@",[[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"fristPhone"]];
    if([[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"receptionist"] == [NSNull null]||[[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"receptionist"] == nil) {
        labThree.text = @"未安排业务员";
        [btn setTitle:@"分配" forState:UIControlStateNormal];
    } else {
        labThree.text = [NSString stringWithFormat:@"业务员:%@",[[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"receptionist"]];
        [btn setTitle:@"转移" forState:UIControlStateNormal];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.tapBlk){
        self.tapBlk(indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scbHome resignFirstResponder];
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self compareWithSearchStr:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


@end
