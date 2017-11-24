//
//  CASLocationManager.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/24.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CASLocationManager : NSObject

//是否开启后台定位 默认为NO
@property (nonatomic, assign) BOOL isBackGroundLocation;

//isBackGroudLocation为YES时，设置LocationInterval默认为1分钟
@property (nonatomic, assign) NSTimeInterval locationInterval;

//后台定位开启时 返回定位经纬度
@property (nonatomic, copy) void (^CASBackGroundLocationHander) (CLLocationCoordinate2D coordinate);

//后台定位开启时 返回反编码地理位置
@property (nonatomic, copy) void (^CASBackGroundGeocderAddressHander) (NSString *address);

//获取经纬度
@property (nonatomic, copy) void (^CASLocationCoordinate) (CLLocationCoordinate2D coordinate, NSError *error);

//获取反编码地理位置
@property (nonatomic, copy) void (^CASLocationGeocderAddress) (NSString *address, NSUInteger error);

//最近一次定位的经纬度
@property (nonatomic, readonly) CLLocationCoordinate2D lastCoordinate;

//最近一次反编码地理位置
@property (nonatomic, copy, readonly) NSString *lastGeocoderAddress;
//通过单例创建
+ (CASLocationManager *)sharedLocationManager;

//获取经纬度和反编码地理位置
- (void)receiveCoorinate:(void (^)(CLLocationCoordinate2D coordinate, NSError *error))coordinateHander geocderAddress:(void (^)(NSString *address, NSUInteger error))addressHander;

//传入经纬度获取反编码地理位置
- (void)geoCodeSearchWithCoorinate:(CLLocationCoordinate2D)coordinate address:(void (^)(NSString *address, NSUInteger error))address;

//开始定位
- (void)startLocationService;

//停止定位
- (void)stopLocationService;

@end
