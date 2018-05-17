//
//  WCPositioningViewController.m
//  channelTool
//
//  Created by 王小腊 on 2018/5/16.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "WCPositioningViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "WCGeoCodeSearch.h"
#import "WCPositioningMode.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface WCPositioningViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) WCGeoCodeSearch *godeSearch;

@property (strong, nonatomic) UIImageView *centerImageView;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) WCPositioningMode *mode;


@end

@implementation WCPositioningViewController
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"精准定位";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    [self createMapView];
    [self setLocService];
}
#pragma mark  ----创建地图----
- (void)createMapView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
    
    self.centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myLocation"]];
    [self.mapView insertSubview:self.centerImageView atIndex:1000];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.backgroundColor = NAVIGATION_COLOR;
    self.addressLabel.text = @"正在为您定位";
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    if (@available(iOS 8.2, *)) {
        self.addressLabel.font = [UIFont systemFontOfSize:14 weight:0.2];
    } else if (@available(iOS 9.0, *)){
        self.addressLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:0.2];
    }
    self.addressLabel.textColor = [UIColor whiteColor];
    self.addressLabel.alpha = 0.7;
    [self.mapView insertSubview:self.addressLabel atIndex:1001];
    
    UIButton *senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [senderButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [senderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    senderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    senderButton.backgroundColor = NAVIGATION_COLOR;
    senderButton.alpha = 0.7;
    senderButton.layer.borderColor = [UIColor orangeColor].CGColor;
    senderButton.layer.borderWidth = 2;
    senderButton.layer.cornerRadius = 25;
    [senderButton addTarget:self action:@selector(senderClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView insertSubview:senderButton atIndex:1000];
    
    CGFloat bottomHeight = 30;
    // 设配iPhone X底部
    if (_SCREEN_HEIGHT == 812) {
        bottomHeight = 64;
    }
    UIButton *positioningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [positioningButton setBackgroundImage:[UIImage imageNamed:@"positioning"] forState:(UIControlStateNormal)];
    [positioningButton addTarget:self action:@selector(backToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView insertSubview:positioningButton atIndex:1000];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(goBack)];
    
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
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mapView.mas_top).offset(20);
        make.left.equalTo(weakSelf.mapView.mas_left).offset(20);
        make.right.equalTo(weakSelf.mapView.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerX.equalTo(weakSelf.mapView.mas_centerX);
        make.bottom.equalTo(weakSelf.mapView.mas_bottom).offset(-bottomHeight);
    }];
}

/**
 开启定位
 */
- (void)setLocService
{
    //初始化BMKLocationService
    self.godeSearch = [[WCGeoCodeSearch alloc] init];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

/**
 搜索地理信息
 
 @param coordinate 坐标
 */
- (void)searchAddressCoordinate:(CLLocationCoordinate2D)coordinate
{
    TBWeakSelf
    
    [_godeSearch searchAddressLatitude:coordinate.latitude longitude:coordinate.longitude searchResults:^(WCPositioningMode *mode) {
        weakSelf.addressLabel.text = mode.adderss;
        weakSelf.mode = mode;
    }];
}
#pragma mark  ----BMKMapViewDelegate----
/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;
{
    CLLocationCoordinate2D coordinate = mapView.centerCoordinate;
    [self searchAddressCoordinate:coordinate];
}
#pragma mark  ----BMKLocationServiceDelegate----
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;
{
    if (userLocation.location !=nil) {
        CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
        [self searchAddressCoordinate:coordinate];
        [_locService stopUserLocationService];
        [_mapView setCenterCoordinate:coordinate animated:YES];
        [_mapView setZoomLevel:18];
    }
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error;
{
    self.addressLabel.text = @"位置获取失败，请查看网络连接。";
}
#pragma mark  ----点击事件----
- (void)goBack
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)senderClick
{
    if (self.searchResults&&self.mode) {
        
        self.searchResults(self.mode);
        [self goBack];
    }
    else
    {
        [UIView addMJNotifierWithText:@"没有获取的位置信息" dismissAutomatically:YES];
    }
}
- (void)backToUserLocation
{
    [_locService startUserLocationService];
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

