//
//  MessageViewController.m
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "NotifyViewController.h"
#import "Notify.h"
#import "NotifyCell.h"
#import "WebViewController.h"
#import "Request.h"
#import "ZMXRefreshView.h"

static NSString *ID = @"notify";

@interface NotifyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) ZMXRefreshView *refreshView;

@property (nonatomic, weak) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSArray *notifies;

@property (nonatomic, assign) BOOL loaded;

@end

@implementation NotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"NotifyCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.rowHeight = 183;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    self.indicator = indicator;
    self.tableView.tableFooterView = self.indicator;
    
    [self addRefreshView];
}

- (void)showView {
    self.loaded = NO;
    [self loadCacheData];
    [self.refreshView beginRefreshing];
}

- (void)addRefreshView {
    ZMXRefreshView *refreshView = [ZMXRefreshView refreshView];
    self.refreshView = refreshView;
    self.refreshView.scrollView = self.tableView;
    [self.refreshView setRefreshBegin:^{
        [self loadNewData];
    }];
}

- (void)loadCacheData {
    self.notifies = [SharedCacheTool fetchNotifies];
    [self.tableView reloadData];
}

- (void)loadNewData {
    [Request loadNewDataWithUrl:@"iphone/api/content/getNotify" completionHandler:^(NSArray * arr) {
        [self.refreshView endRefreshing:YES];
        
        if (arr) {
            if (!self.loaded) {
                [SharedCacheTool clearNotifies];
                self.notifies = nil;
                self.loaded = YES;
            }
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                Notify *notify = [Notify notifyWithDict:dict];
                notify.visited = [userDefaults boolForKey:[notify.notify_id stringByAppendingString:@"_notify_visited"]];
                if (notify.notify_id.integerValue <= [self.notifies.firstObject notify_id].integerValue) {
                    break;
                }
                [arrM addObject:notify];
                [SharedCacheTool insertNotify:notify];
            }
            [arrM addObjectsFromArray:self.notifies];
            self.notifies = arrM;
            
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    }];
}

- (void)loadMoreData {
    [Request loadMoreDataWithUrl:@"iphone/api/content/getNotify" page:self.notifies.count / 10 completionHandler:^(NSArray *arr) {
        if (arr) {
            NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.notifies];
            for (NSDictionary *dict in arr) {
                Notify *notify = [Notify notifyWithDict:dict];
                notify.visited = [userDefaults boolForKey:[notify.notify_id stringByAppendingString:@"_notify_visited"]];
                if (notify.notify_id.integerValue >= [self.notifies.lastObject notify_id].integerValue) {
                    continue;
                }
                [arrM addObject:notify];
                [SharedCacheTool insertNotify:notify];
            }
            self.notifies = arrM;
            [self.tableView reloadData];
            if (self.indicator.isAnimating) {
                [self.indicator stopAnimating];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.notify = self.notifies[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *wvc = [[WebViewController alloc] init];
    Notify *notify = self.notifies[indexPath.row];
    
    [userDefaults setBool:YES forKey:[notify.notify_id stringByAppendingString:@"_notify_visited"]];
    [userDefaults synchronize];
    notify.visited = YES;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    wvc.urlStr = notify.notify_url;
    self.detail(wvc);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.h) {
        if (!self.indicator.isAnimating) {
            [self.indicator startAnimating];
            [self loadMoreData];
        }
    }
}

@end
