//
//  WCAddScenicViewController.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

/**
 添加旅游路线
 */
@interface WCAddScenicViewController : TBBaseViewController

@property (nonatomic, strong) NSString *scenicID;

/**
 开始刷新列表
 */
@property (nonatomic, copy) void(^refreshTableView)(void);

@end
