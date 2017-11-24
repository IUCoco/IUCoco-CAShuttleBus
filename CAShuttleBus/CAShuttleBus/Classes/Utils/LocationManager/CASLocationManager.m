//
//  CASLocationManager.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/24.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASLocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import "CASBackgroundTaskManager.h"


@interface CASLocationManager()<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, assign) NSTimeInterval nowLocationTime;
@property (nonatomic, assign) NSTimeInterval lastLocationTime;
@property (nonatomic) NSTimer *backGroundLocationTime;
@property (nonatomic) NSTimer *restartTime;

@property (nonatomic) CASBackgroundTaskManager *bgTask;
@property (nonatomic, readwrite) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic, copy, readwrite) NSString *lastGeocoderAddress;

@end

//为iOS8定位
static CLLocationManager *clLocationManager;
@implementation CASLocationManager

#pragma mark - Lifecycle (生命周期)
+ (CASLocationManager *)sharedLocationManager{
    static CASLocationManager *LocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LocationManager = [[self alloc]init];
    });
    return LocationManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.locationService = [[BMKLocationService alloc]init];
        
        clLocationManager = [[CLLocationManager alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [self.restartTime invalidate];
    self.restartTime = nil;
    [self.backGroundLocationTime invalidate];
    self.backGroundLocationTime = nil;
}

#pragma mark - Custom Accessors (自定义控制器)
- (void)setIsBackGroundLocation:(BOOL)isBackGroundLocation{
    _isBackGroundLocation = isBackGroundLocation;
    if (isBackGroundLocation) {
        self.locationInterval = 60;
        self.locationService.pausesLocationUpdatesAutomatically = NO;
        if (CASiOS9Later) {
            self.locationService.allowsBackgroundLocationUpdates = YES;
        }
    }
    else{
        self.locationInterval = 0;
        self.locationService.pausesLocationUpdatesAutomatically = YES;
        if (CASiOS9Later) {
            self.locationService.allowsBackgroundLocationUpdates = NO;
        }
    }
}

- (void)setLocationInterval:(NSTimeInterval)locationInterval{
    if (locationInterval!=0) {
        NSAssert(self.isBackGroundLocation, @"isBackGroundLocation为NO");
        //        NSParameterAssert(self.isBackGroundLocation); //如果isBackGroundLocation为NO 将会报错
    }
    _locationInterval = locationInterval;
    
    if (self.backGroundLocationTime) {
        [self.backGroundLocationTime invalidate];
        self.backGroundLocationTime = nil;
    }
}

- (void)setCASBackGroundLocationHander:(void (^)(CLLocationCoordinate2D))CASBackGroundLocationHander{
    if (!self.isBackGroundLocation) { //如果 isBackGroundLocation为NO 后台定位将无效
        return;
    }
    _CASBackGroundLocationHander = [CASBackGroundLocationHander copy];
}

#pragma mark - Public (公有方法)

- (void)receiveCoorinate:(void (^)(CLLocationCoordinate2D, NSError *))coordinateHander geocderAddress:(void (^)(NSString *, NSUInteger))addressHander{
    self.CASLocationCoordinate = [coordinateHander copy];
    self.CASLocationGeocderAddress = [addressHander copy];
}
- (void)geoCodeSearchWithCoorinate:(CLLocationCoordinate2D)coordinate address:(void (^)(NSString *, NSUInteger))address{
    self.CASLocationGeocderAddress = [address copy];
}

- (void)startLocationService{
    
    self.nowLocationTime = [[NSDate date] timeIntervalSince1970];
    
    //当前时间和最后一次时间相差大于8秒 将重新开启定位 否则返回最近一次定位坐标
    if (self.nowLocationTime - self.lastLocationTime > 8) {
        if (![self _checkCLAuthorizationStatus]) {
            return;
        }
        self.locationService.delegate = self;
        [self.locationService startUserLocationService];
    }
    else{
        if (self.CASLocationCoordinate) {
            self.CASLocationCoordinate(self.lastCoordinate, nil);
            //如果需要反地理编码
            if (self.CASLocationGeocderAddress) {
                [self reverseGeoCodeCoordinate:self.lastCoordinate];
            }
        }
    }
}

- (void)stopLocationService{
    
    if (self.backGroundLocationTime) {
        [self.backGroundLocationTime invalidate];
        self.backGroundLocationTime = nil;
    }
    if (self.restartTime) {
        [self.restartTime invalidate];
        self.restartTime = nil;
    }
    self.locationService.delegate = nil;
    [self.locationService stopUserLocationService];
    
}

#pragma mark - Private (私有方法)
- (void)restartLocationUpdates{
    CASLog(@"重启定位服务");
    if (self.restartTime) {
        [self.restartTime invalidate];
        self.restartTime = nil;
    }
    [self startLocationService];
}

- (void)backGroundBackCoordinate{
    if ([self _checkCLAuthorizationStatus]) {
        if (self.CASBackGroundLocationHander) {
            CLLocationCoordinate2D LocationCoordinate = self.lastCoordinate;
            self.CASBackGroundLocationHander(LocationCoordinate);
        }
        if (self.CASBackGroundGeocderAddressHander) {
            NSString *address = self.lastGeocoderAddress;
            self.CASBackGroundGeocderAddressHander(address);
        }
    }
}

//检测是否打开定位
- (BOOL)_checkCLAuthorizationStatus{
    if ([CLLocationManager locationServicesEnabled] == NO){
        CASLog(@"你目前有这个设备的所有位置服务禁用");
        return NO;
    }else{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            CASLog(@"请开启定位服务");
            return NO;
        }
        return YES;
    }
}

