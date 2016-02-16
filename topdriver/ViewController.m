//
//  ViewController.m
//  topdriver
//
//  Created by zmx on 16/1/29.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "DetailViewController.h"
#import "NotifyViewController.h"
#import "HomeBottomButton.h"
#import "SettingViewController.h"
#import "UserView.h"
#import "UserInfoViewController.h"
#import "ZMXRefreshView.h"
#import "Request.h"

static NSString *ID = @"message";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, HomeBottomButtonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;

@property (weak, nonatomic) IBOutlet HomeBottomButton *homeButton;

@property (weak, nonatomic) IBOutlet HomeBottomButton *userButton;

@property (weak, nonatomic) IBOutlet HomeBottomButton *messageButton;

@property (weak, nonatomic) IBOutlet HomeBottomButton *settingButton;

@property (weak, nonatomic) IBOutlet HomeBottomButton *favoriteButton;

@property (nonatomic, weak) HomeBottomButton *selectedButton;

@property (nonatomic, weak) ZMXRefreshView *refreshView;

@property (nonatomic, weak) UIActivityIndicatorView *indicator;

@property (nonatomic, weak) UIView *maskView;

@property (nonatomic, assign) BOOL loaded;

@property (nonatomic, strong) NSArray *messages;

@property (nonatomic, strong) NSArray *histories;

@end

@implementation ViewController

- (IBAction)click:(HomeBottomButton *)sender {
    if (self.selectedButton != sender) {
        self.selectedButton.selected = NO;
        sender.selected = YES;
        self.selectedButton = sender;
    } else {
        if (sender.tag != 1) {
            sender.selected = NO;
            self.homeButton.selected = YES;
            self.selectedButton = self.homeButton;
        }
    }
}

- (void)onTap:(UITapGestureRecognizer *)tap {
    [self click:self.userButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView .rowHeight = 368;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    self.indicator = indicator;
    self.tableView.tableFooterView = self.indicator;
    
    self.selectedButton = self.homeButton;
    
    [self addBottomButtonDelegate];
    [self addControllerView];
    
    [self loadCacheData];
    [self addRefreshView];
}

- (void)addRefreshView {
    ZMXRefreshView *refreshView = [ZMXRefreshView refreshView];
    self.refreshView = refreshView;
    self.refreshView.scrollView = self.tableView;
    [self.refreshView setRefreshBegin:^{
        [self loadNewData];
    }];
    [self.refreshView beginRefreshing];
}

- (void)addBottomButtonDelegate {
    self.homeButton.delegate = self;
    self.userButton.delegate = self;
    self.messageButton.delegate = self;
    self.settingButton.delegate = self;
    self.favoriteButton.delegate = self;
}

- (void)addControllerView {
    UserView *userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:nil options:nil] firstObject];
    [self.view insertSubview:userView belowSubview:self.bottomBar];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.userButton.constraint = make.top.equalTo(self.tableView).offset(ScreenHeight);
        make.left.width.equalTo(self.tableView);
        make.height.mas_equalTo(160);
    }];
    self.userButton.view = userView;
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    [self.view insertSubview:maskView belowSubview:userView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self.tableView);
    }];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
    self.maskView = maskView;
    
    NotifyViewController *nvc = [[NotifyViewController alloc] init];
    [nvc setDetail:^(UIViewController *controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [self.view insertSubview:nvc.view belowSubview:self.bottomBar];
    [nvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        self.messageButton.constraint = make.top.equalTo(self.tableView.mas_top).offset(ScreenHeight);
        make.left.width.height.equalTo(self.tableView);
    }];
    self.messageButton.view = nvc.view;
    self.messageButton.controller = nvc;
    
    SettingViewController *svc = [[SettingViewController alloc] init];
    [self.view insertSubview:svc.view belowSubview:self.bottomBar];
    [svc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        self.settingButton.constraint = make.top.equalTo(self.tableView).offset(ScreenHeight);
        make.left.width.height.equalTo(self.tableView);
    }];
    self.settingButton.view = svc.view;
    self.settingButton.controller = svc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(UserView *)self.userButton.view setUserLogin:SharedUser.isLogin];
}

