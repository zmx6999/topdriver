//
//  UserInfoViewController.m
//  topdriver
//
//  Created by zmx on 16/2/3.
//  Copyright © 2016年 zmx. All rights reserved.
//

//http://adm.topdriverclub.com/iphone/api/user/setuserinfo

#import "UserInfoViewController.h"
#import "ModifyNicknameViewController.h"
#import "ModifySexViewController.h"

@interface UserInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userPhotoView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneKeyLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation UserInfoViewController

- (IBAction)modifyNickname:(id)sender {
    ModifyNicknameViewController *nvc = [[ModifyNicknameViewController alloc] init];
    nvc.nickname = self.nicknameLabel.text;
    [self.navigationController pushViewController:nvc animated:YES];
}

- (IBAction)modifySex:(id)sender {
    ModifySexViewController *svc = [[ModifySexViewController alloc] init];
    svc.sex = self.sexLabel.text;
    [self.navigationController pushViewController:svc animated:YES];
}

- (IBAction)logout:(id)sender {
    [SharedUser logout];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finish {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.heightConstraint.constant = SharedUser.weibo || SharedUser.weixin ?80 : 120;
    
    self.title = @"我的档案";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    
    self.userPhotoView.layer.cornerRadius = 40;
    self.userPhotoView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.userPhotoView sd_setImageWithURL:[NSURL URLWithString:SharedUser.userPhoto] placeholderImage:[UIImage imageNamed:@"icon_default_user"]];
    self.nicknameLabel.text = SharedUser.name ? : SharedUser.phone;
    self.sexLabel.text = [SharedUser.sex intValue] ? @"男" : @"女";
    self.phoneKeyLabel.hidden = SharedUser.weibo || SharedUser.weixin;
    self.phoneLabel.text = SharedUser.phone;
    
    self.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
