//
//  OperationClientBasicInfoVC.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/21.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationClientBasicInfoVC : UIViewController
{
    NSDictionary *customerInfo;
}
@property (nonatomic ,retain)NSDictionary *customerInfo;
- (void)reloadInitData:(NSArray *)sourceInitData;
@end
