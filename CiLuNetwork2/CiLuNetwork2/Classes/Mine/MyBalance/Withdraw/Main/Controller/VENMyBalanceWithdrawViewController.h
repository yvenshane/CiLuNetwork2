//
//  VENMyBalanceWithdrawViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

typedef void (^successfulWithdrawalsBlock)(NSString *);
@interface VENMyBalanceWithdrawViewController : VENBaseViewController
@property (nonatomic, copy) successfulWithdrawalsBlock block;

@end
