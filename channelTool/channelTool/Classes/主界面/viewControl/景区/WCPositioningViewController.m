//
//  WCPositioningViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/16.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCPositioningViewController.h"
#import <MapKit/MapKit.h>

@interface WCPositioningViewController ()<MKMapViewDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (strong, nonatomic) UIImageView *centerImageView;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *locatingLabel;

@property (nonatomic) MKCoordinateSpan span;

@end

@implementation WCPositioningViewController
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"精准定位";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createMapView];
}
#pragma mark  ----创建地图----
- (void)createMapView
{
    self.span = MKCoordinateSpanMake(0.021251, 0.016093);
    
    CLLocationManager *locationManager=[[CLLocationManager alloc]init]; self.locationManager=locationManager;
    //请求授权
    [locationManager requestWhenInUseAuthorization];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.backgroundColor = [UIColor whiteColor];
    // 设置地图类型
    self.mapView.mapType = MKMapTypeStandard;

    self.mapView.delegate = self;
    //设置显示用户的位置  先判断是否开始了定位服务
    if ([CLLocationManager locationServicesEnabled] == YES) {
        //显示用户的位置
        _mapView.showsUserLocation = YES;
        //设置用户的基本跟踪状态
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    else
    {
        [UIView addMJNotifierWithText:@"亲，请到设置中打开定位权限。" dismissAutomatically:YES];
    }
    
    [self.view addSubview:self.mapView];
    
    self.centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myLocation"]];
    [self.mapView insertSubview:self.centerImageView atIndex:1000];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.text = @"111";
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = [UIColor blackColor];
    self.addressLabel.numberOfLines = 2;
    [self.mapView insertSubview:self.addressLabel atIndex:1000];
    
    self.locatingLabel = [[UILabel alloc] init];
    self.locatingLabel.text = @"222";
    self.locatingLabel.font = [UIFont systemFontOfSize:14];
    self.locatingLabel.textColor = [UIColor orangeColor];
    [self.mapView insertSubview:self.locatingLabel atIndex:1000];
    
    
    CGFloat bottomHeight = 30;
    // 设配iPhone X底部
    if (_SCREEN_HEIGHT == 812) {
        bottomHeight = 64;
    }
    UIButton *positioningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [positioningButton setBackgroundImage:[UIImage imageNamed:@"positioning"] forState:(UIControlStateNormal)];
    [positioningButton addTarget:self action:@selector(backToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView insertSubview:positioningButton atIndex:1000];
    
    MJWeakSelf
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.mapView);
    }];
    [positioningButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mapView.mas_right).offset(-20);
        make.width.height.equalTo(@40);
        make.bottom.equalTo(weakSelf.mapView.mas_bottom).offset(-bottomHeight);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
