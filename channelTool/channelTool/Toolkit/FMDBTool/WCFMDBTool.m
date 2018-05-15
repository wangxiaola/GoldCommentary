//
//  WCFMDBTool.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/15.
//  Copyright © 2018年 王小腊. All rights reserved.
//



#import "WCFMDBTool.h"
#import <FMDB/FMDB.h>

static NSString * const dbName = @"wc.sqlite";
static NSString * const siteTabbleName = @"siteTabble";

@interface WCFMDBTool ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation WCFMDBTool

static WCFMDBTool *shareInstance = nil;

#pragma mark - Singleton
+ (WCFMDBTool *)sharedManager
{
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [[self alloc] init];
        }
    }
    return shareInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [super allocWithZone:zone];
        }
    }
    return shareInstance;
}
- (id)copy
{
    return shareInstance;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self creatDB];
    }
    return self;
}
- (void)creatDB
{
    
    NSString *dbPath = [self pathForName:dbName];
    self.fmdb = [FMDatabase databaseWithPath:dbPath];

}
- (void)deleteDB
{
    NSString *dbPath = [self pathForName:dbName];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
}
//获得指定名字的文件的全路径
- (NSString *)pathForName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:name];
    return dbPath;
}

/**
 是否可以操作表

 @return yes 可以
 */
- (BOOL)isOperationFMDB
{
    if ([self isTableOK]) {
        
        return YES;
    }
    return [self createTable];
}
// 判断是否存在表
- (BOOL) isTableOK
{
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        NSLog(@"地址数据库打开成功");
        FMResultSet *rs = [self.fmdb executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", siteTabbleName];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count)
            {
                [self.fmdb close];
                return NO;
            }
            else
            {
                [self.fmdb close];
                return YES;
            }
        }
    }
    [self.fmdb close];
    return NO;
}

//创建表
- (BOOL)createTable{
    
    BOOL result = NO;
    BOOL openSuccess = [self.fmdb open];
    if (!openSuccess) {
        NSLog(@"地址数据库打开失败");
    } else {
        NSLog(@"地址数据库打开成功");
        //'code','sheng','di','xian','name', 'level'
        NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL, sex text NOT NULL);",siteTabbleName];
        result = [self.fmdb executeUpdate:sql];
        if (!result) {
            NSLog(@"创建地址表失败");
            
        } else {
            NSLog(@"创建地址表成功");
        }
    }
    [self.fmdb close];
    return result;
}

@end
