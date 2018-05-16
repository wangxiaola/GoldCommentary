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


#pragma mark  ----MKMapViewDelegate----
/**
 *  更新到用户的位置时就会调用(显示的位置、显示范围改变) 这里也是定位功能实现的重要一步
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2509, 0.2256);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    [self.mapView setRegion:region animated:YES];//这里是设置地图显示的区域(经纬度，和跨度(经度跨度和纬度跨度))
}

//  地图显示的区域改变了就会调用(显示的位置、显示范围改变)注意：这里一般在做地图拖动的时候显示周边的团购或者东西的时候会用到这个方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    /获取系统默认定位的经纬度跨度
    NSLog(@"维度跨度:%f,经度跨度:%f",mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
}
// 地图显示的区域即将改变了就会调用

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}
#pragma mark  ----fun tool----
//当用户想返回原来的位置的时候:
-(void)backToUserLocation {
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021251, 0.016093);
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];

}
//  反地理编码：经纬度 -> 地名

- (void)reverseGeocodeLatitude:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude
{
    // 开始反向编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error || placemarks.count == 0) return;
        // 显示最前面的地标信息
        CLPlacemark *firstPlacemark = [placemarks firstObject];
        
        CLLocationDegrees latitude = firstPlacemark.location.coordinate.latitude;
        
        CLLocationDegrees longitude = firstPlacemark.location.coordinate.longitude;
        
        //        self.latitudeField.text = [NSString stringWithFormat:@"%.2f", latitude];
        //
        //        self.longtitudeField.text = [NSString stringWithFormat:@"%.2f", longitude];
        
    }];
}
//缩小地图
- (void)minMapView:(UIButton *)sender {
    //获取维度跨度并放大一倍
    CGFloat latitudeDelta = self.mapView.region.span.latitudeDelta * 2;
    //获取经度跨度并放大一倍
    CGFloat longitudeDelta = self.mapView.region.span.longitudeDelta * 2;
    //经纬度跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    //设置当前区域
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
    
}
//放大地图
- (void)maxMapView:(UIButton *)sender {
    //获取维度跨度并缩小一倍
    CGFloat latitudeDelta = self.mapView.region.span.latitudeDelta * 0.5;
    //获取经度跨度并缩小一倍
    CGFloat longitudeDelta = self.mapView.region.span.longitudeDelta * 0.5;
    //经纬度跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    //设置当前区域
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.centerCoordinate, span); [self.mapView setRegion:region animated:YES];
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
