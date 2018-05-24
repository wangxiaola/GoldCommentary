//
//  WCBillingDateSelectionView.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/24.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCDataTimeTool.h"

/**
 时间选择样式
 
 - DateSelectionStyleMonth: 年月
 - DataPickViewTypeYearMonthDay: 年月日
 */
typedef NS_ENUM(NSInteger, DateSelectionType) {
    
    DateSelectionTypeYearMonth = 0,
    DataPickViewTypeYearMonthDay
};

@protocol BillingDateSelectionDelegate <NSObject>
@optional


//滚动pickView时 回调
- (void)pickViewScroollCallBack_year:(NSString *)year month:(NSString *)month day:(NSString *)day;

/**
 时间确定回调

 @param startTime 开始时间
 @param endTime 结束时间
 @param type 时间样式
 */
- (void)pickViewCallBackStartTime:(NSString *)startTime toEndTime:(NSString *)endTime timeType:(DateSelectionType)type;

@end


@interface WCBillingDateSelectionView : UIView
//[DataTimeTool dateFromString:@"2012-1-1" DateFormat:@"yyyy-MM-dd"];  
@property (nullable, nonatomic, strong) NSDate *minimumDate;//最小显示的日期
@property (nullable, nonatomic, strong) NSDate *maximumDate;//最大显示的日期
@property (nullable, nonatomic, strong) NSDate *defaultSelectDate;//默认选中的日期

@property (nonatomic) DateSelectionType dateStyle;

@property (nonatomic, assign) id<BillingDateSelectionDelegate>delegate;

- (void)showDateView;

@end
