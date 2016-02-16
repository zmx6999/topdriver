//
//  CommentFrame.h
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <Foundation/Foundation.h>

#define usernameFont [UIFont systemFontOfSize:14]
#define contentFont [UIFont systemFontOfSize:15]
#define dateFont [UIFont systemFontOfSize:10]

@class Comment;

@interface CommentFrame : NSObject

@property (nonatomic, strong) Comment *comment;

@property (nonatomic, assign, readonly) CGRect iconFrame;

@property (nonatomic, assign, readonly) CGRect usernameFrame;

@property (nonatomic, assign, readonly) CGRect contentFrame;

@property (nonatomic, assign, readonly) CGRect dateFrame;

@property (nonatomic, assign ,readonly) CGRect separatorFrame;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
