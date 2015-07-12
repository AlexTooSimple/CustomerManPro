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
    NSDictionary *customerInfo;
}
@property(nonatomic ,retain)NSDictionary *customerInfo;
@property(nonatomic ,assign)DetailShowType detailType;
@property(nonatomic ,assign)BOOL isFromApprove;
@end
