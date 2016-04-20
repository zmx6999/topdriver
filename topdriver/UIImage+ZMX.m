//
//  UIImage+ZMX.m
//  topdriver
//
//  Created by zmx on 16/1/29.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "UIImage+ZMX.h"

@implementation UIImage (ZMX)

+ (UIImage *)imageWithImage:(UIImage *)image tintColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGRect rect = (CGRect){CGPointZero, image.size};
    CGContextClipToMask(context, rect, image.CGImage);
    [color set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeNormal);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end