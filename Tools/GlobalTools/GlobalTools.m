//
//  GlobalTools.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/16.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "GlobalTools.h"

@implementation GlobalTools

/**
 保存信息到沙盒
 
 @param value 值
 @param key key
 */
+ (void)saveData:(NSString *)value key:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
/**
 根据key获取沙盒的值
 
 @param key key
 @return value
 */
+ (NSString *)getData:(NSString *)key{
   return  [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

/**
 清空信息
 
 @param key key
 */
+ (void)removeData:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}

/**
 获取用户的登录状态

 @return yes：已经登录
 */
+ (BOOL)userIsLogin{
    NSString *userID = [self getData:USER_ID];
    if (!userID || userID.length == 0) {
        return NO; // 未登录
    }else{
        return YES;
    }
}

#pragma mark - 获取状态栏的高度

+ (CGFloat)getStatusHight{
    
    CGRect StatusRect = [[UIApplication sharedApplication]statusBarFrame];
    return StatusRect.size.height;
}

+ (CGFloat)getStatusAndNavHight{
    
   return  [self getStatusHight] + 44;
}


/**
 计算文字的的长度

 @param text 文字
 @param font 字体大小
 @param maxSize 最大尺寸
 @return 计算完的尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    
    if ([text isKindOfClass:[NSNull class]] ||text == nil) {
        return CGSizeMake(0, 0);
        
    }else{
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
}



/**
 获取当前屏幕显示的viewcontroller

 @return 当前屏幕的控制器
 */
+(UIViewController *)getCurrentWindowVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;
    }
    return  result;
}
/**
 获取当前屏幕显示的viewcontroller
 
 @return 当前屏幕的控制器
 */
+(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [[self class]  getCurrentWindowVC ];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}
@end
