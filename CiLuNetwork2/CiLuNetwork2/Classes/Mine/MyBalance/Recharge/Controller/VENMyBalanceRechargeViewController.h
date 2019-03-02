//
//  VENMyBalanceRechargeViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

typedef void (^successfulPaymentBlock)(NSString *);
@interface VENMyBalanceRechargeViewController : VENBaseViewController
@property (nonatomic, copy) successfulPaymentBlock block;

@end