- (void)applicationEnterBackground{
    
    if (self.isBackGroundLocation) {
        
        if (CASiOS8Later) {
            [clLocationManager requestAlwaysAuthorization];
        }
        [self startLocationService];
        
        //如果是需要进行后台定位将设置后台任务
        self.bgTask = [CASBackgroundTaskManager sharedBackgroundTaskManager];
        [self.bgTask beginNewBackgroundTask];
    }
}

- (void)reverseGeoCodeCoordinate:(CLLocationCoordinate2D)coordinate{
    BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reversegeoCode = [[BMKReverseGeoCodeOption alloc]init];
    reversegeoCode.reverseGeoPoint = coordinate;
    BOOL flag = [geoCodeSearch reverseGeoCode:reversegeoCode];
    if (flag) {
        NSLog(@"反检索成功");
    }
    else
    {
        NSLog(@"反检索失败");
    }
}

#pragma mark - Protocol conformance (协议代理)
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    self.lastLocationTime = [[NSDate date] timeIntervalSince1970];
    
    self.lastCoordinate = userLocation.location.coordinate;
    if (self.CASLocationCoordinate) {
        CLLocationCoordinate2D LocationCoordinate = userLocation.location.coordinate;
        self.CASLocationCoordinate(LocationCoordinate, nil);
    }
    
    if (self.CASLocationGeocderAddress) {
        [self reverseGeoCodeCoordinate:userLocation.location.coordinate];
    }
    
    if (self.isBackGroundLocation) {
        
        if (self.restartTime) {
            return;
        }
        
        self.bgTask = [CASBackgroundTaskManager sharedBackgroundTaskManager];
        [self.bgTask beginNewBackgroundTask];
        
        
        if (!self.backGroundLocationTime) {
            self.backGroundLocationTime = [NSTimer scheduledTimerWithTimeInterval:self.locationInterval target:self
                                                                         selector:@selector(backGroundBackCoordinate)
                                                                         userInfo:nil
                                                                          repeats:YES];
            [self backGroundBackCoordinate];
            [[NSRunLoop currentRunLoop] addTimer:self.backGroundLocationTime forMode:NSRunLoopCommonModes];
        }
        
        //如果1分钟没有调用代理将重启定位服务
        self.restartTime = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                          selector:@selector(restartLocationUpdates)
                                                          userInfo:nil
                                                           repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.restartTime forMode:NSRunLoopCommonModes];
    }
    else{
        [self stopLocationService];
    }
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    if (self.CASLocationCoordinate) {
        CLLocationCoordinate2D errorCoordinate;
        self.CASLocationCoordinate(errorCoordinate, error);
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.lastGeocoderAddress = result.address;
    }
    else{
        self.lastGeocoderAddress = @"未知位置";
        
    }
    if (self.CASLocationGeocderAddress) {
        NSString *address = self.lastGeocoderAddress;
        self.CASLocationGeocderAddress(address, error);
    }
}


@end
