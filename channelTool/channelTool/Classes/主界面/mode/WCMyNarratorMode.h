//
//  WCMyNarratorMode.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCMyNarratorMode : NSObject

@property (nonatomic, assign) CGFloat cellHeight;
// 是否全部显示
@property (nonatomic, assign) BOOL isShowAll;
// 第几个区
@property (nonatomic, assign) NSInteger section;
@end
