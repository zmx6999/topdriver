//
//  ModifySexViewController.m
//  topdriver
//
//  Created by zmx on 16/2/3.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ModifySexViewController.h"

@interface ModifySexViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *femaleCheck;

@property (weak, nonatomic) IBOutlet UIImageView *maleCheck;

@end

@implementation ModifySexViewController

- (IBAction)selectFemale:(id)sender {
    self.femaleCheck.hidden = NO;
    self.maleCheck.hidden = YES;
}

- (IBAction)selectMale:(id)sender {
    self.femaleCheck.hidden = YES;
    self.maleCheck.hidden = NO;
}

- (void)modify {
    [SVProgressHUD show];
    NSString *sex = self.maleCheck.hidden ?@"0" : @"1";
    NSDictionary *params = @{@"token": SharedUser.token, @"v": Version, @"type": @"2", @"info": sex};
    [SharedNetworkTool POST:@"http://adm.topdriverclub.com/iphone/api/user/setuserinfo" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] intValue] > 0) {
            SharedUser.sex = sex;
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
    self.title = @"性别";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(modify)];
    
    if ([self.sex isEqualToString:@"男"]) {
        self.femaleCheck.hidden = YES;
        self.maleCheck.hidden = NO;
    } else {
        self.femaleCheck.hidden = NO;
        self.maleCheck.hidden = YES;
    }
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
