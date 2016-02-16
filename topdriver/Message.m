//
//  News.m
//  topdriver
//
//  Created by zmx on 16/1/29.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "Message.h"

@implementation Message

- (NSString *)cachePlistContent {
    NSRange range = [self.plist_content rangeOfString:self.post_id];
    NSRange range2 = [self.plist_content rangeOfString:@".zip"];
    NSInteger len = range2.location - range.location;
    return [cachePath stringByAppendingPathComponent:[[self.plist_content substringWithRange:NSMakeRange(range.location, len)] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
}

+ (instancetype)messageWithDict:(NSDictionary *)dict {
    Message *message = [[self alloc] init];
    [message setValuesForKeysWithDictionary:dict];
    return message;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"visited"]) {
        self.visited = NO;
    }
    if ([key isEqualToString:@"praised"]) {
        self.praised = NO;
    }
}

@end