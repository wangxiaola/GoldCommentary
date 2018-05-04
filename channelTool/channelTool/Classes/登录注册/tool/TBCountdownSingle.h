//
//  TBCountdownSingle.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 倒计时
 */
@interface TBCountdownSingle : NSObject

/**
 时间数值
 */
@property (nonatomic, assign) int verifyTimeNumber;
@property (nonatomic, assign) int setPasswordTimeNumber;
@property (nonatomic, assign) BOOL user; //验证类型 yes是注册 no是重置

+ (instancetype)sharedInstance;// 获取单列

/**
 开始计时

 @param number 时间长度
 @param date 更新的时间
 @param end 结束
 */
- (void)startTheDatelength:(int)number timeDate:(void (^)(NSString *numberString))date endTime:(void(^)(void))end;


@end
