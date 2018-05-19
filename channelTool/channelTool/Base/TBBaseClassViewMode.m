//
//  TBBaseClassViewMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/11.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseClassViewMode.h"
#import "WCPublic.h"

@interface TBBaseClassViewMode()

@end

@implementation TBBaseClassViewMode

/**
 请求
 
 @param parameter 参数
 */
- (void)postDataParameter:(NSMutableDictionary *)parameter;
{
    __weak typeof(self) weakSelf = self;
    
    [[ZKPostHttp shareInstance] POST:POST_URL params:parameter success:^(id  _Nonnull responseObject) {
        
        MMLog(@"%@",responseObject);
        NSString *errcode = [responseObject valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            if ([weakSelf.delegate respondsToSelector:@selector(originalData:)])
            {
                [weakSelf.delegate originalData:responseObject];
            }
            NSDictionary *data = [responseObject valueForKey:@"data"];
            [weakSelf dataCard:data];
            
        }
        else
        {
            if ([weakSelf.delegate respondsToSelector:@selector(postError:)])
            {
                NSString *errmsg = [responseObject valueForKey:@"errmsg"];
                [weakSelf.delegate postError:[errmsg isEqual:[NSNull null]]?@"数据异常":errmsg];
            }
        }
    } failure:^(NSError * _Nonnull error) {
      
        if ([weakSelf.delegate respondsToSelector:@selector(postError:)])
        {
            [weakSelf.delegate postError:@"网络异常！"];
        }
    }];

}

- (void)dataCard:(NSDictionary *)obj
{
    NSArray *root = [obj valueForKey:@"root"];
  
    if ([self.delegate respondsToSelector:@selector(postDataEnd:)])
    {
        [self.delegate postDataEnd:root];
    }

    if (root.count<20)
    {
        if ([self.delegate respondsToSelector:@selector(noMoreData)])
        {
            [self.delegate noMoreData];
        }

    }

}

@end
