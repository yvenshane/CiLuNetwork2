//
//  VENUserStatusManager.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/10.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENUserStatusManager.h"

static VENUserStatusManager *instance;
static dispatch_once_t onceToken;
@implementation VENUserStatusManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[VENUserStatusManager alloc] init];
    });
    return instance;
}

- (BOOL)isLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:[userDefaults objectForKey:@"token"]]) {
        return NO;
    } else {
        return YES;
    }
}

@end
