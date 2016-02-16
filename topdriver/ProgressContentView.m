
//
//  ProgressView.m
//  topdriver
//
//  Created by zmx on 16/1/30.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ProgressContentView.h"

@interface ProgressContentView ()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation ProgressContentView

- (void)setProgress:(NSInteger)progress {
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%02ld", progress];
}

- (void)awakeFromNib {
    self.whiteView.layer.cornerRadius = 15;
    self.whiteView.layer.masksToBounds = YES;
}

@end
