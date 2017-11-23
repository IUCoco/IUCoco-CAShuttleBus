//
//  CASShuttleBusRouteItem.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/23.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASShuttleBusRouteItem : NSObject

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *startPoint;
@property (nonatomic, copy) NSString *endPoint;
@property (nonatomic, copy) NSString *busType;
@property (nonatomic, copy) NSString *LineTime;

@end
