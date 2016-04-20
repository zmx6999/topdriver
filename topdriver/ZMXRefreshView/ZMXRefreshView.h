//
//  ZMXRefreshView.h
//  microblog
//
//  Created by zmx on 16/1/28.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RefreshStateNormal = 0,
    RefreshStateBeginPull = 1,
    RefreshStateWillRefresh = 2,
    RefreshStateRefreshing = 3
} RefreshState;

typedef void(^RefreshBegin)();

@interface ZMXRefreshView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, copy) RefreshBegin refreshBegin;

+ (instancetype)refreshView;

+ (instancetype)refreshViewWithBeginPullText:(NSString *)beginPullText willRefreshText:(NSString *)willRefreshText refreshingText:(NSString *)refreshingText;

- (void)beginRefreshing;

- (void)endRefreshing:(BOOL)success;

@end