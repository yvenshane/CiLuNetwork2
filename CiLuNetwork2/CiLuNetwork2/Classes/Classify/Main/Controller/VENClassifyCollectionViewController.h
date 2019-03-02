//
//  VENClassifyCollectionViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/14.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
#import "VENClassifyModel.h"

typedef void (^collectionViewDidSelectBlock)(NSString *);
typedef void (^titleDidSelectBlock)(NSInteger);
@interface VENClassifyCollectionViewController : UICollectionViewController
@property (nonatomic, strong) NSMutableArray *lists_goods;
@property (nonatomic, strong) VENClassifyModel *model;

@property (nonatomic, copy) collectionViewDidSelectBlock block;
@property (nonatomic, copy) titleDidSelectBlock block1;

@end
