//
//  ShowRepeatClientVC.h
//  HZAsiaPro
//
//  Created by wuhui on 15/7/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowRepeatClientVC : UIViewController
{
    NSArray *repeatClientList;
    NSDictionary *newClientInfo;
}
@property (nonatomic ,retain)NSDictionary *newClientInfo;
@property (nonatomic ,retain)NSArray *repeatClientList;
@end
