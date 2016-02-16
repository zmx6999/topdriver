//
//  DetailImageIndex.h
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailImageIndex : NSObject

@property (nonatomic, strong) NSNumber *vPos;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) CGFloat duration;

+ (instancetype)indexWithDict:(NSDictionary *)dict;

@end
