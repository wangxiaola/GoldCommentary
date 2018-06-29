//
//  WCChooseDataTool.m
//  channelTool
//
//  Created by 王小腊 on 2018/6/29.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCChooseDataTool.h"
#import "WCPublic.h"

static NSString *scenicLevelKey = @"scenicLevelKey";
static NSString *scenicTagKey = @"scenicTagKey";

@implementation WCChooseDataTool
/**
 获取景区级别
 
 @param array 数据
 */
+ (void)obtainScenicLevelArray:(void(^)(NSArray *levelArray))array;
{
    NSArray *list = [ZKUtil getUserDataForKey:scenicLevelKey];
    
    if (list.count > 0) {
        
        array(list);
        return;
    }
    
    [[ZKPostHttp shareInstance] POST:POST_URL params:@{@"interfaceId":@"319",@"code":@"shop_level"} success:^(id  _Nonnull responseObject) {
        
        NSArray *root = [responseObject valueForKey:@"root"];
        
        if (root.count > 0) {
            
            [ZKUtil cacheUserValue:root key:scenicLevelKey];
            array(root);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];

}

/**
 获取景区标签
 
 @param array 数据
 */
+ (void)obtainScenicTagArray:(void(^)(NSArray *tagArray))array;
{
    NSArray *list = [ZKUtil getUserDataForKey:scenicTagKey];
    
    if (list.count > 0) {
        
        array(list);
        return;
    }
    [[ZKPostHttp shareInstance] POST:POST_URL params:@{@"interfaceId":@"319",@"code":@"shop_label"} success:^(id  _Nonnull responseObject) {
        
        NSArray *root = [responseObject valueForKey:@"root"];
        
        if (root.count > 0) {
            
            [ZKUtil cacheUserValue:root key:scenicTagKey];
            array(root);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
@end
