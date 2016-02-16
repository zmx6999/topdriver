//
//  DetailIndex.h
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailIndex : NSObject

@property (nonatomic, copy) NSString *className;

@property (nonatomic, assign) CGFloat view_x;

@property (nonatomic, assign, readonly) CGFloat x;

@property (nonatomic, assign) CGFloat view_y;

@property (nonatomic, assign, readonly) CGFloat y;

@property (nonatomic, assign) CGFloat view_w;

@property (nonatomic, assign, readonly) CGFloat w;

@property (nonatomic, assign) CGFloat view_h;

@property (nonatomic, assign, readonly) CGFloat h;

@property (nonatomic, assign) CGFloat blockWidth;

@property (nonatomic, assign, readonly) CGFloat bw;

@property (nonatomic, assign) CGFloat blockHeight;

@property (nonatomic, assign, readonly) CGFloat bh;

@property (nonatomic, copy) NSString *roll;

@property (nonatomic, assign, readonly) NSArray *rolls;

@property (nonatomic, assign, readonly) CGFloat rollMargin;

@property (nonatomic, copy) NSString *link_url;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, copy) NSString *linked_image;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, weak) UIImageView *movingView;

@property (nonatomic, strong) MASConstraint *movingViewTop;

+ (instancetype)indexWithDict:(NSDictionary *)dict;

@end
