//
//  MBProgressHUDTools.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/20.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MBProgressHUDTools : NSObject

/**
 显示加载框

 @param title 标题
 */
+ (void)showLoadingHudWithtitle:(NSString *)title;

/**
 显示提示信息（3秒消失）

 @param title 标题
 */
+ (void)showTipMessageHudWithtitle:(NSString *)title;

/**
 显示成功的提示
 
 @param title 标题
 */
+ (void)showSuccessHudWithtitle:(NSString *)title;
/**
 显示警示的提示
 
 @param title 标题
 */
+ (void)showWarningHudWithtitle:(NSString *)title;


/**
 隐藏提示框
 */
+ (void)hideHUD;
@end
