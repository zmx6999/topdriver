//
//  UserView.m
//  topdriver
//
//  Created by zmx on 16/2/3.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "UserView.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"

@interface UserView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UserView

- (IBAction)login:(UITapGestureRecognizer *)sender {
    if (SharedUser.isLogin) {
        [[self getViewController] presentViewController:[[UINavigationController alloc] initWithRootViewController:[[UserInfoViewController alloc] init]] animated:YES completion:nil];
    } else {
        [[self getViewController].navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
}

- (void)awakeFromNib {
    self.iconView.layer.cornerRadius = 50;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setUserLogin:(BOOL)userLogin {
    _userLogin = userLogin;
    
    if (userLogin) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:SharedUser.userPhoto] placeholderImage:[UIImage imageNamed:@"icon_default_user"]];
        self.titleLabel.text = SharedUser.name;
    } else {
        self.iconView.image = [UIImage imageNamed:@"icon_default_user"];
        self.titleLabel.text = @"登录或注册";
    }
}

@end
