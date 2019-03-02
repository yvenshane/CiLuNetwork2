//
//  VENShoppingCartPlacingOrderPaymentOrderModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/21.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENShoppingCartPlacingOrderPaymentOrderModel : NSObject
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *balance_formatted;
@property (nonatomic, copy) NSString *is_balance_pay;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *total_price_formatted;

@end

NS_ASSUME_NONNULL_END
