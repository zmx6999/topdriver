//
//  CacheTool.h
//  topdriver
//
//  Created by zmx on 16/2/4.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;
@class Notify;

@interface CacheTool : NSObject

+ (instancetype)sharedTool;

- (void)insertMessage:(Message *)message;

- (NSArray *)fetchMessages;

- (void)clearMessages;

- (void)insertNotify:(Notify *)notify;

- (NSArray *)fetchNotifies;

- (void)clearNotifies;

@end
