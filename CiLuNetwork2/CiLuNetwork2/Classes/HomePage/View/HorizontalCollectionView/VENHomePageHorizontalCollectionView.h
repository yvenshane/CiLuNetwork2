//
//  VENHomePageHorizontalCollectionView.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^pushToClassifyPageBlock)(NSString *);

@interface VENHomePageHorizontalCollectionView : UIView
@property (nonatomic, copy) NSArray *categoriesModel;
@property (nonatomic, copy) pushToClassifyPageBlock block;

@end

NS_ASSUME_NONNULL_END
