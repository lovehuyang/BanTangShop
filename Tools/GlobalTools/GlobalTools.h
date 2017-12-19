//
//  GlobalTools.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/16.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalTools : NSObject
/**
 获取状态栏的高度
 
 @return 高度
 */
+ (CGFloat)getStatusHight;

/**
 获取状态栏和导航栏的高度

 @return 高度
 */
+ (CGFloat)getStatusAndNavHight;

/**
 计算文字的的长度
 
 @param text 文字
 @param font 字体大小
 @param maxSize 最大尺寸
 @return 计算完的尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
@end
