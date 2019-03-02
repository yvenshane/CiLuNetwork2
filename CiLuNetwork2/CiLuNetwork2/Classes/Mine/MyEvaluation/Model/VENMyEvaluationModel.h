//
//  VENMyEvaluationModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/30.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyEvaluationModel : NSObject
@property (nonatomic, copy) NSString *evaluationID;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *reply_content;
@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *goods_price;

@end

NS_ASSUME_NONNULL_END
