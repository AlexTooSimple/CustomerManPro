//
//  DetailInfoVC.h
//  HZAsiaPro
//
//  Created by wuhui on 15/6/12.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum DetailShowType{
    basicInfoType,
    contactInfoType,
    allInfoType,
} DetailShowType;

@interface DetailInfoVC : UIViewController
{
    DetailShowType detailType;
    BOOL isFromApprove;
}
@property(nonatomic ,assign)DetailShowType detailType;
@property(nonatomic ,assign) BOOL isFromApprove;
@property(nonatomic ,assign) BOOL isManage;
@property(nonatomic ,assign) BOOL isHiddenTabBar;

@end
