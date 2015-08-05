//
//  KehuView.m
//  HZAsiaPro
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "KehuView.h"
#import "DetailInfoVC.h"
#import "ActionSheetView.h"

//#define labOneTag   111
//#define labTwoTag   222
#define CELL_NAME_LABEL_TAG         121
#define CELL_PHONE_LABEL_TAG        122

#define CELL_ROW_HEIGHT             44.0f

@implementation KehuView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        selectRow = -1;
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
//    [self.tbvHome performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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
            NSRange range = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]] rangeOfString:searchStr];
            if(range.length>0){
                [arr addObject:dic];
                continue;
            } else {
                range = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"cname"]] rangeOfString:searchStr];
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
    self.messageBlk = nil;
    [super dealloc];
}

#pragma mark tableviewDele & tableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchMArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellStr] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        iconView.backgroundColor = [UIColor clearColor];
        iconView.image = [UIImage imageNamed:@"icon_login_account.png"];
        [cell.contentView addSubview:iconView];
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.tag = CELL_NAME_LABEL_TAG;
        [cell.contentView addSubview:nameLabel];
        
        
        UILabel *phoneLabel = [[UILabel alloc] init];
        phoneLabel.backgroundColor = [UIColor clearColor];
        phoneLabel.textColor = [UIColor blackColor];
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        phoneLabel.font = [UIFont systemFontOfSize:15.0f];
        phoneLabel.tag = CELL_PHONE_LABEL_TAG;
        [cell.contentView addSubview:phoneLabel];
        
        
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.backgroundColor = [UIColor clearColor];
        arrowView.image = [UIImage imageNamed:@"tools_call.png"];
        [cell.contentView addSubview:arrowView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).with.offset(10.0f);
            make.top.equalTo(cell.contentView).with.offset((CELL_ROW_HEIGHT-29)/2.0f);
            make.size.mas_equalTo(CGSizeMake(29, 29));
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(3.0f, 50.0f, 3.0f, cell.contentView.frame.size.width/2.0f-10.0f));
        }];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(3.0f);
            make.bottom.equalTo(cell.contentView).with.offset(-3.0f);
            make.left.equalTo(nameLabel.mas_right).with.offset(10.0f);
            make.right.equalTo(cell.contentView).with.offset(-40.0f);
        }];
        
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(phoneLabel.mas_right).with.offset(3.0f);
            make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
        }];
        
        [iconView release];
        [nameLabel release];
        [phoneLabel release];
        [arrowView release];
        
        
        UIView *seperView = [[UIView alloc] initWithFrame:CGRectZero];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(CELL_ROW_HEIGHT-1, 0, 0, 0));
        }];
        [seperView release];
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
//        
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DEVICE_MAINSCREEN_WIDTH *1/5 , 44)];
//        lab.backgroundColor = [UIColor clearColor];
//        lab.font = [UIFont systemFontOfSize:14];
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.tag = labOneTag;
//        [cell addSubview:lab];
//        [lab release];
//        
//        UILabel *labTwo = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH *2/5, 0,DEVICE_MAINSCREEN_WIDTH *3/5 , 44)];
//        labTwo.backgroundColor = [UIColor clearColor];
//        labTwo.font = [UIFont systemFontOfSize:14];
//        labTwo.textAlignment = NSTextAlignmentLeft;
//        labTwo.tag = labTwoTag;
//        [cell addSubview:labTwo];
//        [labTwo release];
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, DEVICE_MAINSCREEN_WIDTH, 1)];
//        view.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
//        [cell addSubview:view];
//        [view release];
    }
    UILabel *labOne = (UILabel *)[cell viewWithTag:CELL_NAME_LABEL_TAG];
    UILabel *labTwo = (UILabel *)[cell viewWithTag:CELL_PHONE_LABEL_TAG];
    labOne.text = [NSString stringWithFormat:@"%@",[[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"cname"]];
    labTwo.text = [NSString stringWithFormat:@"%@",[[self.searchMArr objectAtIndex:indexPath.row] objectForKey:@"mobile"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectRow = indexPath.row;
    ActionSheetView *sheet = [[ActionSheetView alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"拨打电话"
                                                  otherButtonTitles:@"发送短信",nil];
    [sheet show];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%d",indexPath.row);
    if(self.tapBlk){
        self.tapBlk(indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scbHome resignFirstResponder];
}

#pragma mark
#pragma mark - ActionSheetViewDelegate
- (void)actionSheetView:(ActionSheetView *)sheetView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //拨打电话
            UIWebView *callWebView = [[UIWebView alloc] init];
            NSString *phone = [[self.searchMArr objectAtIndex:selectRow] objectForKey:@"mobile"];
            NSString *telStr = [[NSString alloc] initWithFormat:@"tel:%@",phone];
            NSURL *telURL = [NSURL URLWithString:telStr];
            [telStr release];
            
            [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
            
        }
            break;
        case 1:
        {
            //发送短信
            NSString *phone = [[self.searchMArr objectAtIndex:selectRow] objectForKey:@"mobile"];
            NSArray *phones = [[NSArray alloc] initWithObjects:phone, nil];
            
            if(self.messageBlk){
                self.messageBlk(phones);
            }
            [phones release];
        }
            break;
        default:
            break;
    }
}

- (void)actionSheetViewWillPresent:(UIAlertController *)alertController
{
    UIViewController  *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentVC presentViewController:alertController
                            animated:YES
                          completion:nil];
}


#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self compareWithSearchStr:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

@end
