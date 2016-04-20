//
//  ZMXObject.m
//  UseFMDB
//
//  Created by zmx on 16/1/24.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ZMXObject.h"
#import <objc/runtime.h>

@implementation ZMXObject

- (NSArray *)getProperties {
    uint count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        const char *property_name = property_getName(properties[i]);
        NSString *property = [[NSString alloc] initWithCString:property_name encoding:NSUTF8StringEncoding];
        [arrM addObject:property];
    }
    free(properties);
    return arrM;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *properties = [self getProperties];
    for (int i = 0; i < properties.count; i++) {
        NSString *property = properties[i];
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    NSArray *properties = [self getProperties];
    for (int i = 0; i < properties.count; i++) {
        NSString *property = properties[i];
        [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
    }
    return self;
}

@end
