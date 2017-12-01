//
//  CASDriverItem.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/12/1.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASDriverItem : NSObject<NSCopying, NSMutableCopying>


//**不使用NSInter的原因是数字前面有0例如0571,0会被自动去掉**
//司机编码
@property (nonatomic, copy) NSString *driver_id;
//司机负责班车城市编码 杭州:0571
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *driver_sex;
@property (nonatomic, copy) NSString *driver_remark;
@property (nonatomic, copy) NSString *driver_mobile;
@property (nonatomic, copy) NSString *driver_birthday;
//司机状态 1代表可用
@property (nonatomic, assign) NSInteger driver_status;
@property (nonatomic, copy) NSString *driver_name;
//司机登录账号
@property (nonatomic, copy) NSString *driver_account;

//单利存储driver信息，以便其他接口拼接参数
//**这里不使用YYCache的原因是，防止被双向链表移除**
+ (instancetype)sharedDriver;

@end
