//
//  NewPasswordViewController.m
//  topdriver
//
//  Created by zmx on 16/2/3.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "NewPasswordViewController.h"

@interface NewPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@property (weak, nonatomic) IBOutlet UITextField *ensurePwdText;

@end

@implementation NewPasswordViewController

- (void)modify {
    if (self.pwdText.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    
    if (![self.ensurePwdText.text isEqualToString:self.pwdText.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary *params = @{@"v": Version, @"phone": SharedUser.phone, @"pwd": self.pwdText.text};
    [SharedNetworkTool GET:@"http://adm.topdriverclub.com/iphone/api/user/resetpwd" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] intValue] > 0) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功，请重新登录"];
            NSArray *controllers = self.navigationController.viewControllers;
            UIViewController *controller = controllers[controllers.count - 3];
            [self.navigationController popToViewController:controller animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:PasswordDidChangeNotification object:nil userInfo:@{@"phone": SharedUser.phone, @"pwd": self.pwdText.text}];
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(modify)];
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
