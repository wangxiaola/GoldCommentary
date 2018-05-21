//
//  MDAccount.h
//  slyjg
//
//  Created by 汤亮 on 16/8/22.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserCertification;

@interface UserInfo : NSObject

@property (nonatomic, copy, nullable) NSString *headimg;
@property (nonatomic, copy, nullable) NSString *userID;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *phone;

/**
 认证信息
 */
@property (nonatomic, strong, nullable) UserCertification * certification;


+ (nonnull UserInfo *)account;

+ (void)saveAccount:(nullable UserInfo *)account;
@end

@interface  UserCertification :NSObject

@property (nonatomic, copy, nullable) NSString *address;
@property (nonatomic, copy, nullable) NSString *birth;
@property (nonatomic, copy, nullable) NSString *ID;
@property (nonatomic, copy, nullable) NSString *info;
@property (nonatomic, copy, nullable) NSString *ispass;
@property (nonatomic, copy, nullable) NSString *nickname;
@property (nonatomic, copy, nullable) NSString *role;
@property (nonatomic, copy, nullable) NSString *sex;

@end
