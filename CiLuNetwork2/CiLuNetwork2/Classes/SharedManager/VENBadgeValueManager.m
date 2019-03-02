//
//  VENBadgeValueManager.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/2/11.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBadgeValueManager.h"

static VENBadgeValueManager *instance;
static dispatch_once_t onceToken;
@implementation VENBadgeValueManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[VENBadgeValueManager alloc] init];
    });
    return instance;
}

- (void)setupRedDotWithTabBar:(UITabBarController *)tabBar {
    
    if ([[VENUserStatusManager sharedManager] isLogin]) {
        NSString *redDot = [[NSUserDefaults standardUserDefaults] objectForKey:@"RedDot"];
        
        if ([[VENClassEmptyManager sharedManager] isEmptyString:redDot]) {
            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/lists" params:nil showLoading:NO successBlock:^(id response) {
                
                if ([response[@"status"] integerValue] == 0) {
                    if ([response[@"data"][@"count"] integerValue] > 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", response[@"data"][@"count"]] forKey:@"RedDot"];
                        [tabBar.tabBar.items[2] setBadgeValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"RedDot"]];
                    } else {
                        [tabBar.tabBar.items[2] setBadgeValue:nil];
                    }
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        } else {
            [tabBar.tabBar.items[2] setBadgeValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"RedDot"]];
        }
    }
}

@end