- (void)loadCacheData {
    self.messages = [SharedCacheTool fetchMessages];
    [self.tableView reloadData];
}

- (void)loadNewData {
    [Request loadNewDataWithUrl:@"iphone/api/content/blocklist" completionHandler:^(NSArray * arr) {
        [self.refreshView endRefreshing:YES];
        
        if (arr) {
            if (!self.loaded) {
                [SharedCacheTool clearMessages];
                self.messages = nil;
                self.loaded = YES;
            }
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *articleDict in arr) {
                NSDictionary *dict = [articleDict[@"articles"] firstObject];
                Message *message = [Message messageWithDict:dict];
                message.visited = [userDefaults boolForKey:[message.post_id stringByAppendingString:@"_visited"]];
                message.praised = [userDefaults boolForKey:[message.post_id stringByAppendingString:@"_praised"]];
                if (message.post_id.integerValue <= [self.messages.firstObject post_id].integerValue) {
                    break;
                }
                [arrM addObject:message];
                [SharedCacheTool insertMessage:message];
            }
            [arrM addObjectsFromArray:self.messages];
            self.messages = arrM;
            
            [self.tableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    }];
}

- (void)loadMoreData {
    [Request loadMoreDataWithUrl:@"iphone/api/content/blocklist" page:self.messages.count / 10 completionHandler:^(NSArray *arr) {
        if (arr) {
            NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.messages];
            for (NSDictionary *articleDict in arr) {
                NSDictionary *dict = [articleDict[@"articles"] firstObject];
                Message *message = [Message messageWithDict:dict];
                message.visited = [userDefaults boolForKey:[message.post_id stringByAppendingString:@"_visited"]];
                message.praised = [userDefaults boolForKey:[message.post_id stringByAppendingString:@"_praised"]];
                if (message.post_id.integerValue >= [self.messages.lastObject post_id].integerValue) {
                    continue;
                }
                [arrM addObject:message];
                [SharedCacheTool insertMessage:message];
            }
            self.messages = arrM;
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
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.message = self.messages[indexPath.row];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.h) {
        if (!self.indicator.isAnimating) {
            [self.indicator startAnimating];
            [self loadMoreData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dvc = [[DetailViewController alloc] init];
    Message *message = self.messages[indexPath.row];
    dvc.message = message;
    
    message.visited = YES;
    [userDefaults setBool:YES forKey:[message.post_id stringByAppendingString:@"_visited"]];
    [userDefaults synchronize];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)homeBottomButtonDidChangeState:(HomeBottomButton *)homeBottomButton {
    switch (homeBottomButton.tag) {
        case 2: {
            [UIView animateWithDuration:0.5 animations:^{
                self.maskView.alpha = homeBottomButton.selected ? 0.5 : 0;
                
                [homeBottomButton.constraint uninstall];
                [homeBottomButton.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (homeBottomButton.selected) {
                        homeBottomButton.constraint = make.top.equalTo(self.tableView.mas_top).offset(ScreenHeight - 209);
                    } else {
                        homeBottomButton.constraint = make.top.equalTo(self.tableView.mas_top).offset(ScreenHeight);
                    }
                }];
                [self.view layoutIfNeeded];
            }];
            break;
        }
            
        case 3:
        case 4: {
            [UIView animateWithDuration:1.0 animations:^{
                [homeBottomButton.constraint uninstall];
                [homeBottomButton.view mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (homeBottomButton.selected) {
                        homeBottomButton.constraint = make.top.equalTo(self.view.mas_top);
                        [homeBottomButton.controller showView];
                    } else {
                        homeBottomButton.constraint = make.top.equalTo(self.view.mas_top).offset(ScreenHeight);
                    }
                }];
                [self.view layoutIfNeeded];
            }];
            break;
        }
            
        default:
            break;
    }
}

@end