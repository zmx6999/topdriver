//
//  Request.h
//  topdriver
//
//  Created by zmx on 16/2/4.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;

@interface Request : NSObject

+ (void)loadMoreDataWithUrl:(NSString *)url page:(NSInteger)page completionHandler:(void(^)(NSArray *))completionHandler;

+ (void)loadNewDataWithUrl:(NSString *)url completionHandler:(void(^)(NSArray *))completionHandler;

+ (void)fetchCommentsWithMessage:(Message *)message completionHandler:(void(^)(NSArray *))completionHandler;

@end