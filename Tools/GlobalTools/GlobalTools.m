//
//  GlobalTools.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/16.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "GlobalTools.h"

@implementation GlobalTools

#pragma mark - 获取状态栏的高度

+ (CGFloat)getStatusHight{
    
    CGRect StatusRect = [[UIApplication sharedApplication]statusBarFrame];
    return StatusRect.size.height;
}

+ (CGFloat)getStatusAndNavHight{
    
   return  [self getStatusHight] + 44;
}
@end
