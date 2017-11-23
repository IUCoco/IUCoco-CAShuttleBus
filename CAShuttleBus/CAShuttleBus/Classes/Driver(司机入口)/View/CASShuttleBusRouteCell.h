//
//  CASShuttleBusRouteCell.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/21.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CASShuttleBusRouteItem;

typedef void(^ButtonClick)(UIButton *btn);

@interface CASShuttleBusRouteCell : UITableViewCell

@property (nonatomic, strong) CASShuttleBusRouteItem *item;
@property (nonatomic, copy)ButtonClick lineDepartureBtnClick;

@end
