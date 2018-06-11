//
//  MJDIYBackFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYBackFooter.h"
#import "WCPublic.h"
#import "Lottie.h"

@interface MJDIYBackFooter()

@property (nonatomic, weak) LOTAnimationView *logo;
@property (nonatomic, weak) UILabel *label;

@end

@implementation MJDIYBackFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    LOTAnimationView *logo = [LOTAnimationView animationNamed:@"sun_burst_weather_icon"];
    logo.frame = CGRectMake(_SCREEN_WIDTH/2-30, 300, 60, 60);
    logo.loopAnimation = YES;
    [self addSubview:logo];
    
    self.logo = logo;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = NAVIGATION_COLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    self.label = label;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    
    self.logo.mj_w = 60;
    self.logo.mj_h = 60;
    self.logo.mj_x = self.mj_w / 2 - self.logo.mj_w ;
    self.logo.mj_y = 0;
    
    self.label.mj_x = self.logo.mj_x + self.logo.mj_w - 10;
    self.label.mj_y = 0;
    self.label.mj_h = self.mj_h;
    self.label.mj_w = self.mj_w - self.logo.mj_x - self.logo.mj_w;

    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    
    switch (state) {
            
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载更多";

            break;
        case MJRefreshStatePulling:
            self.label.text = @"释放更新";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载中...";

            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"全部加载完毕";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    pullingPercent = pullingPercent < 1? :1;
//    //直接播放到指定进度
    [self.logo playToProgress:pullingPercent withCompletion:^(BOOL animationFinished) {

    }];


}

@end
