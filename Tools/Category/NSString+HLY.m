//
//  NSString+HLY.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/26.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "NSString+HLY.h"

@implementation NSString (HLY)
+ (NSString *)emptyOrNilStr:(NSString *)str{
    
    
    if ([[str class] isKindOfClass:[NSNull class]]) {
        return @"未知";
    }
    str = [NSString stringWithFormat:@"%@",str];
    if (str.length == 0 || str == nil ) {
        return @"未知";
    }else{
        return str;
    }
}
@end
