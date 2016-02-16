//
//  ProgressView.m
//  topdriver
//
//  Created by zmx on 16/1/30.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ProgressView.h"
#import "ProgressContentView.h"

@interface ProgressView ()

@property (nonatomic, weak) ProgressContentView *contentView;

@end

@implementation ProgressView

- (void)setProgress:(NSInteger)progress {
    _progress = progress;
    self.contentView.progress = progress;
}

- (void)awakeFromNib {
    ProgressContentView *contentView = [[[NSBundle mainBundle] loadNibNamed:@"ProgressContentView" owner:nil options:nil] firstObject];
    self.contentView = contentView;
    [self addSubview:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

@end
