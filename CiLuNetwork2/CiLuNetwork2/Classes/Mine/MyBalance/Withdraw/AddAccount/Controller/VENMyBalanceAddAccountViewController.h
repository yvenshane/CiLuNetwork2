//
//  VENMyBalanceAddAccountViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
@class VENMyBalanceWithdrawModel;

typedef void (^saveSuccessfullyBlock)(NSString *);
@interface VENMyBalanceAddAccountViewController : VENBaseViewController
@property (nonatomic, strong) VENMyBalanceWithdrawModel *model;
@property (nonatomic, copy) saveSuccessfullyBlock block;

@end
