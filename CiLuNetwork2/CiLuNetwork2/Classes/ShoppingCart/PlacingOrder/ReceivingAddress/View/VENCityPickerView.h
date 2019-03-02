//
//  VENCityPickerView.h
//  EDAWCulture
//
//  Created by YVEN on 2018/10/8.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^citySelectorBlock)(NSDictionary *);
@interface VENCityPickerView : UIView
@property (nonatomic, copy) citySelectorBlock block;

- (instancetype)initWithFrame:(CGRect)frame forData:(NSDictionary *)dataDict;

@end

NS_ASSUME_NONNULL_END
