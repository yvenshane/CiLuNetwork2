//
//  VENShoppingCartPlacingOrderReceivingAddressModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/20.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENShoppingCartPlacingOrderReceivingAddressModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *address_id;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *is_default;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
