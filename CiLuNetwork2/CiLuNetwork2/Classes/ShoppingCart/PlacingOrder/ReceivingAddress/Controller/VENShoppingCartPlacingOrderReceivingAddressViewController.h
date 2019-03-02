//
//  VENShoppingCartPlacingOrderReceivingAddressViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
@class VENShoppingCartPlacingOrderReceivingAddressModel;

typedef void (^choiceAddressBlock)(VENShoppingCartPlacingOrderReceivingAddressModel *);
@interface VENShoppingCartPlacingOrderReceivingAddressViewController : VENBaseViewController
@property (nonatomic, copy) choiceAddressBlock block;

@end
