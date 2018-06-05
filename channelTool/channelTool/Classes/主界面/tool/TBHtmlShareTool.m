//
//  TBHtmlShareTool.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBHtmlShareTool.h"
#import "WCAuthenticationPopupsView.h"
#import "UIButton+ImageTitleStyle.h"
#import "WXApi.h"
#import "UIImage+Thumbnail.h"
#import "SDWebImageManager.h"
#import "WCPublic.h"
#import "WCMyScenicMode.h"
#import "WCQRCodeGenerateManager.h"
@implementation TBHtmlShareTool
{
    UIView *contentView;
    UIActivityIndicatorView *activityView;
    CGFloat contentHeight;
    UIImage *_image;
    WCMyScenicMode *_scenicMode;
}

/**
 弹出景区工具
 
 @param mode 模型
 */
- (void)showScenicToolViewData:(WCMyScenicMode *)mode delegate:(id<TBHtmlShareToolDelegate>) delegate;
{
    _delegate = delegate;
    _scenicMode = mode;
    
//    //1.获取网络资源路径(URL)
//    if (mode.logo.length > 0) {
//
//        NSURL *pURL = [NSURL URLWithString:mode.logo];
//
//        [activityView startAnimating];
//
//        [[SDWebImageManager sharedManager] loadImageWithURL:pURL options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//            [activityView stopAnimating];
//            if (finished)
//            {
//                _image = [image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
//            }else
//            {
//                _image = [[UIImage imageNamed:@"popup_ts"] imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
//            }
//
//        }];
//    }
//    else
//    {
//        _image = [[UIImage imageNamed:@"popup_ts"] imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
//    }
    // 如果可以分享 就生产一张二维码
    if ([WXApi isWXAppInstalled]) {
        
        _image = [WCQRCodeGenerateManager generateWithLogoQRCodeData:@"http://www.jianshu.com/users/db6844a150fb/latest_articles" logoImageName:@"wc_share" logoScaleToSuperView:0.3];
    }
    
    self.alpha = 1;
    [[APPDELEGATE window] addSubview:self];
    
    contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    [UIView animateWithDuration:0.2 animations:^{
        
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT-contentHeight,_SCREEN_WIDTH, contentHeight);
    }];
    
}
  
- (instancetype)init;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        contentHeight = 164;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];;
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [hideButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
        
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _SCREEN_HEIGHT+contentHeight, _SCREEN_WIDTH, contentHeight)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        CGFloat shareViewW = _SCREEN_WIDTH-20;
        CGFloat shareViewH = 100;
        CGFloat cancelViewH = 44;
        
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake((_SCREEN_WIDTH-shareViewW)/2, 0, shareViewW, shareViewH)];
        shareView.layer.cornerRadius = 8;
        shareView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:shareView];
        
        
        NSArray *dataArray;
        if ([WXApi isWXAppInstalled]) {
            
            dataArray = @[@{@"name":@"创建景点",@"image":@"scenicTooView_1"},
                          @{@"name":@"编辑景区",@"image":@"scenicTooView_2"},
                          @{@"name":@"删除景区",@"image":@"scenicTooView_3"},
                          @{@"name":@"分享朋友圈",@"image":@"scenicTooView_4"},];
        }
        else
        {
            dataArray = @[@{@"name":@"创建景点",@"image":@"scenicTooView_1"},
                          @{@"name":@"编辑景区",@"image":@"scenicTooView_2"},
                          @{@"name":@"删除景区",@"image":@"scenicTooView_3"}];
        }
        
        CGFloat buttonW = shareViewW/dataArray.count;
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic = dataArray[idx];
            
            UIButton *spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [spaceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            spaceButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [spaceButton setTitle:dic[@"name"] forState:UIControlStateNormal];
            [spaceButton setImage:[UIImage imageNamed:dic[@"image"]] forState:UIControlStateNormal];
            spaceButton.tag = 1000+idx;
            [spaceButton addTarget:self action:@selector(scanicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:spaceButton];
            
            [spaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(shareView.mas_left).offset(buttonW*idx);
                make.top.bottom.equalTo(shareView);
                make.width.mas_equalTo(buttonW);
            }];
            
            [spaceButton setButtonImageTitleStyle:(ButtonImageTitleStyleTop) padding:8];
        }];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake((_SCREEN_WIDTH-shareViewW)/2, contentHeight-cancelViewH-10, shareViewW, cancelViewH);
        [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 8.2, *)) {
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        } if (@available(iOS 9.0, *)) {
            
            cancelButton.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:16 weight:0.2];
        }
        [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.cornerRadius = 8;
        [contentView addSubview:cancelButton];
        
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activityView.color = [UIColor whiteColor];
        [self addSubview:activityView];
        
        [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    
    return self;
}


#pragma mark  点击事件啊
- (void)scanicButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000://创建站点
            
            if ([self.delegate respondsToSelector:@selector(createTheSiteData:)]) {
                [self.delegate createTheSiteData:_scenicMode];
            }
            break;
        case 1001://编辑景区
            
            if ([self.delegate respondsToSelector:@selector(editTheScenicInfoData:)]) {
                [self.delegate editTheScenicInfoData:_scenicMode];
            }
            break;
        case 1002://删除景区
            
            [WCAuthenticationPopupsView showPromptPhone];
            
            break;
        case 1003://分享好友
            [self shareType:0];
            break;
            
        default:
            break;
    }
    [self cancelClick];
}


//分享到朋友圈  分享到空间
- (void)shareType:(NSInteger)type
{
    
    if (!_image) {
        
        [UIView addMJNotifierWithText:@"图片处理中,请稍等！" dismissAutomatically:YES];
        
        return;
    }
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = _scenicMode.name;
//    message.description = _scenicMode.info;
//    [message setThumbImage:_image];
//
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = @"";
//    message.mediaObject = ext;
//
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = type == 0?WXSceneTimeline:WXSceneSession;
//    [WXApi sendReq:req];
    
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = _scenicMode.name;
    mediaMsg.description = _scenicMode.info;
    //2.创建多媒体消息中包含的图片数据对象
    WXImageObject *imgObj = [WXImageObject object];
    //图片真实数据
    imgObj.imageData = UIImagePNGRepresentation(_image);
    //多媒体数据对象
    mediaMsg.mediaObject = imgObj;
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(聊天界面)
    req.scene = WXSceneTimeline;
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];
    
    
}
- (void)cancelClick
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
