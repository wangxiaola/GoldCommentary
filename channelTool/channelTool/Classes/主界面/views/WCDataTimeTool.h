//
//  WCDataTimeTool.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/24.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDataTimeTool : NSObject
//获取年月日对象
+ (NSDateComponents *)getDateComponents:(NSDate *)date;
//获得某年的周数
+ (NSInteger)getWeek_AccordingToYear:(NSInteger)year;
/**
 *  获取某年某周的范围日期
 *
 *  @param year       年份
 *  @param weekofYear year里某个周
 *
 *  @return 时间范围字符串
 */
+ (NSString*)getWeekRangeDate_Year:(NSInteger)year WeakOfYear:(NSInteger)weekofYear;
// 当前时间
+ (NSDateComponents *)getCurrentDateComponents;
//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)dateString DateFormat:(NSString *)DateFormat;
//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date DateFormat:(NSString *)DateFormat;
//时间追加
+ (NSString *)dateByAddingTimeInterval:(NSTimeInterval)TimeInterval DataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat;
//日期字符串格式化
+ (NSString *)getDataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat;
/**
 *  json日期转iOS时间
 *
 *  @param string /Date()
 *
 *  @return str
 */
+ (NSString *)interceptTimeStampFromStr:(NSString *)string DateFormat:(NSString *)DateFormat;

/**
 比较2个时间大小

 @param startDay 开始
 @param endDay 结束
 @return yes
 */
+ (BOOL)compareStartDay:(NSString *)startDay withendDay:(NSString *)endDay;

/**
 获取一个月的第一天和最后一天日期

 @param dateStr 时间年月
 @return @[]
 */
+ (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr;
@end
