//
//  WCMoreAttractionsViewController.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"


/**
 更多景点
 */
@interface WCMoreAttractionsViewController : TBBaseViewController

@property (nonatomic, copy) NSString *sort;//第几列
@property (nonatomic, copy) NSString *shopid;//景区id
@property (nonatomic, copy) NSString *name;// 景区名
@property (nonatomic, copy) NSString *info;//景区介绍
/**
 刷新列表
 */
@property (nonatomic, copy) void(^refreshTableView)(NSArray *modeArray);
@end
