//
//  VENDatePickerView.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/3.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDatePickerView.h"

@interface VENDatePickerView ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *tempView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation VENDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        // 完成按钮
        UIButton *doneButton = [[UIButton alloc] init];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:doneButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorMake(224, 224, 224);
        [self addSubview:lineView];
        
        // 日期选择
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.calendar = [NSCalendar currentCalendar];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
        
        // iPhone X 细节优化
        if (isIPhoneX) {
            UIView *tempView = [[UIView alloc] init];
            tempView.backgroundColor = [UIColor whiteColor];
            [self addSubview:tempView];
            
            _tempView = tempView;
        }
        
        _doneButton = doneButton;
        _lineView = lineView;
        _datePicker = datePicker;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.datePicker setDate:[self.dateFormatter dateFromString:self.date] animated:YES];
    self.datePicker.minimumDate = self.minimumDate;
    self.datePicker.maximumDate = self.maximumDate;
    
    self.doneButton.frame = CGRectMake(kMainScreenWidth - 44 - 20, 0, 44, 44);
    self.lineView.frame = CGRectMake(0, 44, kMainScreenWidth, 1);
    self.datePicker.frame = CGRectMake(0, 44, kMainScreenWidth, 216);
    
    if (isIPhoneX) {
        self.tempView.frame = CGRectMake(0, 216 + 44 - (tabBarHeight - 49), kMainScreenWidth, tabBarHeight - 49);
    }
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    NSString *dateStr = [self.dateFormatter stringFromDate:datePicker.date];
    self.datePickerBlock(dateStr);
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
