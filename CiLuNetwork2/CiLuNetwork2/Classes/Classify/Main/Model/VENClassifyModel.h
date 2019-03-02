//
//  VENClassifyModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/11.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENClassifyModel : NSObject
// categories
@property (nonatomic, copy) NSString *cate_icon;
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *cate_name;

//current_conditions
//@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *price_sort;
@property (nonatomic, copy) NSString *sales_volume_sort;

// lists
  // goods
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *sale_status;

@property (nonatomic, copy) NSString *hasNext;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *recordCount;

@end

NS_ASSUME_NONNULL_END
