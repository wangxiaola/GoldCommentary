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

@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *voicenum;

@property (nonatomic, copy) NSString *buynum;
/*
 {
name = "\U4e5d\U5be8\U6c9f\U666f\U533a";
}
*/
@property (nonatomic, strong) NSArray *label;
// 已经处理的数组
@property (nonatomic, strong) NSArray *forLabels;

@end
