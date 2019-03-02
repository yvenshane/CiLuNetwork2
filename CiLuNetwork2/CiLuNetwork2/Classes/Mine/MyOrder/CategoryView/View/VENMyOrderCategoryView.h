//
//  VENMyOrderCategoryView.h
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENMyOrderCategoryView : UIControl
@property (nonatomic, assign) CGFloat offset_X;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, copy) NSArray<UIButton *> *btnsArr;

@end
