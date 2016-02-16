//
//  NotifyCell.m
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "NotifyCell.h"
#import "Notify.h"

@interface NotifyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIImageView *titleView;

@end

@implementation NotifyCell

- (void)setNotify:(Notify *)notify {
    _notify = notify;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURLStr, notify.notify_pic]]];
    
    __weak typeof(self.titleView) weakTitleView = self.titleView;
    [self.titleView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURLStr,notify.notify_content]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakTitleView.image = [UIImage imageWithImage:image tintColor:notify.visited ?[UIColor grayColor] : [UIColor blackColor]];
    }];
}

@end
