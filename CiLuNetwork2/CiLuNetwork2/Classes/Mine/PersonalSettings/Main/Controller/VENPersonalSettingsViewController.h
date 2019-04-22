//
//  VENPersonalSettingsViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/15.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^loginoutSuccessBlock)(NSString *);
@interface VENPersonalSettingsViewController : VENBaseViewController
@property (nonatomic, copy) loginoutSuccessBlock block;
@property (nonatomic, assign) BOOL isKeyAccount;

@end

NS_ASSUME_NONNULL_END
