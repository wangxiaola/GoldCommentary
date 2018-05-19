//
//  ZKPostHttp.m
//  Emergency
//
//  Created by 王小腊 on 2016/11/23.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ZKPostHttp.h"
#import "WCPublic.h"
#import "AFNetworking.h"

// 文件名,MD5加密
#define SPFileName self.fileURLString.md5String

// 文件的存放路径（caches）
#define SPFileFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:SPFileName]

// 存储文件信息的路径(caches)
#define SPFileInfoPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sp_fileInfo.info"]

// 文件的已下载长度
#define SPDownloadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:SPFileFullPath error:nil][NSFileSize] integerValue]

@interface ZKPostHttp()<NSURLSessionDelegate> {
    CGFloat _storedDownloadProgress;
    BOOL _downloadCompleted;
    BOOL _downloading;
}
@property (nonatomic, strong) AFHTTPSessionManager *manager;

// ------------ 这些属性针对下载2， -------------
/** session */
@property (nonatomic, strong) NSURLSession *session;
/** 写文件的流对象 */
@property (nonatomic, strong) NSOutputStream *stream;
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger totalLength;
/** 下载任务 */
@property (nonatomic, strong) NSURLSessionTask *task;
/** 文件的url */
@property (nonatomic, strong) NSString *fileURLString;
/** 下载过程中回调的block */
@property (nonatomic, copy) void (^downloadProgressBlock)(CGFloat progress);
/** 下载完成回调的block */
@property (nonatomic,copy) void (^completionHandler)(NSURLResponse *response, NSURL *URL, NSError *error);
/** 存储文件信息的字典，该字典要写入沙盒 */
@property (nonatomic, strong) NSMutableDictionary *fileInfoDictionry;

// ------------ 这些属性针对下载1， -------------
/** 下载1的文件url地址 */
@property (nonatomic, copy) NSString *downloadFromZero_UrlString;
/** 下载1完成后保存的文件路径 */
@property (nonatomic, copy) NSString *downloadFromZero_filePath;
/** 下载1过程中回调的block */
@property (nonatomic, copy) void (^downloadFromZero_ProgressBlock)(CGFloat progress);
/** 下载1完成回调的block */
@property (nonatomic,copy) void (^downloadFromZero_completionHandler)(NSURLResponse *response, NSURL *URL, NSError *error);


@end

@implementation ZKPostHttp

+ (instancetype)shareInstance {
    static ZKPostHttp *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestTimeoutInterval = 30.0;
    }
    return self;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
        _manager.requestSerializer.timeoutInterval = self.requestTimeoutInterval;
    }
    return _manager;
}

- (void)setRequestTimeoutInterval:(double)requestTimeoutInterval {
    _requestTimeoutInterval = requestTimeoutInterval;
    self.manager.requestSerializer.timeoutInterval = requestTimeoutInterval;
}


// get请求
- (void)GET:(NSString *)urlString params:(nullable NSDictionary *)params
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure {
    
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    [self.manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        };
    }];
}

