//
//  WCBusinessDateSelectionView.h
//  channelTool
//
//  Created by 王小腊 on 2018/6/20.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCBusinessDateSelectionView : UIView

@property (nonatomic, copy) void(^businessTime)(NSString * stime,NSString * etime);
- (void)showDateView;
@end
