//
//  NewsCell.m
//  topdriver
//
//  Created by zmx on 16/1/29.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@property (weak, nonatomic) IBOutlet UIImageView *titleView;

@end

@implementation MessageCell

- (void)setMessage:(Message *)message {
    _message = message;
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURLStr, message.cover_pic]]];
    
    __weak typeof(self) weakSelf = self;
    [self.titleView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURLStr, message.title_pic]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.titleView.image = [UIImage imageWithImage:image tintColor:message.visited ?[UIColor grayColor] : [UIColor blackColor]];
    }];
}

@end
