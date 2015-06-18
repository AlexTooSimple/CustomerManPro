//
//  ADDPictureView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/15.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ADDPictureView.h"

@implementation ADDPictureView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGPoint pLeft = CGPointMake(0, height/2);
    CGPoint pRight = CGPointMake(width, height/2);
    
    CGPoint pTop = CGPointMake(width/2, 0);
    CGPoint pBottom = CGPointMake(width/2, height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, pLeft.x, pLeft.y);
    CGContextAddLineToPoint(ctx, pRight.x, pRight.y);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, pTop.x, pTop.y);
    CGContextAddLineToPoint(ctx, pBottom.x, pBottom.y);
    CGContextStrokePath(ctx);

}

@end
