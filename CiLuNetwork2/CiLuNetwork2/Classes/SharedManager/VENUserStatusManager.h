//
//  VENUserStatusManager.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/10.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENUserStatusManager : NSObject
+ (instancetype)sharedManager;
- (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
