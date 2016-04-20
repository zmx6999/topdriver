//
//  ShareView.m
//  topdriver
//
//  Created by zmx on 16/2/7.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "ShareView.h"
#import "ShareCell.h"

static NSString *ID = @"share";

@interface ShareView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *iconNames;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *shares;

@end

@implementation ShareView
- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewDidClickCancel:)]) {
        [self.delegate shareViewDidClickCancel:self];
    }
}

- (NSArray *)iconNames {
    if (_iconNames == nil) {
        _iconNames = @[@"分享图标_05", @"分享图标_07", @"分享图标_09", @"分享图标_11", @"分享图标_22", @"分享图标_20", @"分享图标_18", @"分享图标_23"];
    }
    return _iconNames;
}

- (NSArray *)titles {
    if (_titles == nil) {
        _titles = @[@"腾讯微博", @"微信", @"微信朋友圈", @"新浪微博", @"豆瓣", @"短信", @"邮箱", @"复制链接"];
    }
    return _titles;
}

- (NSArray *)shares {
    if (_shares == nil) {
        _shares = @[UMShareToTencent, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToDouban, UMShareToSms, UMShareToEmail];
    }
    return _shares;
}

- (void)awakeFromNib {
    self.layout.itemSize = CGSizeMake(ScreenWidth / 5, 100);
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShareCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.icon.image = [UIImage imageNamed:self.iconNames[indexPath.item]];
    cell.title.text = self.titles[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.iconNames.count - 1) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[self.shares[indexPath.item]] content:self.shareTitle image:self.shareIcon location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeVideo url:self.shareLink] presentedController:[self getViewController] completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                [self cancel:nil];
            }
        }];
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.shareLink;
        [self cancel:nil];
    }
}

@end