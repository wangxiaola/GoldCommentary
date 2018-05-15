//
//  WCRecordTimeSelectView.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/14.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCRecordTimeSelectView.h"
#import "WCPublic.h"
#import "WSDatePickerView.h"

@implementation WCRecordTimeSelectView
{
    UILabel *_timeLabel;
    UILabel *_stateLabel;
    UIButton *_timeButton;
    
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = BACKLIST_COLOR;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_stateLabel];
        
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setImage:[UIImage imageNamed:@"timeSelect"] forState:UIControlStateNormal];
        [_timeButton addTarget:self action:@selector(timeSelectClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_timeButton];

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    TBWeakSelf
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(18);
        make.bottom.equalTo(weakSelf.mas_centerY).offset(2);
    }];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(2);
        make.left.equalTo(_timeLabel.mas_left);
    }];
    [_timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(weakSelf);
        make.width.equalTo(_timeButton.mas_height);
    }];
}
/**
 更新状态
 
 @param amount 金额
 @param time 时间
 */
- (void)updateAmount:(NSString *)amount time:(NSString *)time;
{
    if (time.length > 0) {
        _timeLabel.text = time;
    }
    if (amount.length > 0) {
        _stateLabel.text = amount;
    }
}
- (void)timeSelectClick
{
    TBWeakSelf
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonth CompleteBlock:^(NSDate *selectDate) {
        
        NSString *date = [selectDate stringWithFormat:@"yyyy-MM"];
 
        if (weakSelf.timeSelectEnd) {
            weakSelf.timeSelectEnd(date);
        }
        
    }];
    datepicker.doneButtonColor = NAVIGATION_COLOR;
    datepicker.dateLabelColor = NAVIGATION_COLOR;
    [datepicker show];
}
@end
