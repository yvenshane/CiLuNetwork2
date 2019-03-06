//
//  VENCustomerManagementEditViewController.h
//  CiLuNetwork2
//
//  Created by YVEN on 2019/3/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
@class VENCustomerManagementModel;

NS_ASSUME_NONNULL_BEGIN
typedef void (^refreshPageBlock)(NSString *);
@interface VENCustomerManagementEditViewController : VENBaseViewController
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) refreshPageBlock block;
@property (nonatomic, strong) VENCustomerManagementModel *model;

@end

NS_ASSUME_NONNULL_END
