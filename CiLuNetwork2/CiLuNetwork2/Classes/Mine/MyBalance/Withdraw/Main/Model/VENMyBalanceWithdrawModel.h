//
//  VENMyBalanceWithdrawModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/28.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyBalanceWithdrawModel : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *username;

@property (nonatomic, assign) BOOL isChoise;

@end

NS_ASSUME_NONNULL_END
