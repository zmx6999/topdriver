//
//  ZMXRefreshView.m
//  microblog
//
//  Created by zmx on 16/1/28.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ZMXRefreshView.h"

#define ScrollViewContentOffset @"contentOffset"
#define UserDefaults [NSUserDefaults standardUserDefaults]

@interface ZMXRefreshView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterConstarint;

@property (nonatomic, copy) NSString *beginPullText;

@property (nonatomic, copy) NSString *willRefreshText;

@property (nonatomic, copy) NSString *refreshingText;

@property (nonatomic, assign) RefreshState state;

@end

@implementation ZMXRefreshView

+ (instancetype)refreshView {
    return [self refreshViewWithBeginPullText:@"下拉刷新" willRefreshText:@"松开手立刻刷新" refreshingText:@"哥正在帮您刷新中"];
}

+ (instancetype)refreshViewWithBeginPullText:(NSString *)beginPullText willRefreshText:(NSString *)willRefreshText refreshingText:(NSString *)refreshingText {
    ZMXRefreshView *refreshView = [[[NSBundle mainBundle] loadNibNamed:@"ZMXRefreshView" owner:nil options:nil] firstObject];
    refreshView.beginPullText = beginPullText;
    refreshView.willRefreshText = willRefreshText;
    refreshView.refreshingText = refreshingText;
    return refreshView;
}

- (void)setState:(RefreshState)state {
    _state = state;
    
    switch (state) {
        case RefreshStateNormal: {
            if (self.indicatorView.isAnimating) {
                [self.indicatorView stopAnimating];
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            break;
        }
            
        case RefreshStateBeginPull: {
            self.titleLabel.text = self.beginPullText;
            self.timeLabel.hidden = YES;
            self.indicatorView.hidden = YES;
            self.titleCenterConstarint.constant = 0;
            break;
        }
            
        case RefreshStateWillRefresh: {
            self.titleLabel.text = self.willRefreshText;
            self.timeLabel.hidden = YES;
            self.indicatorView.hidden = YES;
            self.titleCenterConstarint.constant = 0;
            break;
        }
            
        case RefreshStateRefreshing: {
            self.titleLabel.text = self.refreshingText;
            
            NSString *lastUpdate = [UserDefaults objectForKey:[NSString stringWithFormat:@"%ldLastUpdate", self.tag]];
            if (lastUpdate) {
                self.timeLabel.hidden = NO;
                self.timeLabel.text = [NSString stringWithFormat:@"最后更新：%@", lastUpdate];                
                self.titleCenterConstarint.constant = -10;
            } else {
                self.timeLabel.hidden = YES;
                self.titleCenterConstarint.constant = 0;
            }
            
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
            
            self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            
            if (self.refreshBegin) {
                self.refreshBegin();
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    
    [scrollView addSubview:self];
    self.frame = CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64);
    [scrollView addObserver:self forKeyPath:ScrollViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:ScrollViewContentOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ScrollViewContentOffset]) {
        CGFloat dy = self.scrollView.contentOffset.y;
        if (self.state != RefreshStateRefreshing) {
            if (dy >= 0) {
                self.state = RefreshStateNormal;
            } else if (dy < 0 && dy >= -64) {
                self.state = RefreshStateBeginPull;
            } else if (self.scrollView.isDragging) {
                self.state = RefreshStateWillRefresh;
            } else {
                self.state = RefreshStateRefreshing;
            }
        }
    }
}

- (void)beginRefreshing {
    if (self.state != RefreshStateRefreshing) {
        self.state = RefreshStateRefreshing;
    }
}

- (void)endRefreshing:(BOOL)success {
    if (self.state == RefreshStateRefreshing) {
        self.state = RefreshStateNormal;
        if (success) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            [UserDefaults setObject:[formatter stringFromDate:[NSDate date]] forKey:[NSString stringWithFormat:@"%ldLastUpdate", self.tag]];
            [UserDefaults synchronize];
        }
    }
}

@end