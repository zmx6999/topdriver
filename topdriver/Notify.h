//
//  Notify.h
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notify : ZMXObject

@property (nonatomic, copy) NSString *notify_id;

@property (nonatomic, copy) NSString *notify_content;

@property (nonatomic, copy) NSString *notify_pic;

@property (nonatomic, copy) NSString *notify_url;

@property (nonatomic, assign) BOOL visited;

+ (instancetype)notifyWithDict:(NSDictionary *)dict;

@end
