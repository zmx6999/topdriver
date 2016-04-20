//
//  DownloadViewController.m
//  topdriver
//
//  Created by zmx on 16/1/30.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "DetailViewController.h"
#import "Message.h"
#import "ProgressView.h"
#import "DetailIndex.h"
#import "DetailImageIndex.h"
#import "WebViewController.h"
#import "Comment.h"
#import "CommentFrame.h"
#import "CommentCell.h"
#import "Request.h"
#import "ShareView.h"

#define ContentOffset @"contentOffset"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate, ShareViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet ZMXButton *praiseButton;

@property (nonatomic, weak) UILabel *praiseLabel;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic, strong) MASConstraint *constraint;

@property (nonatomic, weak) UIScrollView *rollView;

@property (nonatomic, weak) ShareView *shareView;

@property (nonatomic, weak) UIView *maskView;

@property (nonatomic, strong) MASConstraint *shareViewTop;

@property (nonatomic, assign) CGFloat imagesHeight;

@property (nonatomic, assign) CGFloat tableHeight;

@property (nonatomic, strong) NSDictionary *rootDict;

@property (nonatomic, strong) NSArray *indexes;

@property (nonatomic, copy) NSString *contentBase;

@property (nonatomic, copy) NSString *contentBaseExt;

@property (nonatomic, copy) NSString *shareIcon;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, copy) NSString *shareLink;

@property (nonatomic, strong) NSArray *commentFrames;

@end

@implementation DetailViewController

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)praise:(id)sender {
    self.praiseButton.userInteractionEnabled = NO;
    NSDictionary *params = @{@"v": Version, @"post_id": self.message.post_id};
    [SharedNetworkTool GET:@"iphone/api/content/postPraise" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] integerValue] > 0) {
            self.praiseButton.selected = YES;
            self.praiseLabel.textColor = [UIColor orangeColor];
            
            self.message.praise_cnt = [NSString stringWithFormat:@"%ld", [self.message.praise_cnt integerValue] + 1];
            self.praiseLabel.text = self.message.praise_cnt;
            
            self.message.praised = YES;
            [userDefaults setBool:YES forKey:[self.message.post_id stringByAppendingString:@"_praised"]];
            [userDefaults synchronize];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            self.praiseButton.userInteractionEnabled = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        self.praiseButton.userInteractionEnabled = YES;
    }];
}

- (IBAction)share:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 0.5;
        
        [self.shareViewTop uninstall];
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.shareViewTop = make.top.equalTo(self.scrollView).offset(ScreenHeight - 260);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)watchVideo:(UIButton *)btn {
    WebViewController *wvc = [[WebViewController alloc] init];
    wvc.urlStr = [self.indexes[btn.tag] link_url];
    wvc.title = @"TopDriver";
    wvc.navigationItem.backBarButtonItem.title = @"";
    [self.navigationController pushViewController:wvc animated:YES];
}

- (NSDictionary *)rootDict {
    if (_rootDict == nil) {
        _rootDict = [[[NSDictionary dictionaryWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:@"config.plist"]] objectForKey:@"children"] firstObject];
    }
    return _rootDict;
}

- (NSArray *)indexes {
    if (_indexes == nil) {
        NSArray *indexes = [self.rootDict objectForKey:@"children"];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in indexes) {
            DetailIndex *index = [DetailIndex indexWithDict:dict];
            [arrM addObject:index];
        }
        _indexes = arrM;
    }
    return _indexes;
}

- (NSString *)contentBase {
    if (_contentBase == nil) {
        _contentBase = [self.rootDict objectForKey:@"content_base"];
    }
    return _contentBase;
}

- (NSString *)contentBaseExt {
    if (_contentBaseExt == nil) {
        _contentBaseExt = [self.rootDict objectForKey:@"content_base_ext"];
    }
    return _contentBaseExt;
}

- (NSString *)shareIcon {
    if (_shareIcon == nil) {
        _shareIcon = [[NSDictionary dictionaryWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:@"config.plist"]] objectForKey:@"icon"];
    }
    return _shareIcon;
}

