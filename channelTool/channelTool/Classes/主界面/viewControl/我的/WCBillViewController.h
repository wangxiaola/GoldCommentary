//
//  WCBillViewController.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/9.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"
@class WCMyIncomeMode;
/**
 账单
 */
@interface WCBillViewController : TBBaseViewController
// 我的收益
@property (nonatomic, strong) WCMyIncomeMode *incomeMode;
@end
