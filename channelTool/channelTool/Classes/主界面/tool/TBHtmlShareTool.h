//
//  TBHtmlShareTool.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCMyScenicMode;

@protocol TBHtmlShareToolDelegate <NSObject>
@optional

/**
 创建站点

 @param mode 数据
 */
- (void)createTheSiteData:(WCMyScenicMode *)mode;

/**
 编辑景区信息

 @param mode 数据
 */
- (void)editTheScenicInfoData:(WCMyScenicMode *)mode;


/**
 导航到信息采集vc

 @param mode 数据
 */
- (void)navInformationCollectionVC:(WCMyScenicMode *)mode;

@end


@interface TBHtmlShareTool : UIView

@property (nonatomic, weak) id<TBHtmlShareToolDelegate>delegate;

- (instancetype)initIsRelease:(BOOL)isRelease;

/**
 是否已经发布成功
 */
@property (nonatomic, assign) BOOL isRelease;
/**
 弹出景区工具

 @param mode 模型
 */
- (void)showScenicToolViewData:(WCMyScenicMode *)mode delegate:(id<TBHtmlShareToolDelegate>) delegate;

@end

