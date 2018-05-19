//
//  WCGeoCodeSearch.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/16.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCGeoCodeSearch.h"
#import "WCPositioningMode.h"
#import "UIView+MJAlertView.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface WCGeoCodeSearch()<BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;

@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;

@property (nonatomic, copy) void(^searchResults)(WCPositioningMode *mode);
@end

@implementation WCGeoCodeSearch

- (instancetype)init
{
    if (self = [super init]) {
        
        //初始化检索对象
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        
        _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
       
    }
    return self;
}
/**
 检索地址信息
 
 @param latitude latitude
 @param longitude longitude
 @param results 结果信息
 */
- (void)searchAddressLatitude:(double)latitude longitude:(double)longitude searchResults:(void(^)(WCPositioningMode *mode))results;
{
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
  
    _reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:_reverseGeoCodeSearchOption];
    
    if(flag)
    {
        self.searchResults = results;
    }
    else
    {
        [UIView  addMJNotifierWithText:@"反geo检索发送失败" dismissAutomatically:YES];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (results) {
                results(nil);
            }
        }];
   
    }
}
#pragma mark  ----BMKGeoCodeSearchDelegate----
//实现Deleage处理回调结果
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    
    NSString *address = nil;
    NSString *cityID = nil;
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
//        address = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,[result.sematicDescription componentsSeparatedByString:@","].lastObject];
        address = result.address;
        cityID  = result.addressDetail.adCode;
    }
    else {
        [UIView  addMJNotifierWithText:@"抱歉，未找到结果" dismissAutomatically:YES];
    }
    if (self.searchResults) {

        WCPositioningMode *mode = [[WCPositioningMode alloc] init];
        
        mode.adderss = address;
        mode.cityID = cityID;
        mode.latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        mode.longitude = [NSString stringWithFormat:@"%f",result.location.longitude];

        self.searchResults(mode);
    }
}
- (void)dealloc
{
     _searcher.delegate = nil;      
}
@end
