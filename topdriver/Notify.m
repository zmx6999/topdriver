//
//  Notify.m
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "Notify.h"

@implementation Notify

+ (instancetype)notifyWithDict:(NSDictionary *)dict {
    Notify *notify = [[self alloc] init];
    [notify setValuesForKeysWithDictionary:dict];
    return notify;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"visited"]) {
        self.visited = NO;
    }
}

@end
