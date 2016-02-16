//
//  ModifyNicknameViewController.m
//  topdriver
//
//  Created by zmx on 16/2/3.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ModifyNicknameViewController.h"

@interface ModifyNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nicknameText;

@end

@implementation ModifyNicknameViewController

- (void)modify {
    [SVProgressHUD show];
    NSDictionary *params = @{@"token": SharedUser.token, @"v": Version, @"type": @"1", @"info": self.nicknameText.text};
    [SharedNetworkTool POST:@"http://adm.topdriverclub.com/iphone/api/user/setuserinfo" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] intValue] > 0) {
            SharedUser.name = self.nicknameText.text;
            [SharedUser saveAccount];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(modify)];
    
    self.nicknameText.text = self.nickname;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
