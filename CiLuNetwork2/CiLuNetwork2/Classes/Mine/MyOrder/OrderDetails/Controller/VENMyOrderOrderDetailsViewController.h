//
//  VENMyOrderOrderDetailsViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/27.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

@interface VENMyOrderOrderDetailsViewController : VENBaseViewController
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, assign) BOOL isMyOrder;
@property (nonatomic, assign) NSInteger index;

@end
