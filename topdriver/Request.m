//
//  Request.m
//  topdriver
//
//  Created by zmx on 16/2/4.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "Request.h"
#import "Message.h"

@implementation Request

+ (void)loadMoreDataWithUrl:(NSString *)url page:(NSInteger)page completionHandler:(void(^)(NSArray *))completionHandler {
    NSString *urlStr = [NSString stringWithFormat:@"%@?v=%@&page=%ld&count=10", url, Version, page];
    [SharedNetworkTool GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject[@"result"];
        completionHandler(arr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        completionHandler(nil);
    }];
}

+ (void)loadNewDataWithUrl:(NSString *)url completionHandler:(void(^)(NSArray *))completionHandler {
    [self loadMoreDataWithUrl:url page:0 completionHandler:completionHandler];
}

+ (void)fetchCommentsWithMessage:(Message *)message completionHandler:(void(^)(NSArray *))completionHandler {
    [SharedNetworkTool GET:[NSString stringWithFormat:@"http://adm.topdriverclub.com/iphone/api/content/getComments?token=98286C947691DFD7D453D92FD0FFED5F&v=%@&post_id=%@", Version, message.post_id] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *comments = responseObject[@"result"];
        completionHandler(comments);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        completionHandler(nil);
    }];
}

@end