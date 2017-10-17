//
//  CASRootTabBarControllerViewController.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASRootTabBarControllerViewController.h"
#import "CASRootTabBar.h"
#import "CASDriverViewController.h"
#import "CASRootNavigationViewController.h"
#import "UIImage+CASImage.h"

@interface CASRootTabBarControllerViewController ()

@end

@implementation CASRootTabBarControllerViewController

//代码加载进内存时候调用，只调用一次
+ (void)load {
    //全局修改 appearance 制定修改
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[CASRootTabBarControllerViewController class]]];
    //设置字体颜色，防止被渲染1
    NSMutableDictionary *attributesSel = [NSMutableDictionary dictionary];
    attributesSel[NSForegroundColorAttributeName] = [UIColor blackColor];
    attributesSel[NSFontAttributeName] = [UIFont systemFontOfSize:50];
    [tabBarItem setTitleTextAttributes:attributesSel forState:UIControlStateSelected];
    //设置字体大小 只有在正常状态下才能设置字体大小
    NSMutableDictionary *attributesNor = [NSMutableDictionary dictionary];
    attributesNor[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [tabBarItem setTitleTextAttributes:attributesNor forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加所有子控制器
    [self setUPAllChildViewController];
    //设置所有tabBarItem
    [self setUpAlltabBarItemContent];
    //自定义tabBar
    [self setUpTabBar];
    //默认进入首页，不然有问题
    self.selectedIndex = 0;
}


#pragma mark - 私有方法
//自定义tabBar
- (void)setUpTabBar {
    CASRootTabBar *tabBar = [[CASRootTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

//添加所有子控制器
- (void)setUPAllChildViewController {
    //司机入口
    CASDriverViewController *driverVC = [[CASDriverViewController alloc] init];
    CASRootNavigationViewController *driverNVC = [[CASRootNavigationViewController alloc] initWithRootViewController:driverVC];
    [self addChildViewController:driverNVC];
}

//设置所有tabBarItem
- (void)setUpAlltabBarItemContent {
    //司机入口
    CASRootNavigationViewController *driverNVC = self.childViewControllers[0];
    driverNVC.tabBarItem.title = @"司机";
    driverNVC.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_essence_icon"];
    driverNVC.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
}



@end
