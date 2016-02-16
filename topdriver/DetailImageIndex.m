//
//  DetailImageIndex.m
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "DetailImageIndex.h"

@implementation DetailImageIndex

+ (instancetype)indexWithDict:(NSDictionary *)dict {
    DetailImageIndex *index = [[self alloc] init];
    NSLog(@"%@", cachePath);
    [index setValuesForKeysWithDictionary:dict];
    return index;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
