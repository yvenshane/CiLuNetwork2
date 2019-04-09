//
//  VENDatePickerView.h
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/3.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^datePickerBlock)(NSString *);
@interface VENDatePickerView : UIView
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, copy) datePickerBlock datePickerBlock;

@end

NS_ASSUME_NONNULL_END
