//
//  VENPersonalDataNamePageViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/28.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^saveSuccessfullyBlock)(NSString *);
@interface VENPersonalDataNamePageViewController : VENBaseViewController
@property (nonatomic, copy) saveSuccessfullyBlock block;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
