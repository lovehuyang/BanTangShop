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
@end
