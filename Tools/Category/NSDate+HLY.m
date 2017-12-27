//
//  NSData+HLY.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "NSDate+HLY.h"

@implementation NSDate (HLY)

/**
 比较两个日期的大小  日期格式为2016-08-14 08：46：20

 @param aDate a日期
 @param bDate b日期
 @return 比较结果
 */
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等  aa=0
        aa = 0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

/**
 获取正确格式的日期(处理服务器返回的时间,带有+号)
 
 @param timeStr 传入的日期
 @return 得到的正确格式的日期
 */
+ (NSString *)getTimeStr:(NSString *)timeStr{
    timeStr =[timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    timeStr = [[timeStr componentsSeparatedByString:@"+"] firstObject];
//    DLog(@"活动截止日期：%@",_food.actEndDate);
    return timeStr;
}
/**
 获取正确格式的日期(处理服务器返回的时间,带有.号)
 
 @param timeStr 传入的日期
 @return 得到的正确格式的日期
 */
+ (NSString *)getTimeStr2:(NSString *)timeStr{
    timeStr =[timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    timeStr = [[timeStr componentsSeparatedByString:@"."] firstObject];
    //    DLog(@"活动截止日期：%@",_food.actEndDate);
    return timeStr;
}

/**
 获取正确格式的日期(NSDate格式 yyyy-MM-dd HH:mm:ss)
 
 @param timeStr 传入的日期
 @return 得到的正确格式的日期
 */
+ (NSDate *)getDateFormatter:(NSString *)timeStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}
/**
 获取正确格式的日期(NSString格式 yyyy-MM-dd HH:mm:ss)
 
 @param time 传入的日期(NSDate格式)
 @return 得到的正确格式的日期
 */
+ (NSString *)getDateString:(NSDate *)time{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:time];
    return dateString;
}
@end
