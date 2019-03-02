//
//  VENMyCollectionModel.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/30.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyCollectionModel : NSObject
@property (nonatomic, copy) NSString *collectionID;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_thumb;
@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, assign) BOOL isChoise;

@end

NS_ASSUME_NONNULL_END