- (NSString *)shareTitle {
    if (_shareTitle == nil) {
        _shareTitle = [[NSDictionary dictionaryWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:@"config.plist"]] objectForKey:@"title"];
    }
    return _shareTitle;
}

- (NSString *)shareLink {
    if (_shareLink == nil) {
        _shareLink = [[NSDictionary dictionaryWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:@"config.plist"]] objectForKey:@"link"];
    }
    return _shareLink;
}

- (NSArray *)imageViews {
    if (_imageViews == nil) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.progressView.hidden = NO;
    self.praiseButton.selected = self.message.praised;
    self.praiseButton.userInteractionEnabled = !self.message.praised;
    [self addPraiseLabel];
    [self download];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.praiseLabel.frame = CGRectMake(self.praiseButton.x + self.praiseButton.w, self.praiseButton.y - 10, 30, 20);
}

- (void)addPraiseLabel {
    UILabel *praiseLabel = [[UILabel alloc] init];
    self.praiseLabel = praiseLabel;
    self.praiseLabel.text = self.message.praise_cnt;
    self.praiseLabel.font = [UIFont systemFontOfSize:10];
    self.praiseLabel.textColor = self.message.praised ?[UIColor orangeColor] : [UIColor grayColor];
    [self.toolbar addSubview:self.praiseLabel];
}

- (void)download {
   [[SharedDownloadTool downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BaseURLStr, self.message.plist_content]]] progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = downloadProgress.completedUnitCount * 100 / downloadProgress.totalUnitCount;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [[NSURL fileURLWithPath:cachePath] URLByAppendingPathComponent:response.suggestedFilename];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *path = filePath.absoluteString;
        NSRange range = [path rangeOfString:@"file://"];
        path = [path substringFromIndex:range.location + range.length];
        [SSZipArchive unzipFileAtPath:path toDestination:self.message.cachePlistContent];
            
        [fileManager removeItemAtPath:path error:nil];
            
        self.progressView.hidden = YES;
            
        [self setupScrollView];
    }] resume];
}

- (void)fetchComments {
    [Request fetchCommentsWithMessage:self.message completionHandler:^(NSArray *comments) {
        NSMutableArray *arrM = [NSMutableArray array];
        if (comments && [comments respondsToSelector:@selector(count)]) {
            for (NSDictionary *dict in comments) {
                CommentFrame *commentFrame = [[CommentFrame alloc] init];
                commentFrame.comment = [Comment commentWithDict:dict];
                [arrM addObject:commentFrame];
            }
            self.commentFrames = arrM;
            [self resizeTableView];
            [self.tableView reloadData];
        }
    }];
}

- (void)resizeTableView {
    self.tableHeight = 70;
    for (int i = 0; i < self.commentFrames.count; i++) {
        self.tableHeight += [self.commentFrames[i] cellHeight];
    }
    
    [self.constraint uninstall];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, self.tableHeight));
    }];
    
    self.scrollView.contentSize = CGSizeMake(0, self.imagesHeight + self.tableHeight);
}

- (void)setupScrollView {
    [self setupImageView];
    [self.scrollView addObserver:self forKeyPath:ContentOffset options:NSKeyValueObservingOptionNew context:nil];

    if (self.imageViews.count > 0) {
        [self setupTableView];
        [self fetchComments];
    } else {
        [SVProgressHUD showErrorWithStatus:@"下载失败"];
    }
    
    self.scrollView.contentSize = CGSizeMake(0, self.imagesHeight + self.tableHeight);
    
    [self addShareView];
}

- (void)addShareView {
    ShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil] firstObject];
    self.shareView = shareView;
    self.shareView.shareIcon = [UIImage imageWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:self.shareIcon]];
    self.shareView.shareTitle = self.shareTitle;
    self.shareView.shareLink = self.shareLink;
    self.shareView.delegate = self;
    [self.view addSubview:self.shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.shareViewTop = make.top.equalTo(self.scrollView).offset(ScreenHeight);
        make.left.width.equalTo(self.tableView);
        make.height.mas_equalTo(260);
    }];
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    [self.view insertSubview:maskView belowSubview:self.shareView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self.scrollView);
    }];
    self.maskView = maskView;
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:ContentOffset];
}

