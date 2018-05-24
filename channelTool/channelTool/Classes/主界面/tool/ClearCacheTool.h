//
//  ClearCacheTool.h
//  VideoDemo
//
//  Created by biyuhuaping on 2017/5/5.
//  Copyright © 2017年 biyuhuaping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClearCacheTool : NSObject

/**
  清除缓存

 @param successful 清除成功
 */
+ (void)clearActionSuccessful:(void(^)(void))successful;

/**
 获取缓存大小

 @param cacheSize 缓存
 */
+ (void)obtainCacheSize:(void(^)(CGFloat cacheSize))cacheSize;

// 根据路径删除文件
+ (void)cleanCaches:(NSString *)path isDeleteVideo:(BOOL)deleteVideo;
@end
