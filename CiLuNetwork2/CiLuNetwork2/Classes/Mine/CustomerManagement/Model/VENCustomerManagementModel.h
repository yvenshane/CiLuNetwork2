//
//  VENCustomerManagementModel.h
//  CiLuNetwork2
//
//  Created by YVEN on 2019/3/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENCustomerManagementModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *address_id;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
