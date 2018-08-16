//
//  WCPositioningViewController.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/16.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"
#import "WCPositioningMode.h"

/**
 定位
 */
@interface WCPositioningViewController : TBBaseViewController

/**
 搜索结果
 */
@property (nonatomic, copy) void(^searchResults)(WCPositioningMode *mode);

@end


