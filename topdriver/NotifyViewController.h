//
//  MessageViewController.h
//  topdriver
//
//  Created by zmx on 16/2/1.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^Detail)(UIViewController *controller);

@interface NotifyViewController : BaseViewController

@property (nonatomic, copy) Detail detail;

@end
