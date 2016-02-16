//
//  CacheTool.m
//  topdriver
//
//  Created by zmx on 16/2/4.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "CacheTool.h"
#import "Message.h"
#import "Notify.h"

static CacheTool *instance;

@interface CacheTool ()

@property (nonatomic, copy) NSString *path;

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation CacheTool

- (NSString *)path {
    if (_path == nil) {
        _path = [cachePath stringByAppendingPathComponent:@"db_cache.sqlite"];
    }
    return _path;
}

- (FMDatabaseQueue *)queue {
    if (_queue == nil) {
        _queue = [[FMDatabaseQueue alloc] initWithPath:self.path];
        [_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"create table if not exists t_message (id integer primary key autoincrement, message blob)"];
            [db executeUpdate:@"create table if not exists t_notify (id integer primary key autoincrement, notify blob)"];
        }];
    }
    return _queue;
}

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
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

- (void)insertMessage:(Message *)message {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"insert into t_message(message) values(?)", [NSKeyedArchiver archivedDataWithRootObject:message]];
    }];
}

- (NSArray *)fetchMessages {
    NSMutableArray *arrM = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select message from t_message"];
        while (rs.next) {
            Message *message = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"message"]];
            message.visited = [userDefaults boolForKey:[message.post_id stringByAppendingString:@"_visited"]];
            message.praised = [userDefaults boolForKey:[message.post_id stringByAppendingString:@"_praised"]];
            [arrM addObject:message];
        }
    }];
    [arrM sortedArrayUsingComparator:^NSComparisonResult(Message *message1, Message *message2) {
        return message1.post_id.integerValue > message2.post_id.integerValue;
    }];
    return arrM;
}

- (void)clearMessages {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_message"];
    }];
}

- (void)insertNotify:(Notify *)notify {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"insert into t_notify(notify) values(?)", [NSKeyedArchiver archivedDataWithRootObject:notify]];
    }];
}

- (NSArray *)fetchNotifies {
    NSMutableArray *arrM = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select notify from t_notify"];
        while (rs.next) {
            Notify *notify = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"notify"]];
            notify.visited = [userDefaults boolForKey:[notify.notify_id stringByAppendingString:@"_notify_visited"]];
            [arrM addObject:notify];
        }
    }];
    [arrM sortedArrayUsingComparator:^NSComparisonResult(Notify *notify1, Notify *notify2) {
        return notify1.notify_id.integerValue > notify2.notify_id.integerValue;
    }];
    return arrM;
}

- (void)clearNotifies {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_notify"];
    }];
}

@end