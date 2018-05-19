//
//  ZKPostHttp.h
//  Emergency
//
//  Created by 王小腊 on 2016/11/23.
//  Copyright © 2016年 王小腊. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPDownloadWay) {
    SPDownloadWayResume,    // 这种下载方式支持重启app时继续上一次的下载
    SPDownloadWayRestart    // 这种下载方式不支持重启app时继续上一次的下载
    
    // SPDownloadWayResume和SPDownloadWayRestart的下载方式具体异同点如下：
    /*
     1、SPDownloadWayResume和SPDownloadWayRestart均支持断点下载
     2、SPDownloadWayResume支持重启app继续上一次下载,SPDownloadWayRestart不支持
     3、SPDownloadWayResume会自动判断是否下载完成，并保存每时每刻下载的进度值，SPDownloadWayRestart没有此功能
     4、SPDownloadWayResume支持任何时刻删除已经下载的文件数据，SPDownloadWayRestart不支持在下载过程中删除，只有下载完成时才能删除
     5、SPDownloadWayResume不依赖于AFN，SPDownloadWayRestart依赖AFN
     
     SPDownloadWayResume和SPDownloadWayRestart的根本区别就是前者是沙盒模式，后者是内存模式
     */
    
};
NS_ASSUME_NONNULL_BEGIN
@interface ZKPostHttp : NSObject

/** 单例对象 */
+ (instancetype)shareInstance;

/**
 *  get请求
 *
 *  @param urlString 请求地址
 *  @param params    参数字典
 *  @param success   请求成功回调的block
 *  @param failure   请求失败回调的block
 */
- (void)GET:(NSString *)urlString
        params:(nullable NSDictionary *)params
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;

/**
 *  post请求
 *
 *  @param urlString 请求地址
 *  @param params    参数字典
 *  @param success   请求成功回调的block
 *  @param failure   请求失败回调的block
 */
- (void)POST:(NSString *)urlString
        params:(nonnull NSDictionary *)params
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;

/**
 *  下载
 *
 *  @param urlString 请求地址
 *  @param downloadProgressBlock  下载过程中回调的block
 *  @complete 下载完成回调的block
 */
- (NSURLSessionTask *)downloadWithURL:(NSString *)urlString
                      progress:(void (^)(CGFloat progress))downloadProgressBlock
                      complete:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


/**
 *  上传单张图片
 *
 *  @param url     请求路径
 *  @param imag    请求imageData
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)uploadImage:(NSString *)url Data:(id)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 上传多张图片
 
 @param images 图片二进制数组
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)uploadImageArrayWithImages:(NSArray<NSData *> *)images success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 *  多类型上传文件
 *
 *  @param url        请求路径
 *  @param mediaDatas 数据 （图片：UIImage  视频和音频都穿NSdata）
 *  @param type       0图片  1视频  2音频
 *  @param success    请求成功后的回调
 *  @param failure    请求失败后的回调
 */
+ (void)scPpostImage:(NSString *)url dataArray:(NSData *)mediaDatas type:(NSInteger)type success:(void(^)(id responseObj, NSInteger dataType))success failure:(void(^)(NSError *error, NSInteger dataType))failure;

/*****************************  get、post相关  ***************************/

/** 请求超时时间间隔,默认30s */
@property (nonatomic, assign) double requestTimeoutInterval;

/*****************************  下载相关  ***************************/

// 以下这些操作在外界也可以另外做到，比如启动和暂停任务，外界在调用下载的方法时返回了一个task，开发者可以用该task去启动和暂停任务，之所以将其封装，一是：这个类能做到的尽量不让开发者去做，二是：让开发者完全面向我这个单例对象。开发者只需要做一些关于UI的事情

/** 下载方式 */
@property (nonatomic, assign) SPDownloadWay downloadway;

/*
 *  启动任务
 *
 */
- (void)resumeTask;
/*
 *  暂停任务
 *
 */
- (void)suspendTask;
/*
 *  取消任务
 *
 */
- (void)cancelTask;

/*
 *  移除已经下载好的文件数据
 *
 */
- (BOOL)removeDownloadedData:(NSError * _Nullable __autoreleasing * _Nullable)error;

/** 是否正在下载,对于SPDownloadResume下载方式，该属性来源于沙盒，对于SPDownloadRestart下载方式，该属性来源于内存 */
@property (nonatomic, assign, readonly, getter=isDownloading) BOOL downloading;


// 以下两个属性只对SPDownloadResume下载方式奏效

/** 保存在沙盒中的进度值 */
@property (nonatomic, assign, readonly) CGFloat storedDownloadProgress;
/** 是否已经下载完毕 */
@property (nonatomic, assign, readonly, getter=isDownloadCompleted) BOOL downloadCompleted;

@end
NS_ASSUME_NONNULL_END

@interface NSString (MD5)

@property (nullable, nonatomic, readonly) NSString *md5String;

@end


