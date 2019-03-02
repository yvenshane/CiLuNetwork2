//
//  VENMineModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/10.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMineModel : NSObject
@property (nonatomic, copy) NSString *tag_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *balance;

@property (nonatomic, copy) NSString *shipping_count;
@property (nonatomic, copy) NSString *receiving_count;
@property (nonatomic, copy) NSString *comment_count;

@end

NS_ASSUME_NONNULL_END
