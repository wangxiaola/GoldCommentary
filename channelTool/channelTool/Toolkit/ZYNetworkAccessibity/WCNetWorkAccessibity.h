//
//  WCNetWorkAccessibity.h
//  channelTool
//
//  Created by 王小腊 on 2018/7/27.
//  Copyright © 2018年 王小腊. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WCNetworkReachabilityStatus) {
    WCNetworkReachabilityStatusUnknown          = -1,//未识别的网络
    WCNetworkReachabilityStatusNotReachable     = 0,//不可达的网络(未连接)
    WCNetworkReachabilityStatusReachableViaWWAN = 1,//2G,3G,4G...的网络
    WCNetworkReachabilityStatusReachableViaWiFi = 2,//wifi的网络
};

@interface WCNetWorkAccessibity : NSObject

typedef void (^WCNetworkReachabilityStatusBlock)(WCNetworkReachabilityStatus status);

@property (readwrite, nonatomic, copy) WCNetworkReachabilityStatusBlock networkReachabilityStatusBlock;

/**
 开启网络监听
 */
+ (void)openNetworkMonitoring;

/**
 继续监听
 */
+ (void)startMonitoring;

/**
 暂停监听
 */
+ (void)stopMonitoring;
@end
