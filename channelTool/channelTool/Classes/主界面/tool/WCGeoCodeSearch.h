//
//  WCGeoCodeSearch.h
//  channelTool
//
//  Created by 王小腊 on 2018/5/16.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  WCPositioningMode;

@interface WCGeoCodeSearch : NSObject

/**
 检索地址信息

 @param latitude latitude
 @param longitude longitude
 @param results 结果信息
 */
- (void)searchAddressLatitude:(double)latitude longitude:(double)longitude searchResults:(void(^)(WCPositioningMode *mode))results;


@end
