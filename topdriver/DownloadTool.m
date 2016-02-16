//
//  DownloadTool.m
//  topdriver
//
//  Created by zmx on 16/1/30.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "DownloadTool.h"

static DownloadTool *instance;

@implementation DownloadTool

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

@end
