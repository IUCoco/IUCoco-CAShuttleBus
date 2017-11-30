//
//  AppDelegate.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASAppDelegate.h"
#import "CASLoginViewController.h"
#import "CASRootTabBarControllerViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CASAppDelegate ()<BMKGeneralDelegate>
{
    BMKMapManager *_mapManager;
}
@end

@implementation CASAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //**网络监测**
    
    
    //**地图设置**
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON]) {
        CASLog(@"经纬度类型设置成功");
    } else {
        CASLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:@"n5nznhtPGO5ryQLtITcBr0xzIDAjPQHd" generalDelegate:self];
    if (!ret) {
        CASLog(@"manager start failed!");
    }
    
    //**根控制器设置**
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口根控制器
    CASLoginViewController *rootVC = [[CASLoginViewController alloc] init];
//    CASRootTabBarControllerViewController *rootVC = [[CASRootTabBarControllerViewController alloc] init];
    //init底层调用 initWithNib
    self.window.rootViewController = rootVC;
    //3.设置为application的主窗口并且显示
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - baidumMap

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        CASLog(@"联网成功");
    }
    else{
        CASLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        CASLog(@"授权成功");
    }
    else {
        CASLog(@"onGetPermissionState %d",iError);
    }
}


@end
