//
//  News.h
//  topdriver
//
//  Created by zmx on 16/1/29.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : ZMXObject

@property (nonatomic, copy) NSString *cover_pic;

@property (nonatomic, copy) NSString *title_pic;

@property (nonatomic, copy) NSString *plist_content;

@property (nonatomic, copy, readonly) NSString *cachePlistContent;

@property (nonatomic, copy) NSString *post_id;

@property (nonatomic, copy) NSString *title_color;

@property (nonatomic, copy) NSString *praise_cnt;

@property (nonatomic, assign) BOOL visited;

@property (nonatomic, assign) BOOL praised;

+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
