//
//  UIView+ZMX.h
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZMX)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat h;

- (UIViewController *)getViewController;

@end
