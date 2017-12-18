//
//  AppDelegate.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/15.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
+ (AppDelegate *)shareInstance;
@property (strong, nonatomic) UIWindow *window;

//适配屏幕比例
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@end

