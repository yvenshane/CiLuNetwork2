//
//  VENHomePageNavigationItemTitleView.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/4.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^homePageNavigationItemTitleViewBlock)(NSString *);
@interface VENHomePageNavigationItemTitleView : UIView
@property (nonatomic, assign) CGFloat titleViewWidth;
@property (nonatomic, copy) homePageNavigationItemTitleViewBlock buttonClickBlock;

@end

NS_ASSUME_NONNULL_END
