//
//  CASShuttleBusRouteViewController.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/11/21.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidClickTextFieldBlock)();

@interface CASShuttleBusRouteViewController : UIViewController

@property (nonatomic, strong) UITableView *myTab;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, copy) DidClickTextFieldBlock didClickTextFieldBlock;

- (void)didClickTextField:(DidClickTextFieldBlock)block;

@end
