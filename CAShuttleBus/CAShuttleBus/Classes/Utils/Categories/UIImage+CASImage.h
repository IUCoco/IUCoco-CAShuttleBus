//
//  UIImage+CASImage.h
//  CAShuttleBus
//
//  Created by 清风 on 2017/10/16.
//  Copyright © 2017年 zjairchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CASImage)


/**
 圆形图片裁剪

 @param originalImage 原始图片
 @param size 开启图片上下文大小,最好和imageView的大小一致，圆形裁剪区域的圆的直径将为size.with(或size.height)
 @return 裁剪后的图片
 */
+ (UIImage *)imageWithRoundCut:(UIImage *)originalImage imageContext:(CGSize )size;

//快速创建没有被渲染的图片
+ (UIImage *)imageOriginalWithName:(NSString *)name;
//裁剪图片拉伸
+ (instancetype)resizableImageWithLocalImageNamed:(NSString *)localImageNamed;


@end
