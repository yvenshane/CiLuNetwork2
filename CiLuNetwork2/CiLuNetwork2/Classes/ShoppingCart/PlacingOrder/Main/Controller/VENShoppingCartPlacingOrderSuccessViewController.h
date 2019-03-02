//
//  VENShoppingCartPlacingOrderSuccessViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/26.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENShoppingCartPlacingOrderSuccessViewController : UIViewController
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, assign) BOOL isMyOrder;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isMyOrderDetail;

@end
