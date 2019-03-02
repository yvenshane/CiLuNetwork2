//
//  VENMyCommissionModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/30.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyCommissionModel : NSObject
@property (nonatomic, copy) NSString *total_commission;

@property (nonatomic, copy) NSString *action_name;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *add_timestamp;

@end

NS_ASSUME_NONNULL_END
