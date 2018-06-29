//
//  WCChooseDataTool.h
//  channelTool
//
//  Created by 王小腊 on 2018/6/29.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCChooseDataTool : NSObject

/**
  获取景区级别

 {
 code = "shop_level1";
 name = "\U5176\U4ed6";
 }
 @param array 数据  
 */
+ (void)obtainScenicLevelArray:(void(^)(NSArray *levelArray))array;

/**
  获取景区标签
 {
 code = town;
 id = 9;
 name = "\U53e4\U9547";
 }
 @param array 数据
 */
+ (void)obtainScenicTagArray:(void(^)(NSArray *tagArray))array;
@end

