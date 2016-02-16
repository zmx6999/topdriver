//
//  LoginViewController.m
//  topdriver
//
//  Created by zmx on 16/2/2.
//  Copyright © 2016年 zmx. All rights reserved.
//

//http://adm.topdriverclub.com/iphone/api/user/get?token=34F5AD08B574DF132BCAC01312C40B47&v=1.1.4

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@end

@implementation LoginViewController

- (IBAction)loginByWeibo:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSDictionary *dict = [response.data objectForKey:@"sina"];
            NSDictionary *params = @{
                                     @"v": Version,
                                     @"sex": [dict objectForKey:@"gender"],
                                     @"logintoken": [dict objectForKey:@"usid"],
                                     @"name": [dict objectForKey:@"username"],
                                     @"head": [dict objectForKey:@"icon"],
                                     @"thirdparty": @"wb",
                                     @"deviceid": @""
                                     };
            [SharedNetworkTool GET:@"http://adm.topdriverclub.com/iphone/api/user/thirdpartylogin" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *token = [[responseObject objectForKey:@"result"] objectForKey:@"token"];
                NSDictionary *params = @{
                                         @"v": Version,
                                         @"token": token
                                         };
                [SharedNetworkTool GET:@"http://adm.topdriverclub.com/iphone/api/user/get" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [SharedUser setValuesForKeysWithDictionary:[responseObject objectForKey:@"result"]];
                    SharedUser.isLogin = YES;
                    SharedUser.token = token;
                    [SharedUser saveAccount];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@", error);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];
        }
    });
}

- (IBAction)loginByWechat:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSLog(@"%@", response.data);
            
        }
        
    });
}

- (IBAction)forget:(id)sender {
    [self.navigationController pushViewController:[[ForgetViewController alloc] init] animated:YES];
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)login:(id)sender {
    if (self.phoneText.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    
    NSString *pattern = @"^1[3|5|7|8][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL valid = [predicate evaluateWithObject:self.phoneText.text];
    if (!valid) {
        [SVProgressHUD showErrorWithStatus:@"手机号码非法"];
        return;
    }
    
    [SVProgressHUD show];
    NSDictionary *params = @{@"v": Version, @"name": self.phoneText.text, @"password": self.pwdText.text, @"deviceid": @"", @"type": @"ios"};
    [SharedNetworkTool GET:@"iphone/api/user/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] > 0) {
            
            NSString *token = [[responseObject objectForKey:@"result"] objectForKey:@"token"];
            NSDictionary *params = @{@"token": token, @"v": Version};
            [SharedNetworkTool GET:@"http://adm.topdriverclub.com/iphone/api/user/get" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([[responseObject objectForKey:@"success"] intValue] > 0) {
                    [SharedUser setValuesForKeysWithDictionary:[responseObject objectForKey:@"result"]];
                    SharedUser.isLogin = YES;
                    SharedUser.token = token;
                    [SharedUser saveAccount];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"账号不存在或密码错误"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

- (IBAction)reg:(id)sender {
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:NO];
}

- (void)passwordDidChange:(NSNotification *)notification {
    self.phoneText.text = notification.userInfo[@"phone"];
    self.pwdText.text = notification.userInfo[@"pwd"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordDidChange:) name:PasswordDidChangeNotification object:nil];
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