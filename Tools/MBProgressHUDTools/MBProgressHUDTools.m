//
//  MBProgressHUDTools.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/20.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "MBProgressHUDTools.h"

@implementation MBProgressHUDTools
+ (void)showLoadingHudWithtitle:(NSString *)title{
    
//    UIView  *view = winddows? (UIView*)[UIApplication sharedApplication].delegate.window:[self getCurrentUIVC].view;
    [self hideHUD];
    UIView  *view =  (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text=title?title:@"加载中...";
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showTipMessageHudWithtitle:(NSString *)title{
    [self hideHUD];
    UIView  *view =  (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text=title;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:2];
}
+ (void)showSuccessHudWithtitle:(NSString *)title{
    [self hideHUD];
    UIView  *view =  (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBHUD_Success"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.label.text=title;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)showWarningHudWithtitle:(NSString *)title{
    [self hideHUD];
    UIView  *view =  (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBHUD_Warn"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO;
    hud.label.text=title;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)hideHUD{
    UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
    [MBProgressHUD hideHUDForView:winView animated:YES];
}

@end
