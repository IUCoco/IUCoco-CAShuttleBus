//
//  CASServerURL.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/24.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

typedef NS_ENUM(NSUInteger, REQUEST_RESULT_STATE) {
    REQUEST_RESULT_STATE_SUCCEED_WITH_DATA,//请求成功的数据
    REQUEST_RESULT_STATE_SUCCEED_WITHOUT_DATA,//请求成功没有数据
    REQUEST_RESULT_STATE_FAILED_WITHOUT_NETWORK,//请求失败,没有网络
    REQUEST_RESULT_STATE_FAILED_WITH_SOME_TROUBLE//请求失败的一些麻烦
};

#define k_DRIVER_LOGIN_URL @"https://www.hzyis.com/PCDTH/login"
#define k_DRIVER_BUSROUTE_SCHEDULE @"https://www.hzyis.com/PCDTH/driverOrderList"