// post请求
- (void)POST:(NSString *)urlString params:(nonnull NSDictionary *)params
     success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    dic[@"TimeStamp"] = [ZKUtil timeStamp];
    dic[@"AppId"] = @"2zPhtu3ittzt";
    dic[@"AppKey"] = @"e22eb607c64b4df5a676ffc1274300a3";
    
    MMLog(@"\n请求地址: %@\n请求参数 = \n%@\n",urlString,dic);
    [self.manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

// 下载1(重启app时从0开始)
- (NSURLSessionTask *)downloadFromZeroWithURL:(NSString *)urlString
                                     progress:(void (^)(CGFloat))downloadProgressBlock
                                     complete:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler {
    
    self.downloadFromZero_UrlString = urlString;
    self.downloadFromZero_ProgressBlock = downloadProgressBlock;
    self.downloadFromZero_completionHandler = completionHandler;
    
    return self.task;
}

// 下载2(重启app时从上一次的数据开始)
- (NSURLSessionTask *)downloadWithURL:(NSString *)urlString
                             progress:(void (^)(CGFloat))downloadProgressBlock
                             complete:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler {
    if (self.downloadway == SPDownloadWayResume) {
        self.fileURLString = urlString;
        
        // 将block参数赋值给全局block变量
        self.downloadProgressBlock = downloadProgressBlock;
        self.completionHandler = completionHandler;
        
        return self.task;
    } else {
        return [self downloadFromZeroWithURL:urlString progress:downloadProgressBlock complete:completionHandler];
    }
}


+ (void)uploadImage:(NSString *)url Data:(id)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置接受的类型
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 10;
    
    [sessionManager.requestSerializer setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = @{@"TimeStamp":[ZKUtil timeStamp],
                             @"AppId":@"2zPhtu3ittzt",
                             @"AppKey":@"e22eb607c64b4df5a676ffc1274300a3",
                             @"interfaceId":@"293"};
    
    MMLog(@"\n请求地址: %@\n请求参数 = \n%@\n",url,params);
    
    [sessionManager POST:[NSString stringWithFormat:@"%@",POST_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //添加要上传的文件，此处为图片
        [formData appendPartWithFileData:imag name:@"Filedata" fileName:@".png" mimeType:@"image/jpeg）"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if (success) {
            
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

+ (void)uploadImageArrayWithImages:(NSArray<NSData *> *)images success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置接受的类型
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 10;
    
    [sessionManager.requestSerializer setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    
    NSString *httpStr = POST_IMAGE_URL;
    
    NSDictionary *params = @{@"TimeStamp":[ZKUtil timeStamp],
                             @"AppId":@"2zPhtu3ittzt",
                             @"AppKey":@"e22eb607c64b4df5a676ffc1274300a3",
                             @"interfaceId":@"293"};
    MMLog(@"\n请求地址: %@\n请求参数 = \n%@\n",httpStr,params);
    
    [sessionManager POST:httpStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         [images enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             //upfiles 是参数名 根据项目修改
             [formData appendPartWithFileData:obj name:@"Filedata" fileName:[NSString stringWithFormat:@"%.0f.jpg", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpg"];
         }];
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}


+ (void)scPpostImage:(NSString *)url dataArray:(NSData *)mediaDatas type:(NSInteger)type success:(void(^)(id responseObj, NSInteger dataType))success failure:(void(^)(NSError *error, NSInteger dataType))failure;
{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置接受的类型
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 10;
    
    [sessionManager.requestSerializer setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    
    if (type == 2)
    {
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    }
    
    NSDictionary *params = @{@"TimeStamp":[ZKUtil timeStamp],
                             @"AppId":@"2zPhtu3ittzt",
                             @"AppKey":@"e22eb607c64b4df5a676ffc1274300a3",
                             @"interfaceId":@"293"};
    
    MMLog(@"\n请求地址: %@\n请求参数 = \n%@\n",url,params);
    
    [sessionManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (type == 0)
        {
            //                添加要上传的文件，此处为图片
            [formData appendPartWithFileData:mediaDatas name:@"Filedata" fileName:@".png" mimeType:@"image/jpeg"];
            
        }
        else if(type == 1)
        {        // 视频
            [formData appendPartWithFileData:mediaDatas name:@"Filedata" fileName:@"video.mp4" mimeType:@"video/quicktime"];
            
        }
        else if (type == 2)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]]; //fileName这里取当前时间戳  voice
            NSString *fileName = [NSString stringWithFormat:@"%@.mp3", str];
            [formData appendPartWithFileData:mediaDatas name:@"Filedata" fileName:fileName mimeType:@"wav/mp3/wmr"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if (success) {
            
            success(response,type);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         //取消所有的网络请求
         [sessionManager.operationQueue cancelAllOperations];
         
         if (failure) {
             failure(error,type);
             
         }
     }];
    
}


// 启动任务
- (void)resumeTask {
    [self.task resume];
}

// 暂停任务
- (void)suspendTask {
    [self.task suspend];
}

// 取消任务
- (void)cancelTask {
    [self.task cancel];
}

// 删除
- (BOOL)removeDownloadedData:(NSError * _Nullable __autoreleasing * _Nullable)error {
    if (self.downloadway == SPDownloadWayResume) {
        if (SPDownloadLength) {
            
            BOOL isDirectory = NO;
            
            NSFileManager *manager = [NSFileManager defaultManager];
            // 删除已经下载好的文件
            if ([manager fileExistsAtPath:SPFileFullPath isDirectory:&isDirectory] && [manager fileExistsAtPath:SPFileInfoPath isDirectory:&isDirectory]) {
                // 移除
                BOOL removeFileSuccess = [manager removeItemAtPath:SPFileFullPath error:error];
                BOOL removeFileLengthSuccess = [manager removeItemAtPath:SPFileInfoPath error:error];
                if (removeFileSuccess && removeFileLengthSuccess) { // 移除成功
                    
                    [self.task cancel];
                    self.task = nil;
                    return YES;
                } else {
                    MMLog(@"移除文件失败");
                    return NO;
                }
                
            } else {
                MMLog(@"没找到文件路径");
                return NO;
            }
        } else {
            MMLog(@"没有需要删除的数据");
            return NO;
        }
    }
    else {
        if (!_downloading) { // 说明没有正在下载(下载1)
            BOOL isDirectory = NO;
            
            NSFileManager *manager = [NSFileManager defaultManager];
            // 删除已经下载好的文件
            if ([manager fileExistsAtPath:self.downloadFromZero_filePath isDirectory:&isDirectory]) {
                // 移除
                BOOL removeSuccess = [manager removeItemAtPath:self.downloadFromZero_filePath error:error];
                if (removeSuccess) {
                    [self.task cancel];
                    self.task = nil;
                    return YES;
                } else {
                    MMLog(@"移除失败");
                    return NO;
                }
                return YES;
            } else {
                MMLog(@"没找到文件路径");
                return NO;
            }
        }
        else { // 正在下载
            MMLog(@"****** ‘SPDownloadWayRestart‘不支持在下载过程中删除");
            return NO;
        }
    }
    
}

// 从沙盒中获取下载的进度值
- (CGFloat)storedDownloadProgress {
    _storedDownloadProgress = [self.fileInfoDictionry[@"downloadProgress"] floatValue];
    return _storedDownloadProgress;
}

// 从沙盒中获取下载是否完毕的标识
- (BOOL)isDownloadCompleted {
    _downloadCompleted = self.fileInfoDictionry[@"downloadCompleted"];
    return _downloadCompleted;
}

// 从沙盒中获取是否正在下载的标识
- (BOOL)isDownloading {
    _downloading = self.fileInfoDictionry[@"downloading"];
    return _downloading;
}

- (NSOutputStream *)stream {
    if (!_stream) {
        _stream = [NSOutputStream outputStreamToFileAtPath:SPFileFullPath append:YES];
    }
    return _stream;
}

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

- (NSURLSessionTask *)task {
    if (!_task) {
        
        if (self.downloadway == SPDownloadWayResume) {
            // 取出文件的总长度
            NSInteger totalLength = [self.fileInfoDictionry[SPFileName] integerValue];
            if (totalLength && SPDownloadLength == totalLength) {
                MMLog(@"文件已经下载完成了");
                return nil;
            }
            // 创建请求
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.fileURLString]];
            
            // 设置请求头
            // Range : bytes=xxx-xxx
            NSString *range = [NSString stringWithFormat:@"bytes=%zd-", SPDownloadLength];
            [request setValue:range forHTTPHeaderField:@"Range"];
            
            // 创建一个Data任务
            _task = [self.session dataTaskWithRequest:request];
        }
        else {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            NSURL *urlpath = [NSURL URLWithString:self.downloadFromZero_UrlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
            
            _task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                
                _downloading = YES;
                
                CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                
                if (self.downloadFromZero_ProgressBlock) {
                    self.downloadFromZero_ProgressBlock(progress);
                }
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                
                NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
                
                NSURL *fileURL = [NSURL fileURLWithPath:cachesPath];
                
                return fileURL;
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                
                _downloading = NO;
                self.downloadFromZero_filePath = filePath.path;
                
                if (self.downloadFromZero_completionHandler) {
                    self.downloadFromZero_completionHandler(response,filePath,error);
                }
            }];
        }
    }
    return _task;
    
}

- (NSMutableDictionary *)fileInfoDictionry {
    if (_fileInfoDictionry == nil) {
        //  通过文件文件路径初始化字典，第一次取出来的必为空，因为此时还没有写进沙盒
        _fileInfoDictionry = [NSMutableDictionary dictionaryWithContentsOfFile:SPFileInfoPath];
        if (_fileInfoDictionry == nil) {
            _fileInfoDictionry = [NSMutableDictionary dictionary];
        }
    }
    return _fileInfoDictionry;
}


#pragma mark - <NSURLSessionDataDelegate>
/**
 * 1.接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    // 打开流
    [self.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    self.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + SPDownloadLength;
    
    // 存储总长度
    self.fileInfoDictionry[SPFileName] = @(self.totalLength);
    [self.fileInfoDictionry writeToFile:SPFileInfoPath atomically:YES];
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 2.接收到服务器返回的数据（这个方法可能会被调用N次）
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    // 写入数据，不需要指定写入到哪个路径，因为stream在创建的那一刻就纪录好存储路径
    [self.stream write:data.bytes maxLength:data.length];
    
    // 回调block
    if (self.downloadProgressBlock) {
        
        // 获取进度值
        CGFloat progress = 1.0 * SPDownloadLength / self.totalLength;
        //NSLog(@"++++++%f",progress);
        self.downloadProgressBlock(progress);
        
        self.fileInfoDictionry[@"downloadProgress"] = @(progress);  // 进度值
        self.fileInfoDictionry[@"downloading"] = @(YES); // 正在下载的标识
        [self.fileInfoDictionry writeToFile:SPFileInfoPath atomically:YES];
        
    }
}

/**
 * 3.请求完毕（成功\失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (self.completionHandler) {
        self.completionHandler(task.response,[NSURL fileURLWithPath:SPFileFullPath],error);
        // 关闭流
        [self.stream close];
        self.stream = nil;
        
        // 清除任务
        self.task = nil;
        
        if (!error) {
            
            self.fileInfoDictionry[@"downloadCompleted"] = @(YES);  // 下载完成的标识
            self.fileInfoDictionry[@"downloading"] = @(NO); // 正在下载的标识
            [self.fileInfoDictionry writeToFile:SPFileInfoPath atomically:YES];
        } else {
            if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) {
                return;
            }
        }
    }
    
}


@end

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)md5String {
    
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(NSInteger)length {
    
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

@end

