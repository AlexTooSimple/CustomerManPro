//
//  OperationClientContactVC.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/21.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationClientContactVC : UIViewController
{
    NSString *clientCode;
}
@property (nonatomic ,retain)NSString *clientCode;
- (void)reloadInitData:(NSDictionary *)sourceInitData;
@end
