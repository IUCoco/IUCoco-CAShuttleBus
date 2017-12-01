//
//  CASDriverItem.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/12/1.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASDriverItem.h"

@implementation CASDriverItem

static CASDriverItem *_driverInstance;

#pragma mark - single
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_driverInstance == nil) {
            _driverInstance = [super allocWithZone:zone];
        }
    });
    return _driverInstance;
}

+ (instancetype)sharedDriver {
    return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone {
    return _driverInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _driverInstance;
}

@end
