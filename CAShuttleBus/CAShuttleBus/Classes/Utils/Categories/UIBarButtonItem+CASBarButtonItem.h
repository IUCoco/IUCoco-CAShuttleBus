//
//  UIBarButtonItem+CASBarButtonItem.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CASBarButtonItem)

//高亮
+ (UIBarButtonItem *)itemWithNorImage:(UIImage *)norImage highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
//setting返回按钮设置
+ (UIBarButtonItem *)itemBackWithNorImage:(UIImage *)norImage highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;
//选中
+ (UIBarButtonItem *)itemWithNorImage:(UIImage *)norImage selImage:(UIImage *)selImage target:(id)target action:(SEL)action;


@end
