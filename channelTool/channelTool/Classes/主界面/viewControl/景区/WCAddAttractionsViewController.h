//
//  WCAddAttractionsViewController.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"
@class WCAddScenicMode;

/**
 添加景点信息
 */
@interface WCAddAttractionsViewController : TBBaseViewController

@property (nonatomic, strong) WCAddScenicMode *scenicMode;

/**
 开始刷新列表
 */
@property (nonatomic, copy) void(^refreshTableView)(void);

@end
