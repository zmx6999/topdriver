//
//  Comment.m
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "Comment.h"

@implementation Comment

+ (instancetype)commentWithDict:(NSDictionary *)dict {
    Comment *comment = [[self alloc] init];
    [comment setValuesForKeysWithDictionary:dict];
    return comment;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
