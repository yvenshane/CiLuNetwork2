//
//  VENMyOrderOrderDetailsModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/22.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyOrderOrderDetailsModel : NSObject
// address
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *province_name;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *district_name;

// order_info
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *status_text;
@property (nonatomic, copy) NSString *status_tip_text;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *comment;

// express
@property (nonatomic, copy) NSString *is_show;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;

// goods_list
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *goods_price;
//@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *spec;

@end

NS_ASSUME_NONNULL_END