- (void)setupImageView {
    int i = 0;
    while (YES) {
        NSString *path = [NSString stringWithFormat:@"%@-%d.%@", self.contentBase, i, self.contentBaseExt];
        path = [self.message.cachePlistContent stringByAppendingPathComponent:path];
        if (![fileManager fileExistsAtPath:path]) {
            break;
        }
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.imageViews.count > 0) {
                make.top.equalTo([self.imageViews.lastObject mas_bottom]);
            } else {
                make.top.equalTo(self.scrollView);
            }
            make.left.equalTo(self.scrollView);
            CGFloat h = ScreenWidth * image.size.height / image.size.width;
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, h));
            
            self.imagesHeight += h;
        }];
        
        [self.imageViews addObject:imageView];
        i++;
    }
    
    for (int i = 0; i < self.indexes.count; i++) {
        DetailIndex *index = self.indexes[i];
        if ([index.className isEqualToString:@"TDFadeImageView"]) {
            for (int j = 0; j < index.images.count; j++) {
                DetailImageIndex *imageIndex = index.images[j];
                UIImageView *iv = [[UIImageView alloc] init];
                iv.image = [UIImage imageWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:imageIndex.image]];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                iv.alpha = (i > 0);
                [self.scrollView addSubview:iv];
                [index.imageViews addObject:iv];
                
                [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.scrollView).offset(index.y + imageIndex.vPos.floatValue);
                    make.left.equalTo(self.scrollView).offset(index.x);
                    make.size.mas_equalTo(CGSizeMake(index.w, index.h));
                }];
            }
        } else if ([index.className isEqualToString:@"TDExternalView"]) {
            UIButton *btn = [[UIButton alloc] init];
            [self.scrollView addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(watchVideo:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView).offset(index.y);
                make.left.equalTo(self.scrollView).offset(index.x);
                make.size.mas_equalTo(CGSizeMake(index.w, index.h));
            }];
        } else if ([index.className isEqualToString:@"TDLinkedMovingView"]) {
            for (int j = 0; j < index.images.count; j++) {
                DetailImageIndex *imageIndex = index.images[j];
                UIImageView *iv = [[UIImageView alloc] init];
                iv.image = [UIImage imageWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:imageIndex.image]];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:iv];
                [index.imageViews addObject:iv];
                
                [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.scrollView).offset(index.y + imageIndex.vPos.floatValue);
                    make.left.equalTo(self.scrollView).offset(index.x);
                    make.size.mas_equalTo(CGSizeMake(index.w, index.h));
                }];
            }
            
            UIImageView *movingView = [[UIImageView alloc] init];
            movingView.image = [UIImage imageWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:index.linked_image]];
            movingView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:movingView];
            index.movingView = movingView;
            
            [movingView mas_makeConstraints:^(MASConstraintMaker *make) {
                index.movingViewTop = make.top.equalTo(self.scrollView).offset(-index.h);
                make.left.equalTo(self.scrollView).offset(index.x);
                make.size.mas_equalTo(CGSizeMake(index.w, index.h));
            }];
        } else if ([index.className isEqualToString:@"TDRollingView"]) {
            UIScrollView *rollView = [[UIScrollView alloc] init];
            self.rollView = rollView;
            [self.scrollView addSubview:self.rollView];
            self.rollView.showsHorizontalScrollIndicator = NO;
            
            [self.rollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView).offset(index.y);
                make.left.equalTo(self.scrollView).offset(index.x);
                make.size.mas_equalTo(CGSizeMake(index.w, index.h));
            }];
            
            for (int j = 0; j < index.images.count; j++) {
                UIImageView *iv = [[UIImageView alloc] init];
                iv.image = [UIImage imageWithContentsOfFile:[self.message.cachePlistContent stringByAppendingPathComponent:index.images[j]]];
                [self.rollView addSubview:iv];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                
                [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.rollView);
                    make.left.equalTo(self.rollView).offset((index.bw + index.rollMargin) * j);
                    make.size.mas_equalTo(CGSizeMake(index.bw, index.bh));
                }];
            }
        }
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.scrollView addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self.imageViews.lastObject mas_bottom]);
        make.left.equalTo(self.scrollView);
        self.tableHeight = 70;
        self.constraint = make.size.mas_equalTo(CGSizeMake(ScreenWidth, self.tableHeight));
    }];
    
    tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"CommentHeader" owner:nil options:nil] firstObject];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.scrollsToTop = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ContentOffset]) {
        CGFloat dy = self.scrollView.contentOffset.y;
        for (DetailIndex *index in self.indexes) {
            if ([index.className isEqualToString:@"TDFadeImageView"]) {
                DetailImageIndex *imageIndex0 = index.images[0];
                DetailImageIndex *imageIndex1 = index.images[1];
                
                if (dy < index.y - (ScreenHeight - index.h) * 0.5) {
                    [UIView animateWithDuration:imageIndex0.duration animations:^{
                        [index.imageViews[0] setAlpha:0];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:imageIndex1.duration animations:^{
                            [index.imageViews[1] setAlpha:1];
                        }];
                    }];
                } else {
                    [UIView animateWithDuration:imageIndex1.duration animations:^{
                        [index.imageViews[1] setAlpha:0];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:imageIndex0.duration animations:^{
                            [index.imageViews[0] setAlpha:1];
                        }];
                    }];
                }
            } else if ([index.className isEqualToString:@"TDLinkedMovingView"]) {
                if (dy < index.y && dy > 0) {
                    [index.movingViewTop uninstall];
                    [index.movingView mas_updateConstraints:^(MASConstraintMaker *make) {
                        index.movingViewTop = make.top.equalTo(self.scrollView).offset(-index.h);
                    }];
                } else if (dy  < (index.y + index.h) * 0.5) {
                    [index.movingViewTop uninstall];
                    [index.movingView mas_updateConstraints:^(MASConstraintMaker *make) {
                        index.movingViewTop = make.top.equalTo(self.scrollView).offset(-index.h + dy);
                    }];
                } else {
                    [index.movingViewTop uninstall];
                    [index.movingView mas_updateConstraints:^(MASConstraintMaker *make) {
                        index.movingViewTop = make.top.equalTo(self.scrollView).offset(index.y - dy);
                    }];
                }
            } else if ([index.className isEqualToString:@"TDRollingView"]) {
                CGFloat delta = index.y + index.h * 0.5 - dy;
                CGFloat k = delta / ScreenHeight;
                NSInteger i = 0;
                while (i < index.rolls.count - 1) {
                    if (i == 0 && k < [index.rolls.firstObject floatValue]) {
                        break;
                    }
                    i++;
                    if (k >= [index.rolls[i - 1] floatValue] && k < [index.rolls[i] floatValue]) {
                        break;
                    }
                }
                i = index.rolls.count - i - 1;
                [self.rollView setContentOffset:CGPointMake((index.bw + index.rollMargin) * i, 0) animated:YES];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [CommentCell cellWithTableView:tableView];
    cell.commentFrame = self.commentFrames[indexPath.row];
    cell.separatorLine.hidden = (indexPath.row == self.commentFrames.count - 1);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentFrame *commentFrame = self.commentFrames[indexPath.row];
    return commentFrame.cellHeight;
}

- (void)shareViewDidClickCancel:(ShareView *)shareView {
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.alpha = 0;
        
        [self.shareViewTop uninstall];
        [self.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.shareViewTop = make.top.equalTo(self.scrollView).offset(ScreenHeight);
        }];
        [self.view layoutIfNeeded];
    }];
}

@end