//
//  CommentCell.m
//  topdriver
//
//  Created by zmx on 16/1/31.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import "CommentFrame.h"

@interface CommentCell ()

@property (weak, nonatomic) UIImageView *iconView;

@property (weak, nonatomic) UILabel *usernameLabel;

@property (weak, nonatomic) UILabel *contentLabel;

@property (weak, nonatomic) UILabel *dateLabel;

@end

@implementation CommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"comment";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = Color(250, 250, 250);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    [self.contentView addSubview:self.iconView];
    self.iconView.layer.cornerRadius = 25;
    self.iconView.layer.masksToBounds = YES;
    
    UILabel *usernameLabel = [[UILabel alloc] init];
    self.usernameLabel = usernameLabel;
    [self.contentView addSubview:self.usernameLabel];
    self.usernameLabel.font = usernameFont;
    self.usernameLabel.textColor = [UIColor blackColor];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    self.contentLabel = contentLabel;
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.font = contentFont;
    self.contentLabel.textColor = [UIColor grayColor];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    self.dateLabel = dateLabel;
    [self.contentView addSubview:self.dateLabel];
    self.dateLabel.font = dateFont;
    self.dateLabel.textColor = [UIColor grayColor];
    
    UIView *separatorLine = [[UIView alloc] init];
    self.separatorLine = separatorLine;
    [self.contentView addSubview:self.separatorLine];
    self.separatorLine.backgroundColor = [UIColor lightGrayColor];
    
    return self;
}

- (void)setCommentFrame:(CommentFrame *)commentFrame {
    _commentFrame = commentFrame;
    Comment *comment = commentFrame.comment;
    
    self.iconView.frame = commentFrame.iconFrame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.userPhoto]];
    
    self.usernameLabel.frame = commentFrame.usernameFrame;
    self.usernameLabel.text = comment.username;
    
    self.contentLabel.frame = commentFrame.contentFrame;
    self.contentLabel.text = comment.comment_content;
    
    self.dateLabel.frame = commentFrame.dateFrame;
    self.dateLabel.text = comment.comment_date;
    
    self.separatorLine.frame = commentFrame.separatorFrame;
}

@end
