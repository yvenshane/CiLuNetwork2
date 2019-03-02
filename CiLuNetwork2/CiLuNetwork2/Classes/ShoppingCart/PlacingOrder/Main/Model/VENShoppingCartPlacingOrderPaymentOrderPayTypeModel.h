//
//  VENShoppingCartPlacingOrderPaymentOrderPayTypeModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/22.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENShoppingCartPlacingOrderPaymentOrderPayTypeModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *tip;
@property (nonatomic, copy) NSString *payID;

@property (nonatomic, assign) BOOL isChoice;

@end

NS_ASSUME_NONNULL_END
