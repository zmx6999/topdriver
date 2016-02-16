//
//  ShareView.h
//  topdriver
//
//  Created by zmx on 16/2/7.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareView;

@protocol ShareViewDelegate <NSObject>

- (void)shareViewDidClickCancel:(ShareView *)shareView;

@end

@interface ShareView : UIView

@property (nonatomic, copy) UIImage *shareIcon;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, copy) NSString *shareLink;

@property (nonatomic, weak) id<ShareViewDelegate> delegate;

@end
