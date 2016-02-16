//
//  User.h
//  topdriver
//
//  Created by zmx on 16/2/2.
//  Copyright © 2016年 zmx. All rights reserved.
//

@interface User : ZMXObject

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *weixin;

@property (nonatomic, copy) NSString *weibo;

@property (nonatomic, copy) NSString *userPhoto;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)sharedUser;

+ (instancetype)account;

- (void)saveAccount;

- (void)logout;

@end
