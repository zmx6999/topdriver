//
//  Comment.h
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, copy) NSString *comment_content;

@property (nonatomic, copy) NSString *userPhoto;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *comment_date;

+ (instancetype)commentWithDict:(NSDictionary *)dict;

@end
