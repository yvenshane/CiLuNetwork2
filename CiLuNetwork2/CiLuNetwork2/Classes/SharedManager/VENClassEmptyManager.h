//
//  VENClassEmptyManager.h
//
//  Created by YVEN.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENClassEmptyManager : NSObject
+ (instancetype)sharedManager;
- (BOOL)isEmptyString:(NSString *)string;
- (BOOL)isEmptyArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
