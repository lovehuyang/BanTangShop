//
//  NSData+HLY.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HLY)
/**
 比较两个日期的大小  日期格式为2016-08-14 08：46：20
 
 @param aDate a日期
 @param bDate b日期
 @return 比较结果
 */
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;


/**
 获取正确格式的日期(字符串形式)

 @param timeStr 传入的日期
 @return 得到的正确格式的日期
 */
+ (NSString *)getTimeStr:(NSString *)timeStr;

/**
 获取正确格式的日期(处理服务器返回的时间,带有.号)
 
 @param timeStr 传入的日期
 @return 得到的正确格式的日期
 */
+ (NSString *)getTimeStr2:(NSString *)timeStr;
/**
 获取正确格式的日期(yyyy-MM-dd HH:mm:ss)
 
 @param timeStr 传入的日期
 @return 得到的正确格式的日期
 */
+ (NSDate *)getDateFormatter:(NSString *)timeStr;

/**
 获取正确格式的日期(NSString格式 yyyy-MM-dd HH:mm:ss)
 
 @param time 传入的日期(NSDate格式)
 @return 得到的正确格式的日期
 */
+ (NSString *)getDateString:(NSDate *)time;
@end
