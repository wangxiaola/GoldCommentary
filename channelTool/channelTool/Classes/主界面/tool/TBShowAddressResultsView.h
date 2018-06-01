//
//  TBShowAddressResultsView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BMKPoiInfo;

@interface TBShowAddressResultsView : UIView

- (void)showAdderssPois:(NSArray <BMKPoiInfo*>*)array;

@property (nonatomic, copy) void(^adderssPoi)(BMKPoiInfo *);

@end
