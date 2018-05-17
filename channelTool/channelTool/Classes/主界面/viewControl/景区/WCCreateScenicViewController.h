//
//  WCCreateScenicViewController.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/15.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

/**
 创建景区
 */
@interface WCCreateScenicViewController : TBBaseViewController

/**
 开始刷新列表
 */
@property (nonatomic, copy) void(^refreshTableView)(void);
@end
