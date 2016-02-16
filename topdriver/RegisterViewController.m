//
//  RegisterViewController.m
//  topdriver
//
//  Created by zmx on 16/2/6.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@property (weak, nonatomic) IBOutlet UITextField *ensureText;

@end

@implementation RegisterViewController

- (IBAction)sendEnsure:(id)sender {
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
    
    [SVProgressHUD showWithStatus:@"正在发送验证码"];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneText.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                         [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
                                         SharedUser.phone = self.phoneText.text;
                                     } else {
                                         [SVProgressHUD showErrorWithStatus:@"验证码发送失败"];
                                     }
                                 }];
}

- (IBAction)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)reg:(id)sender {
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
    
    [SMSSDK commitVerificationCode:self.ensureText.text phoneNumber:self.phoneText.text zone:@"86" result:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            return;
        }
        
        if (self.pwdText.text.length < 1) {
            [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
            return;
        }
    }];
}

- (IBAction)login:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
