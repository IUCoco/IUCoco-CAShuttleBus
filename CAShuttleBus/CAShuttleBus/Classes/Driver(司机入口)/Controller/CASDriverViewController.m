//
//  CASDriverViewController.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/17.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASDriverViewController.h"
#import "CASShuttleBusRouteViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import<BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CASLocationManager.h"

#define Y1               50
#define Y2               self.view.frame.size.height - 250
#define Y3               self.view.frame.size.height - 64

@interface CASDriverViewController ()<UIGestureRecognizerDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) CASShuttleBusRouteViewController *shuttleBusRouteVC;

// 用来显示阴影的view，里面装的是self.shuttleBusRouteVC.view
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipe1;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) BMKMapView *mapView;
/** 定位功能 */
@property (nonatomic, strong) BMKLocationService *locService;
/** 地理编码 */
//@property (nonatomic, strong) CLGeocoder *geoC;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearcher;

//@property (nonatomic, strong) BMKUserLocation *userLocation;
//自己地址坐标
@property (nonatomic, assign) CLLocationCoordinate2D selfLocation;
//目标地址坐标
@property (nonatomic, assign) CLLocationCoordinate2D aidLocation;

@property (nonatomic, strong) CASLocationManager *locManager;

@end

@implementation CASDriverViewController

#pragma mark - lazyload

- (CASShuttleBusRouteViewController *)shuttleBusRouteVC {
    if (!_shuttleBusRouteVC) {
        _shuttleBusRouteVC = [[CASShuttleBusRouteViewController alloc] init];
        
        
        // -------------- 添加手势 轻扫手势  -----------
        self.swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        self.swipe1.direction = UISwipeGestureRecognizerDirectionDown ; // 设置手势方向
        //    [self.view addGestureRecognizer:swipe];
        
        self.swipe1.delegate = self;
        [_shuttleBusRouteVC.myTab addGestureRecognizer:self.swipe1];
        
        UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipe2.direction = UISwipeGestureRecognizerDirectionUp; // 设置手势方向
        //    [self.view addGestureRecognizer:swipe];
        swipe2.delegate = self;
        [_shuttleBusRouteVC.myTab addGestureRecognizer:swipe2];
    }
    return _shuttleBusRouteVC;
}

