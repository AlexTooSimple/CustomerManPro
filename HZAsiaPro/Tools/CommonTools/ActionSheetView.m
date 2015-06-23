//
//  ActionSheetView.m
//  HZAsiaPro
//
//  Created by wuhui on 15/6/23.
//  Copyright (c) 2015年 wuhui. All rights reserved.
//

#import "ActionSheetView.h"

@implementation ActionSheetView
@synthesize actionDelegate;
@synthesize tag;
@synthesize contentSheet;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (contentSheet != nil) {
        [contentSheet release];
    }
    [super dealloc];
#endif
}

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<ActionSheetViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelTitle
       destructiveButtonTitle:(NSString *)destructiveTitle
            otherButtonTitles:(NSString *)otherTitle, ...
{
    self = [super init];
    if (self) {
        
        self.actionDelegate = delegate;
        
        NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
        id arg;
        va_list argList;
        if(nil != otherTitle){
            va_start(argList, otherTitle);
            while ((arg = va_arg(argList,id))) {
                [argsArray addObject:arg];
            }
            va_end(argList);
        }
        
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSInteger systemVersion = [[currentDevice.systemVersion substringToIndex:1] integerValue];
        if (systemVersion >= 8) {
            // IOS 8 使用UIAlertController
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            NSInteger index = 0;
            if (destructiveTitle != nil && ![destructiveTitle isEqualToString:@""]) {
                UIAlertAction *alertDestrive = [UIAlertAction actionWithTitle:destructiveTitle
                                                                      style:UIAlertActionStyleDestructive
                                                                    handler:^(UIAlertAction *action) {
                                                                        if (self.actionDelegate != nil && [self.actionDelegate respondsToSelector:@selector(actionSheetView:didDismissWithButtonIndex:)]) {
                                                                            [self.actionDelegate actionSheetView:self
                                                                                       didDismissWithButtonIndex:index];
                                                                        }
                                                                    }];
                [alert addAction:alertDestrive];
                index ++ ;
            }
            
            
            if (otherTitle != nil && ![otherTitle isEqualToString:@""]) {
                UIAlertAction *alertFirst = [UIAlertAction actionWithTitle:otherTitle
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       if (self.actionDelegate != nil && [self.actionDelegate respondsToSelector:@selector(actionSheetView:didDismissWithButtonIndex:)]) {
                                                                           [self.actionDelegate actionSheetView:self
                                                                                      didDismissWithButtonIndex:index];
                                                                       }
                                                                   }];
                [alert addAction:alertFirst];
                index ++ ;
            }
            
           
            
            for(int i=0; i<[argsArray count]; i++){
                UIAlertAction *alertOther = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i]
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       if (self.actionDelegate != nil && [self.actionDelegate respondsToSelector:@selector(actionSheetView:didDismissWithButtonIndex:)]) {
                                                                           [self.actionDelegate actionSheetView:self
                                                                                      didDismissWithButtonIndex:index];
                                                                       }
                                                                   }];
                [alert addAction:alertOther];
                index++;
            }
            
            if (cancelTitle != nil && ![cancelTitle isEqualToString:@""]) {
                UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:cancelTitle
                                                                      style:UIAlertActionStyleCancel
                                                                    handler:^(UIAlertAction *action) {
                                                                        if (self.actionDelegate != nil && [self.actionDelegate respondsToSelector:@selector(actionSheetView:didDismissWithButtonIndex:)]) {
                                                                            [self.actionDelegate actionSheetView:self
                                                                                       didDismissWithButtonIndex:index];
                                                                        }
                                                                    }];
                [alert addAction:alertCancel];
            }
            self.contentSheet = alert;
            
        }else{
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:destructiveTitle
                                                      otherButtonTitles:otherTitle, nil];
            for(int i = 0; i < [argsArray count]; i++){
                [sheet addButtonWithTitle:[argsArray objectAtIndex:i]];
            }
            [sheet addButtonWithTitle:cancelTitle];
            [sheet showInView:[UIApplication sharedApplication].keyWindow];
#if !__has_feature(objc_arc)
            [sheet release];
#endif
        }
        
#if !__has_feature(objc_arc)
        [argsArray release];
#endif
        
    }
    return self;
}

- (void)show
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSInteger systemVersion = [[currentDevice.systemVersion substringToIndex:1] integerValue];
    if (systemVersion >= 8) {
        if (self.contentSheet != nil) {
            if (self.actionDelegate != nil && [self.actionDelegate respondsToSelector:@selector(actionSheetViewWillPresent:)]) {
                [self.actionDelegate actionSheetViewWillPresent:self.contentSheet];
            }
        }
    }
}

#pragma mark
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.actionDelegate != nil && [self.actionDelegate respondsToSelector:@selector(actionSheetView:didDismissWithButtonIndex:)]) {
        [self.actionDelegate actionSheetView:self
                   didDismissWithButtonIndex:buttonIndex];
    }
}

@end
