//
//  CommentFrame.m
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "CommentFrame.h"
#import "Comment.h"

@implementation CommentFrame

- (void)setComment:(Comment *)comment {
    _comment = comment;
    
    CGFloat iconX = 10;
    CGFloat iconY = 10;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat usernameX = CGRectGetMaxX(_iconFrame) + 10;
    CGFloat usernameY = iconY;
    CGSize usernameSize = [comment.username sizeWithFont:usernameFont];
    _usernameFrame = (CGRect){CGPointMake(usernameX, usernameY), usernameSize};
    
    CGSize dateSize = [comment.comment_date sizeWithFont:dateFont];
    CGFloat dateX = ScreenWidth - dateSize.width - 10;
    CGFloat dateY = usernameY;
    _dateFrame = (CGRect){CGPointMake(dateX, dateY), dateSize};
    
    CGFloat contentX = usernameX;
    CGFloat contentY = CGRectGetMaxY(_usernameFrame) + 10;
    CGSize contentSize = [comment.comment_content sizeWithFont:contentFont constrainedToSize:CGSizeMake(ScreenWidth - contentX - 10, MAXFLOAT)];
    _contentFrame = (CGRect){CGPointMake(contentX, contentY), contentSize};
    
    CGFloat separatorX = 0;
    CGFloat separatorY = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_contentFrame)) + 10;
    CGFloat separatorW = ScreenWidth;
    CGFloat separatorH = 1;
    _separatorFrame = CGRectMake(separatorX, separatorY, separatorW, separatorH);
    
    _cellHeight = CGRectGetMaxY(_separatorFrame);
}

@end
