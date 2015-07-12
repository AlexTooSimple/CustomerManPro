//
//  AccountManageVC.m
//  HZAsiaPro
//
//  Created by 颜梁坚 on 15/6/29.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "AccountManageVC.h"

#define labOneTag   333
#define switchTag   444

@interface AccountManageVC ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *txfPhoneNum;
@property(nonatomic,strong)UISwitch *swtRoot;

@end

@implementation AccountManageVC

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    [rootView release];
    self.title = @"账户设定";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTable];
    
    UIButton *rightButtonForSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButtonForSearch.frame = CGRectMake(0, 8.75, 47, 26.5);
    [rightButtonForSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButtonForSearch setTitle:@"保存" forState:UIControlStateNormal];
    rightButtonForSearch.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightButtonForSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButtonForSearch addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightButtonForSearch] autorelease];
}

- (BOOL)getAdmin{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSDictionary *usrInfo = [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE];
    NSNumber *isadmin = [usrInfo objectForKey:@"isadmin"];
    return [isadmin boolValue];
}

- (void)setTable{
    self.tbvAccount = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_MAINSCREEN_WIDTH, DEVICE_MAINSCREEN_HEIGHT - 64 -50) style:UITableViewStylePlain];
    self.tbvAccount.delegate = self;
    self.tbvAccount.dataSource = self;
    self.tbvAccount.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbvAccount.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tbvAccount];
}

- (void)save {
    [self.txfPhoneNum resignFirstResponder];
    
    NSString *tableName = CUSTOMER_DB_TABLE;
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:CUSTOMER_DATA_BASE_DB];
    NSMutableDictionary *usrInfo = [NSMutableDictionary dictionaryWithDictionary:
                                    [store getObjectById:CUSTOMER_USERINFO
                                       fromTable:CUSTOMER_DB_TABLE]];
    NSNumber *isadmin = [usrInfo objectForKey:@"isadmin"];
    if([isadmin integerValue]==1){
        [usrInfo setObject:@0 forKey:@"isadmin"];
    }else{
        [usrInfo setObject:@1 forKey:@"isadmin"];
    }
    
    [store putObject:usrInfo
              withId:CUSTOMER_USERINFO
           intoTable:tableName];
    [store release];
    
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [aler show];
    [aler release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.tbvAccount release];
    [self.txfPhoneNum release];
    [self.swtRoot release];
    [super dealloc];
}

#pragma mark tableviewDele & tableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DEVICE_MAINSCREEN_WIDTH *2/5 , 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.tag = labOneTag;
        [cell addSubview:lab];
        [lab release];
    }
    UILabel *labOne = (UILabel *)[cell viewWithTag:labOneTag];
    
    if (indexPath.row == 0) {
        if(self.swtRoot){
            if(self.swtRoot.on){
                labOne.text = @"管理员账户";
            } else {
                labOne.text = @"普通账户";
            }
        } else {
            UISwitch *swtPlay = [[UISwitch alloc] init];
            swtPlay.onTintColor = [UIColor colorWithRed:1 green:0.32 blue:0 alpha:1];
            swtPlay.center = CGPointMake(DEVICE_MAINSCREEN_WIDTH - 40, 22);
            [swtPlay addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventTouchUpInside];
            if([self getAdmin]){
                swtPlay.on = YES;
                labOne.text = @"管理员账户";
            } else {
                swtPlay.on = NO;
                labOne.text = @"普通账户";
            }
            self.swtRoot = swtPlay;
            [cell addSubview:self.swtRoot];
            [swtPlay release];
        }
        
    } else if(indexPath.row == 1) {
        labOne.text = @"绑定手机号码";
        
        if(self.txfPhoneNum){
            
        } else {
            UITextField *txf = [[UITextField alloc] initWithFrame:CGRectMake(DEVICE_MAINSCREEN_WIDTH*2/5+10, 0, (DEVICE_MAINSCREEN_WIDTH*3/5)-30, 44)];
            txf.placeholder = @"请输入要绑定的号码";
            txf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            txf.delegate = self;
            txf.textAlignment = NSTextAlignmentRight;
            txf.backgroundColor = [UIColor clearColor];
            txf.font = [UIFont systemFontOfSize:14];
            txf.textColor = [UIColor blackColor];
            [cell addSubview:txf];
            self.txfPhoneNum = txf;
            [txf release];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)switchIsChanged:(id)sender
{
    [self.tbvAccount performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if(textField.text.length != 11){
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"手机号码需为11位，请您检查您的号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [aler show];
        [aler release];
        return NO;
    }
    return YES;
}

@end
