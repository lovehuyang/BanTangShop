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
@end
