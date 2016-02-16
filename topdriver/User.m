//
//  User.m
//  topdriver
//
//  Created by zmx on 16/2/2.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "User.h"

static User *instance;

@interface User ()

@end

@implementation User
+ (instancetype)sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self account];
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (instancetype)account {
    NSString *path = [cachePath stringByAppendingPathComponent:@"account.plist"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)saveAccount {
    NSString *path = [cachePath stringByAppendingPathComponent:@"account.plist"];
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

- (void)logout {
    NSArray *properties = [self getProperties];
    for (NSString *property in properties) {
        if ([property isEqualToString:@"isLogin"]) {
            self.isLogin = NO;
        } else {
            [self setValue:nil forKey:property];
        }
    }
    [self saveAccount];
}

@end
