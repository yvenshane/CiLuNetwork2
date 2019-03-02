//
//  VENShoppingCartPlacingOrderAddReceivingAddressViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
@class VENShoppingCartPlacingOrderReceivingAddressModel;

typedef void (^refreshPageBlock)(NSString *);
@interface VENShoppingCartPlacingOrderAddReceivingAddressViewController : VENBaseViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) refreshPageBlock block;
@property (nonatomic, strong) VENShoppingCartPlacingOrderReceivingAddressModel *model;

@end
