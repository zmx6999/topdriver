//
//  HomeBottomButton.m
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "HomeBottomButton.h"

@implementation HomeBottomButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if ([self.delegate respondsToSelector:@selector(homeBottomButtonDidChangeState:)]) {
        [self.delegate homeBottomButtonDidChangeState:self];
    }
}

@end
