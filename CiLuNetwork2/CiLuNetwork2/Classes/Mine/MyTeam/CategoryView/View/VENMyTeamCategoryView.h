//
//  VENMyTeamCategoryView.h
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/27.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyTeamCategoryView : UIControl
@property (nonatomic, assign) CGFloat offset_X;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, copy) NSArray<UIButton *> *btnsArr;

@end

NS_ASSUME_NONNULL_END
