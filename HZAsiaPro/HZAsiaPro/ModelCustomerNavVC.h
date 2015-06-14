//
//  ModelCustomerNavVC.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/14.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
@interface ModelCustomerNavVC : UINavigationController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

@end
