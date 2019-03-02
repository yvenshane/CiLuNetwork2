//
//  VENMyOrderAllOrdersModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/22.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyOrderAllOrdersModel : NSObject
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *status_text;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSArray *goods_list;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *spec;

@end

NS_ASSUME_NONNULL_END
