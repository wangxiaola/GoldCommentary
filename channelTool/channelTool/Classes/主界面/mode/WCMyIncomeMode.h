//
//  WCMyIncomeMode.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/19.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 我的收益
 */
@interface WCMyIncomeMode : NSObject
//未提现余额
@property (nonatomic, copy) NSString *balance;
//总收益
@property (nonatomic, copy) NSString *earnings;
//昨日收益
@property (nonatomic, copy) NSString *last;
//已提现金额
@property (nonatomic, copy) NSString *record;
@end
