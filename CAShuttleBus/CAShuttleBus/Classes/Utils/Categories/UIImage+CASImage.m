//
//  UIImage+CASImage.m
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import "UIImage+CASImage.h"

@implementation UIImage (CASImage)



+ (UIImage *)imageWithRoundCut:(UIImage *)originalImage imageContext:(CGSize)size {
    //开启和size一样大小的上下文
    UIGraphicsBeginImageContext(size);
    //设置一个圆形裁剪区域
    //绘制一个圆
    UIBezierPath *patn = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.width)];
    //把圆形的路径设置成裁剪区域
    [patn addClip];
    //把图片绘制到上下文中
    [originalImage drawAtPoint:CGPointZero];
    //从上下文取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

//快速创建没有被渲染的图片
+ (UIImage *)imageOriginalWithName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    return  [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//裁剪图片拉伸
+ (instancetype)resizableImageWithLocalImageNamed:(NSString *)localImageNamed{
    UIImage *normalImage = [UIImage imageNamed:localImageNamed];
    CGFloat normalImageWith = normalImage.size.width;
    CGFloat normalImagehight = normalImage.size.height;
    return [normalImage stretchableImageWithLeftCapWidth:normalImageWith * 0.5 topCapHeight:normalImagehight * 0.5];
}

@end
