//
//  UIImage+HLY.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/22.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HLY)
/**
 根据色值生成图片
 
 @param color 十六进制色值
 @return 生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
