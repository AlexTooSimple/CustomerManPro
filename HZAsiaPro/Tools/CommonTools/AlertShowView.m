//
//  AlertShowView.m
//  IOSCodeTest
//
//  Created by wuhui on 14-11-20.
//  Copyright (c) 2014年 wuhui. All rights reserved.
//

#import "AlertShowView.h"

@implementation AlertShowView

@synthesize alertDelegate;
@synthesize index;
@synthesize contentAlert;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (contentAlert != nil) {
        [contentAlert release];
    }
    [super dealloc];
#endif
}

-(instancetype)initWithAlertViewTitle:(NSString*)title
                              message:(NSString*)message
                             delegate:(id)delegate
                                  tag:(NSInteger)tag
                    cancelButtonTitle:(NSString*)cancelButtonTitle
                    otherButtonTitles:(NSString*)otherButtonTitles,...
{
    self = [super init];
    if (self) {
        NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.index = tag;
        self.alertDelegate = delegate;
        
        id arg;
        va_list argList;
        if(nil != otherButtonTitles){
            va_start(argList, otherButtonTitles);
            while ((arg = va_arg(argList,id))) {
                [argsArray addObject:arg];
            }
            va_end(argList);
        }
        
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSInteger systemVersion = [[currentDevice.systemVersion substringToIndex:1] integerValue];
        if (systemVersion >= 8) {
            //IOS 8
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            if (cancelButtonTitle != nil && ![cancelButtonTitle isEqualToString:@""]) {
                UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                                      style:UIAlertActionStyleCancel
                                                                    handler:^(UIAlertAction *action) {
                                                                        if (self.alertDelegate != nil && [self.alertDelegate respondsToSelector:@selector(alertShowView:didDismissWithButtonIndex:)]) {
                                                                            [self.alertDelegate alertShowView:self didDismissWithButtonIndex:0];
                                                                        }
                                                                    }];
                [alert addAction:alertCancel];
            }
            
            if (otherButtonTitles != nil && ![otherButtonTitles isEqualToString:@""]) {
                UIAlertAction *alertFirst = [UIAlertAction actionWithTitle:otherButtonTitles
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        if (self.alertDelegate != nil && [self.alertDelegate respondsToSelector:@selector(alertShowView:didDismissWithButtonIndex:)]) {
                                                                            [self.alertDelegate alertShowView:self didDismissWithButtonIndex:1];
                                                                        }
                                                                    }];
                [alert addAction:alertFirst];
            }
            
            for(int i=0; i<[argsArray count]; i++){
                UIAlertAction *alertOther = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i]
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action) {
                                                                       if (self.alertDelegate != nil && [self.alertDelegate respondsToSelector:@selector(alertShowView:didDismissWithButtonIndex:)]) {
                                                                           [self.alertDelegate alertShowView:self didDismissWithButtonIndex:i+2];
                                                                       }
                                                                   }];
                [alert addAction:alertOther];
            }
            
            self.contentAlert = alert;
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelButtonTitle
                                                  otherButtonTitles:otherButtonTitles,nil];
            alert.tag = tag;
            for(int i = 0; i < [argsArray count]; i++){
                [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
            }
            [alert show];
#if !__has_feature(objc_arc)
            [alert release];
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
        if (self.contentAlert != nil) {
            if (self.alertDelegate != nil && [self.alertDelegate respondsToSelector:@selector(alertViewWillPresent:)]) {
                [self.alertDelegate alertViewWillPresent:self.contentAlert];
            }
        }
    }
}

#pragma mark
#pragma mark - UIAlterViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == self.index) {
        if (self.alertDelegate != nil && [self.alertDelegate respondsToSelector:@selector(alertShowView:didDismissWithButtonIndex:)]) {
            [self.alertDelegate alertShowView:self didDismissWithButtonIndex:buttonIndex];
        }
    }
}
@end
