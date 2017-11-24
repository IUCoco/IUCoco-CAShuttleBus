//
//  CASBackgroundTaskManager.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/24.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASBackgroundTaskManager : NSObject

+ (instancetype)sharedBackgroundTaskManager;

- (UIBackgroundTaskIdentifier)beginNewBackgroundTask;
- (void)endAllBackgroundTasks;

@end
