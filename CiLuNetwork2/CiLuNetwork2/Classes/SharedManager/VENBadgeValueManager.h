//
//  VENBadgeValueManager.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/2/11.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENBadgeValueManager : NSObject
+ (instancetype)sharedManager;
- (void)setupRedDotWithTabBar:(UITabBarController *)tabBar;

@end

NS_ASSUME_NONNULL_END
