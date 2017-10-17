//
//  CASRootNavigationViewController.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASRootNavigationViewController.h"
#import "UIBarButtonItem+CASBarButtonItem.h"

@interface CASRootNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CASRootNavigationViewController


#pragma mark - system
+ (void)load{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[CASRootNavigationViewController class]]];
    //设置字体大小
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    navBar.titleTextAttributes = attr;
    //设置背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置手势代理 左滑动
    self.interactivePopGestureRecognizer.delegate = self;
    
    //临时*****
    self.view.backgroundColor = [UIColor redColor];
    
}

#pragma mark - 私有方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {//非根控制器才添加返回按钮
        //隐藏底部导航栏
        viewController.hidesBottomBarWhenPushed = YES;
        //设置左边返回按钮
        UIImage *norImage = [UIImage imageNamed:@"navigationButtonReturn"];
        UIImage *hightImage = [UIImage imageNamed:@"navigationButtonReturnClick"];
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemBackWithNorImage:norImage highImage:hightImage target:self action:@selector(setBtnClick) title:@"返回"];
    }
    //父类方法
    [super pushViewController:viewController animated:animated];
}

#pragma mark - click
- (void)setBtnClick{
    [self popViewControllerAnimated:YES];
}

#pragma mark - delegate
#pragma mark - UIGestureRecognizerDelegate
//设置代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.childViewControllers.count > 1;//非根控制器才实现左侧滑动
}

@end
