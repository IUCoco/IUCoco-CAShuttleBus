//
//  CASRootTabBar.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/17.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "CASRootTabBar.h"
#import "UIView+CASFrame.h"

@interface CASRootTabBar ()

//记录之前点击的tabBarButton
@property(nonatomic, weak)UIControl *previousTabBarButton;

@end

@implementation CASRootTabBar

#pragma mark - system
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //跳转tabBar的位置
    NSInteger count = self.items.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    CGFloat btnX = 0;
    //布局tabBar
    NSInteger i = 0;
    //tabBarButton继承UIControl CZQLog(@"%@", tabBarButton.superclass);  2016-12-11 11:04:47.607 BuDeJie[3781:689525] UIControl
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            //为防止首次进来的时候previousTabBarButton的值为nil，因为还没有调用tabBarButtonClick:方法。将第一个UITabBarItem赋值
            if (i == 0 && self.previousTabBarButton == nil) {
                self.previousTabBarButton = tabBarButton;
            }
            
            btnX = btnW * i;
            tabBarButton.frame = CGRectMake(btnX, 0, btnW, btnH);
            i ++;
            
            //添加tabBarButton的点击监听事件
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - Click
//tabBarButton的点击监听事件
- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    //如果两次点击的都是同一个按钮则执行刷新操作
    if (self.previousTabBarButton == tabBarButton) {
        //        UIKeyboardWillHideNotification 仿照系统来为通知命名
        NSLog(@"双点击了%@", tabBarButton);
    }
    //如果两次点击的不是同一个按钮则对previousTabBarButton 进行重新赋值
    self.previousTabBarButton = tabBarButton;
    
}

@end
