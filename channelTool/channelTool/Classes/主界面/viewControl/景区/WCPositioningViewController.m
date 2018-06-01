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
#import "TBShowAddressResultsView.h"
#import "UIButton+ImageTitleStyle.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
@interface WCPositioningViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,UISearchBarDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
// 定位服务
@property (nonatomic, strong) BMKLocationService *locService;
// 经纬度转地址
@property (nonatomic, strong) WCGeoCodeSearch *godeSearch;
// poi搜索
@property (nonatomic, strong) BMKPoiSearch *searcher;
// 地址搜索
@property (nonatomic, strong) BMKCitySearchOption *citySearchOption;
// 地理位置模型
@property (nonatomic, strong) WCPositioningMode *mode;
// 地址搜索结果弹出列表
@property (nonatomic, strong) TBShowAddressResultsView *resultsView;

@property (strong, nonatomic) UIImageView *centerImageView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) BOOL isSearch;// 是否正在搜索
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
    
    [self createMapView];
    [self setLocService];
    [self createGeoCodeSearch];
}
#pragma mark  ----创建地图----
- (void)createMapView
{
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
    // 搜索
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, _SCREEN_WIDTH-40, 40)];
    searchBarView.backgroundColor = [UIColor whiteColor];
    searchBarView.layer.cornerRadius = 20;
    searchBarView.layer.masksToBounds = YES;
    [self.mapView insertSubview:searchBarView atIndex:1000];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:searchBarView.bounds];
    self.searchBar.placeholder = @"输入地点查询";
    self.searchBar.tintColor = NAVIGATION_COLOR; //设置光标颜色为橘色
    [self.searchBar setBackgroundImage:[self GetImageWithColor:[UIColor whiteColor] andHeight:44]];
    self.searchBar.layer.cornerRadius = 25;
    self.searchBar.delegate = self;
    [searchBarView addSubview:self.searchBar];
    // 搜索结果列表
    self.resultsView = [[TBShowAddressResultsView alloc] init];
    [self.mapView insertSubview:self.resultsView atIndex:1010];
    
    TBWeakSelf
    [self.resultsView setAdderssPoi:^(BMKPoiInfo *poi) {
        // 发起poi详情搜索
        [weakSelf.activityView startAnimating];
        weakSelf.searchBar.text = poi.name;
        //在此处理正常结果
        [weakSelf searchAddressCoordinate:poi.pt];
        weakSelf.isSearch = YES;
        [weakSelf.mapView setCenterCoordinate:poi.pt animated:YES];
    }];
    
    self.centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myLocation"]];
    [self.mapView insertSubview:self.centerImageView atIndex:1000];
    
    //加载原有图片
    UIImage *norImage = [UIImage imageNamed:@"addressPopUp"];
    // 生成可以拉伸指定位置的图片
    CGFloat top = 10;     // 顶端预留部分
    CGFloat bottom = norImage.size.height-10; // 底端预留部分
    CGFloat left = 50;     // 左端预留部分
    CGFloat right = 50;    // 右端预留部分
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    norImage =  [norImage resizableImageWithCapInsets:insets resizingMode:(UIImageResizingModeStretch)];
    
    UIImageView *addressImageView = [[UIImageView alloc] init];
    addressImageView.image = norImage;
    [self.mapView insertSubview:addressImageView atIndex:1000];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.backgroundColor = [UIColor whiteColor];
    self.addressLabel.text = @"正在为您定位";
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = [UIColor grayColor];
    [addressImageView addSubview:self.addressLabel];
    
    UIButton *senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [senderButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [senderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    senderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    senderButton.backgroundColor = NAVIGATION_COLOR;
    senderButton.alpha = 0.7;
    senderButton.layer.borderColor = [UIColor orangeColor].CGColor;
    senderButton.layer.borderWidth = 2;
    senderButton.layer.cornerRadius = 30;
    [senderButton addTarget:self action:@selector(senderClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView insertSubview:senderButton atIndex:1000];
    
    CGFloat bottomHeight = 30;
    // 设配iPhone X底部
    if (_SCREEN_HEIGHT == 812) {
        bottomHeight = 64;
    }
    
    // 定位
    UIButton *positioningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [positioningButton setImage:[UIImage imageNamed:@"mapPositioning"] forState:UIControlStateNormal];
    [positioningButton setTitle:@"定位" forState:UIControlStateNormal];
    positioningButton.backgroundColor = [UIColor whiteColor];
    [positioningButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    positioningButton.titleLabel.font = [UIFont systemFontOfSize:12];
    positioningButton.layer.cornerRadius = 4;
    [positioningButton addTarget:self action:@selector(backToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView insertSubview:positioningButton atIndex:1000];
    
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.color = NAVIGATION_COLOR;
    [self.mapView insertSubview:self.activityView atIndex:1001];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(goBack)];
    
    [self.resultsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.searchBar.mas_left).offset(30);
        make.right.equalTo(weakSelf.searchBar.mas_right).offset(-30);
        make.top.equalTo(weakSelf.searchBar.mas_bottom).offset(2);
        make.height.equalTo(@140);
    }];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.mapView.mas_centerX);
        make.centerY.equalTo(weakSelf.mapView.mas_centerY).offset(-12);
    }];
    
    [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@43);
        make.centerX.equalTo(weakSelf.centerImageView.mas_centerX);
        make.bottom.equalTo(weakSelf.centerImageView.mas_top).offset(2);
        
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(addressImageView.mas_left).offset(20);
        make.right.equalTo(addressImageView.mas_right).offset(-20);
        make.centerY.equalTo(addressImageView.mas_centerY).offset(-2);
    }];
    
    [positioningButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mapView.mas_right).offset(-20);
        make.width.height.equalTo(@40);
        make.centerY.equalTo(senderButton.mas_centerY);
    }];
    
    
    [senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.centerX.equalTo(weakSelf.mapView.mas_centerX);
        make.bottom.equalTo(weakSelf.mapView.mas_bottom).offset(-bottomHeight);
    }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakSelf.mapView);
        make.width.height.equalTo(@50);
    }];
    
    [positioningButton setButtonImageTitleStyle:(ButtonImageTitleStyleTop) padding:2];
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
- (void)createGeoCodeSearch
{
    //初始化搜索对象 ，并设置代理
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //请求参数类BMKCitySearchOption
    _citySearchOption = [[BMKCitySearchOption alloc]init];
    _citySearchOption.pageCapacity = 10;
    _citySearchOption.city = @"成都";
}
/**
 搜索地理信息
 
 @param coordinate 坐标
 */