-(UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, Y1, self.view.frame.size.width, self.view.frame.size.height);//设置展示初始位置
        //        _shadowView.backgroundColor = [UIColor clearColor];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowRadius = 10;
        _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
        _shadowView.layer.shadowOpacity = 0.8;                       //      不透明度
    }
    return _shadowView;
}

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self mapView];
    //设置定位
    [self locService];
    //地理编码反编码
    [self geoSearcher];
    //后台任务持续定位
    [self startLocationService];
    //隐藏nav+tabBar
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self addChildViewController:self.shuttleBusRouteVC];
    [self.shadowView addSubview:self.shuttleBusRouteVC.view];
    [self.view addSubview:self.shadowView];
    
    [self.shuttleBusRouteVC didClickTextField:^{//点击了TextField直接上升至最高点
        [UIView animateWithDuration:0.4 animations:^{
            self.shadowView.frame = CGRectMake(0, 50, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        } completion:^(BOOL finished) {
            [self.shuttleBusRouteVC.searchController.searchBar becomeFirstResponder];
        }];
        // 更新offsetY
        self.shuttleBusRouteVC.offsetY = self.shadowView.frame.origin.y;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"-----------  ------------");
    // searchBar收起键盘
    UIButton *cancelBtn = [self.shuttleBusRouteVC.searchController.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    // 代码触发Button的点击事件
    [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 手势判断
// table可滑动时，swipe默认不再响应 所以要打开
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    float stopY = 0;     // 停留的位置
    float animateY = 0;  // 做弹性动画的Y
    float margin = 10;   // 动画的幅度
    float offsetY = self.shadowView.frame.origin.y; // 这是上一次Y的位置
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
        if (self.shuttleBusRouteVC.myTab.contentOffset.y == 0) {
            self.shuttleBusRouteVC.myTab.scrollEnabled = NO;
        }
        //三段位置方式
#if 0
        if (offsetY >= Y1 && offsetY < Y2) {
            // 停在y2的位置
            stopY = Y2;
        }else if (offsetY >= Y2 ){
            // 停在y3的位置
            stopY = Y3;
        }else{
            stopY = Y1;
        }
#endif
        //两段位置方式
        if (offsetY >= Y1) {
            stopY = Y3;
        }else {
            stopY = Y1;
        }
        
        animateY = stopY + margin;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        //三段位置方式
#if 0
        if (offsetY <= Y2) {//中间段位直接上滑动至最上
            // 停在y1的位置
            stopY = Y1;
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
            self.shuttleBusRouteVC.myTab.scrollEnabled = YES;
        }else if (offsetY > Y2 && offsetY <= Y3 ){
            stopY = Y2;
        }else{
            stopY = Y3;
        }
#endif
        //两段位置方式
        if (offsetY <= Y3) {
            stopY = Y1;
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
            self.shuttleBusRouteVC.myTab.scrollEnabled = YES;
        }else {
            stopY = Y3;
        }
        animateY = stopY - margin;
    }

    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.shadowView.frame = CGRectMake(0, animateY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    // 记录shadowView在第一个视图中的位置
    self.shuttleBusRouteVC.offsetY = stopY;
}

/**
 返回值为NO  swipe不响应手势 table响应手势
 返回值为YES swipe、table也会响应手势, 但是把table的scrollEnabled为No就不会响应table了
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //    NSLog(@"----------- table =  %f ------------",self.vc.table.contentOffset.y);
    // 触摸事件，一响应 就把searchBar的键盘收起来
    // searchBar收起键盘
    UIButton *cancelBtn = [self.shuttleBusRouteVC.searchController.searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    // 代码触发Button的点击事件
    [cancelBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    // 当table Enabled且offsetY不为0时，让swipe响应
    if (self.shuttleBusRouteVC.myTab.scrollEnabled == YES && self.shuttleBusRouteVC.myTab.contentOffset.y != 0) {
        return NO;
    }
    if (self.shuttleBusRouteVC.myTab.scrollEnabled == YES) {
        return YES;
    }
    return NO;
}

#pragma mark - baiduMap处理合集

#pragma mark - baiduMap_lazyMapView
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.zoomLevel = 17;//14不错
        [self.view addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom).offset(-64);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _mapView;
}

- (BMKLocationService *)locService {
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
        //设定定位精度
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        //开启定位
        [_locService startUserLocationService];
    }
    return _locService;
}

#pragma mark - baiduMap_生命周期
/**
 自2.0.0起，BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegate
 */

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geoSearcher.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geoSearcher.delegate = nil;
}

#pragma mark - 定位代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //展示定位
    self.mapView.showsUserLocation = YES;
    //更新位置数据
    [self.mapView updateLocationData:userLocation];
    //获取用户的坐标
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    //发起反向地理编码检索 获取当前位置具体信息
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    self.selfLocation = pt;
    CASLog(@"纬度%f,精度%f", pt.latitude, pt.longitude);
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - Geocoder
/** 地理编码管理器 */
//- (CLGeocoder *)geoC
//{
//    if (!_geoC) {
//        _geoC = [[CLGeocoder alloc] init];
//    }
//    return _geoC;
//}

- (BMKGeoCodeSearch *)geoSearcher {
    if (!_geoSearcher) {
        _geoSearcher = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoSearcher;
}

//正向地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
}


//接收反向地理编码结果
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"Success找到结果");
        CASLog(@"%@+++++++++%@++++++++%@+++++%zd", result.addressDetail, result.address, result.businessCircle, result.location);
        //本地定位位置
        NSString *selfLocationStr = [NSString stringWithFormat:@"%@:%@", result.address, result.businessCircle];
        CASLog(@"++++---%@++++---", selfLocationStr);
//        self.selfLocation = result.location;
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - backWorkTest

- (void)startLocationService{
    
    CASLocationManager *manager = [CASLocationManager sharedLocationManager];
    manager.isBackGroundLocation = YES;
    manager.locationInterval = 10;
    //    @weakify(manager)
    [manager setCASBackGroundLocationHander:^(CLLocationCoordinate2D coordinate) {
        CASLog(@"---latitude----%f,,----longitude----%f",coordinate.latitude,coordinate.longitude);
        //        @strongify(manager) //注意别造成循环引用
        //        [manager geoCodeSearchWithCoorinate:coordinate address:^(NSString *address, NSUInteger error) {
        //            YZLMLOG(@">>>>>>>>>>address:%@",address);
        //        }];
    }];
    
    [manager setCASBackGroundGeocderAddressHander:^(NSString *address) {
        CASLog(@">>>>>>>>>>address:%@",address);
    }];
    [manager startLocationService];
}

@end
