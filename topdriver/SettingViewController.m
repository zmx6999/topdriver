//
//  SettingViewController.m
//  topdriver
//
//  Created by zmx on 16/2/2.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *titles;

@end

@implementation SettingViewController

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = @[@[@"移动网络不下载视频"], @[@"去好评", @"去吐槽"], @[@"清除缓存", [NSString stringWithFormat:@"版本号:%@", Version]]];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)showView {
    [self.tableView reloadData];
}

- (long long)fetchCacheSize {
    long long size = 0;
    NSArray *paths = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    for (NSString *path in paths) {
        size += [[[NSFileManager defaultManager] attributesOfItemAtPath:[cachePath stringByAppendingPathComponent:path] error:nil] fileSize];
    }
    return size;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [[self.titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        long long cacheSize = [self fetchCacheSize];
        NSString *cacheStr = nil;
        if (cacheSize < 1024 * 1024) {
            cacheStr = [NSString stringWithFormat:@"%.1fKb", cacheSize / 1024.0];
        } else {
            cacheStr = [NSString stringWithFormat:@"%.1fMb", cacheSize / 1024.0 / 1024];
        }
        cell.detailTextLabel.text = cacheStr;
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    if (indexPath.section == 0) {
        UISwitch *swi = [[UISwitch alloc] init];
        swi.onTintColor = [UIColor orangeColor];
        cell.accessoryView = swi;
    } else if (indexPath.section == 1 || (indexPath.section == 2 && indexPath.row == 0)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清理缓存" message:@"根据缓存文件的大小，清理时间从几秒到几分钟不等，请耐心等待" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
        [alertView show];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footer = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 220, 30)];
        label.text = @"仅Wi-Fi下可用，自动下载最新内容";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        [footer addSubview:label];
        return footer;
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section > 0 ?20 : 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%@", cachePath);
    if (buttonIndex == 1) {
        NSArray *paths = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        for (NSString *path in paths) {
            [[NSFileManager defaultManager] removeItemAtPath:[cachePath stringByAppendingPathComponent:path] error:nil];
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
