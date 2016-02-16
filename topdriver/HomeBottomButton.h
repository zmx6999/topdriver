//
//  HomeBottomButton.h
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMXButton.h"

@class HomeBottomButton;

@protocol HomeBottomButtonDelegate <NSObject>

- (void)homeBottomButtonDidChangeState:(HomeBottomButton *)homeBottomButton;

@end

@interface HomeBottomButton : ZMXButton

@property (nonatomic, weak) UIView *view;

@property (nonatomic, strong) BaseViewController *controller;

@property (nonatomic, strong) MASConstraint *constraint;

@property (nonatomic, weak) id<HomeBottomButtonDelegate> delegate;

@end
