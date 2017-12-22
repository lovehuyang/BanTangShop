//
//  UIImage+HLY.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/22.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "UIImage+HLY.h"

@implementation UIImage (HLY)
/**
 根据色值生成图片
 
 @param color 十六进制色值
 @return 生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}
@end
