//
//  VENHomePageHorizontalCollectionView2.h
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^pushToFoundationPageBlock)(NSString *);

@interface VENHomePageHorizontalCollectionView2 : UIView
@property (nonatomic, copy) pushToFoundationPageBlock pushToFoundationPageBlock;

@end

NS_ASSUME_NONNULL_END
