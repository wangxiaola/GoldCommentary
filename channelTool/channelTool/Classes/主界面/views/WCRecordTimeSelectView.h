//
//  WCRecordTimeSelectView.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/14.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCBillingDateSelectionView.h"

@interface WCRecordTimeSelectView : UIView<BillingDateSelectionDelegate>

/**
 更新状态

 @param amount 金额
 @param time 时间
 */
- (void)updateAmount:(NSString *)amount time:(NSString *)time;

/**
 时间回调
 */
@property (nonatomic, copy) void(^timeSelectEnd)(NSString *state, NSString *end);

@end
