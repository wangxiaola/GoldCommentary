//
//  WCAttributeTouchLabel.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/30.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCAttributeTouchLabel : UIView

/**
 设置显示字样式

 @param str 总的字
 @param clickString 点击的字
 */
- (void)setContenString:(NSString *)str clickString:(NSString *)clickString;

@property (nonatomic, copy) void(^eventBlock)(NSString *string);
@end
