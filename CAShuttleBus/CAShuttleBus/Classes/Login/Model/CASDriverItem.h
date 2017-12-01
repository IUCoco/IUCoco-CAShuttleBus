//
//  CASDriverItem.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/12/1.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASDriverItem : NSObject

//司机编码
@property (nonatomic, assign) NSInteger driver_id;
//司机负责班车城市编码 杭州:0571
@property (nonatomic, assign) NSInteger city;
@property (nonatomic, copy) NSString *driver_sex;
@property (nonatomic, copy) NSString *driver_mobile;
@property (nonatomic, copy) NSString *driver_birthday;
//司机状态 1代表可用
@property (nonatomic, copy) NSString *driver_status;
@property (nonatomic, copy) NSString *driver_name;
//司机登录账号
@property (nonatomic, copy) NSString *driver_account;

@end
