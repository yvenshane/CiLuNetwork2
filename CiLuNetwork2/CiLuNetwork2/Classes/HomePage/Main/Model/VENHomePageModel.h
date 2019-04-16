//
//  VENHomePageModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/10.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) BOOL is_link;
@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *cate_icon;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *cate_name;

@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *sale_status;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *date_time;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
