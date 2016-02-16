//
//  CommentCell.h
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentFrame;

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) UIView *separatorLine;

@property (nonatomic, strong) CommentFrame *commentFrame;

@property (nonatomic, assign, readonly) CGFloat h;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
