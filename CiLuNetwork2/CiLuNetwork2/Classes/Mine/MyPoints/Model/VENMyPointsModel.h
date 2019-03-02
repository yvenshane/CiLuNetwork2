//
//  VENMyPointsModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/30.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyPointsModel : NSObject
@property (nonatomic, copy) NSString *total_score;

@property (nonatomic, copy) NSString *action_name;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *add_timestamp;

@end

NS_ASSUME_NONNULL_END