- (void)searchAddressCoordinate:(CLLocationCoordinate2D)coordinate
{
    TBWeakSelf
    [self.resultsView showAdderssPois:@[]];
    [_godeSearch searchAddressLatitude:coordinate.latitude longitude:coordinate.longitude searchResults:^(WCPositioningMode *mode) {
        weakSelf.addressLabel.text = mode.adderss;
        weakSelf.mode = mode;
        _citySearchOption.city = mode.cityName;
        [weakSelf.activityView stopAnimating];
    }];
}
#pragma mark  ----BMKPoiSearchDelegate----
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    [self.activityView stopAnimating];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [self.resultsView showAdderssPois:poiResultList.poiInfoList];
    }
    else
    {
        
        [UIView addMJNotifierWithText:@"没有搜索到结果" dismissAutomatically:YES];
    }
}

#pragma mark  ----UISearchBarDelegate----
//  结束编辑文本时调用该方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    
}
//  键盘上的搜索按钮点击的会调用该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [searchBar resignFirstResponder];
    if (searchBar.text.length > 0) {
        [self.activityView startAnimating];
        _citySearchOption.keyword = searchBar.text;
        //发起城市内POI检索
        BOOL flag = [_searcher poiSearchInCity:_citySearchOption];
        
        if(!flag)
        {
            [UIView addMJNotifierWithText:@"地址检索发送失败" dismissAutomatically:YES];
            [self.activityView stopAnimating];
        }
    }
    else
    {
        [self.activityView stopAnimating];
        [self backToUserLocation];
    }
}
//让 UISearchBar 支持空搜索，当没有输入的时候，search 按钮一样可以点击
- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

#pragma mark  ----BMKMapViewDelegate----
/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;
{
    // 如果是搜索地址改变的位置就不在重复发起地址编码
    if (self.isSearch == YES) {
        
        self.isSearch = NO;
        return;
    }
    [self.activityView startAnimating];
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
    [self.activityView startAnimating];
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
    [self.activityView stopAnimating];
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
#pragma mark  ----fun tool----
/**
 * 生成图片
 @param color 图片颜色
 @param height 图片高度
 @return 生成的图片
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    _searcher.delegate = nil;
    _mapView.delegate = nil;
    _locService.delegate = nil;
    
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

