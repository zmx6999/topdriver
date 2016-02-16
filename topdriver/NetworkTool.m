//
//  NetworkTool.m
//  topdriver
//
//  Created by zmx on 16/1/29.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "NetworkTool.h"

static NetworkTool *tool;

@implementation NetworkTool

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLStr] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return tool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [super allocWithZone:zone];
    });
    return tool;
}

@end
