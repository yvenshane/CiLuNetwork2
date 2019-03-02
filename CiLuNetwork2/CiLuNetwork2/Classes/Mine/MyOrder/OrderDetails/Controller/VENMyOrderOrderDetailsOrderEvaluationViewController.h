//
//  VENMyOrderOrderDetailsOrderEvaluationViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/28.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

typedef void (^refreshOrderDetailshBlock)(NSString *);
@interface VENMyOrderOrderDetailsOrderEvaluationViewController : VENBaseViewController
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *pushFrom;
@property (nonatomic, copy) refreshOrderDetailshBlock block;



@end
