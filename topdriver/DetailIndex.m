//
//  DetailIndex.m
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "DetailIndex.h"
#import "DetailImageIndex.h"

@implementation DetailIndex

- (CGFloat)x {
    return self.view_x > 0.5?self.view_x / 414 * ScreenWidth : (ScreenWidth - self.w) * 0.5;
}

- (CGFloat)y {
    return self.view_y / 736 * ScreenHeight;
}

- (CGFloat)w {
    return self.view_w / 414 * ScreenWidth;
}

- (CGFloat)h {
    return self.view_h / 736 * ScreenHeight;
}

- (CGFloat)bw {
    return (ScreenWidth - self.rollMargin * 3) * 0.5;
}

- (CGFloat)bh {
    return self.blockHeight / 736 * ScreenHeight;
}

- (CGFloat)rollMargin {
    return self.x;
}

- (NSArray *)rolls {
    return [self.roll componentsSeparatedByString:@","];
}

- (NSMutableArray *)imageViews {
    if (_imageViews == nil) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

+ (instancetype)indexWithDict:(NSDictionary *)dict {
    DetailIndex *index = [[self alloc] init];
    [index setValuesForKeysWithDictionary:dict];
    return index;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"images"]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (int i = 0; i < [value count]; i++) {
            if ([[value objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                [arrM addObject:[DetailImageIndex indexWithDict:[value objectAtIndex:i]]];
            }
        }
        self.images = arrM;
        if (self.images.count < 1) {
            [super setValue:value forKey:key];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"class"]) {
        self.className = value;
    }
}

@end
