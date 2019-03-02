//
//  VENShoppingCartModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/15.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENShoppingCartModel : NSObject
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *shoppingCartID;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *price_formatted;
@property (nonatomic, copy) NSString *spec;

@property (nonatomic, assign) BOOL isChoice;

@property (nonatomic, copy) NSString *price_count_formatted;
@property (nonatomic, copy) NSString *price_total_count_formatted;

@property (nonatomic, copy) NSString *address_id;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
