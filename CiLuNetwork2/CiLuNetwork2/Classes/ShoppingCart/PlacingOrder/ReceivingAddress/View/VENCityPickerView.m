//
//  VENCityPickerView.m
//  EDAWCulture
//
//  Created by YVEN on 2018/10/8.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCityPickerView.h"

@interface VENCityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) NSDictionary *dataDict;

@property (nonatomic, strong) NSMutableArray *provincesNameMuArr;
@property (nonatomic, strong) NSMutableArray *citiesNameMuArr;
@property (nonatomic, strong) NSMutableArray *regionNameMuArr;

@property (nonatomic, strong) NSMutableArray *provincesIDMuArr;
@property (nonatomic, strong) NSMutableArray *citiesIDMuArr;
@property (nonatomic, strong) NSMutableArray *regionIDMuArr;

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *regionName;

@property (nonatomic, copy) NSString *provinceID;
@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *regionID;

@end

@implementation VENCityPickerView

- (instancetype)initWithFrame:(CGRect)frame forData:(NSDictionary *)dataDict {
    if (self = [super initWithFrame:frame]) {
        
        self.dataDict = dataDict;
        
        NSInteger count = 0;
        for (NSDictionary *provinceDict in dataDict) {
            [self.provincesNameMuArr addObject:provinceDict[@"region_name"]];
            [self.provincesIDMuArr addObject:provinceDict[@"region_id"]];
            
            if (count < 1) {
                for (NSDictionary *cityDict in provinceDict[@"sub"]) {
                    [self.citiesNameMuArr addObject:cityDict[@"region_name"]];
                    [self.citiesIDMuArr addObject:cityDict[@"region_id"]];
                    
                    for (NSDictionary *regionDict in cityDict[@"sub"]) {
                        [self.regionNameMuArr addObject:regionDict[@"region_name"]];
                        [self.regionIDMuArr addObject:regionDict[@"region_id"]];
                    }
                }
                count = count + 1;
            }
        }
        
        self.provinceName = self.provincesNameMuArr[0];
        self.cityName = self.citiesNameMuArr[0];
        self.regionName = self.regionNameMuArr[0];

        self.provinceID = [NSString stringWithFormat:@"%@", self.provincesIDMuArr[0]];
        self.cityID = [NSString stringWithFormat:@"%@", self.citiesIDMuArr[0]];
        self.regionID = [NSString stringWithFormat:@"%@", self.regionIDMuArr[0]];
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:pickerView];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitle:@"取消" forState: UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *finishButton = [[UIButton alloc] init];
        [finishButton setTitle:@"完成" forState: UIControlStateNormal];
        [finishButton setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self addSubview:lineView];
        
        _backgroundView = backgroundView;
        _cancelButton = cancelButton;
        _finishButton = finishButton;
        _pickerView = pickerView;
        _lineView = lineView;
    }
    
    return self;
}

- (void)cancelButtonClick {
    self.block(@{@"status" : @"cancel"});
}

- (void)finishButtonClick {
    
    NSDictionary *tempDict = @{@"provinceName" : self.provinceName,
                               @"cityName" : self.cityName,
                               @"regionName" : self.regionName,
                               @"provinceID" : self.provinceID,
                               @"cityID" : self.cityID,
                               @"regionID" : self.regionID};
    self.block(tempDict);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundView.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
    _cancelButton.frame = CGRectMake(0, 0, 88, 44);
    _finishButton.frame = CGRectMake(kMainScreenWidth - 88, 0, 88, 44);
    _pickerView.frame = CGRectMake(0, 44, kMainScreenWidth, 216);
    _lineView.frame = CGRectMake(0, 43, kMainScreenWidth, 1);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provincesNameMuArr.count;
    } else if (component == 1) {
        return self.citiesNameMuArr.count;
    } else {
        return self.regionNameMuArr.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provincesNameMuArr[row];
    } else if (component == 1) {
        return self.citiesNameMuArr[row];
    } else {
        return self.regionNameMuArr[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        [self.citiesNameMuArr removeAllObjects];
        [self.citiesIDMuArr removeAllObjects];
        
        [self.regionNameMuArr removeAllObjects];
        [self.regionIDMuArr removeAllObjects];
        
        for (NSDictionary *provinceDict in self.dataDict) {
            
            if ([self.provincesNameMuArr[row] isEqualToString:provinceDict[@"region_name"]]) {
                for (NSDictionary *cityDict in provinceDict[@"sub"]) {
                    [self.citiesNameMuArr addObject:cityDict[@"region_name"]];
                    [self.citiesIDMuArr addObject:cityDict[@"region_id"]];
                    
                    if ([self.citiesNameMuArr[0] isEqualToString:cityDict[@"region_name"]]) {
                        for (NSDictionary *regionDict in cityDict[@"sub"]) {
                            [self.regionNameMuArr addObject:regionDict[@"region_name"]];
                            [self.regionIDMuArr addObject:regionDict[@"region_id"]];
                        }
                    }
                }
            }
        }

        // 刷新城市列表
        [pickerView reloadComponent:1];
        // 更换省份 城市列表 恢复到第一行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        // 刷新地区列表
        [pickerView reloadComponent:2];
        // 更换城市 地区列表 恢复到第一行
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.provinceName = self.provincesNameMuArr[row];
        self.cityName = self.citiesNameMuArr[0];
        self.regionName = self.regionNameMuArr[0];
        
        self.provinceID = [NSString stringWithFormat:@"%@", self.provincesIDMuArr[row]];
        self.cityID = [NSString stringWithFormat:@"%@", self.citiesIDMuArr[0]];
        self.regionID = [NSString stringWithFormat:@"%@", self.regionIDMuArr[0]];
        
    } else if (component == 1) {
        [self.regionNameMuArr removeAllObjects];
        [self.regionIDMuArr removeAllObjects];
        
        for (NSDictionary *provinceDict in self.dataDict) {
            for (NSDictionary *cityDict in provinceDict[@"sub"]) {
                for (NSDictionary *regionDict in cityDict[@"sub"]) {
                    if ([self.citiesNameMuArr[row] isEqualToString:cityDict[@"region_name"]]) {
                        [self.regionNameMuArr addObject:regionDict[@"region_name"]];
                        [self.regionIDMuArr addObject:regionDict[@"region_id"]];
                    }
                }
            }
        }
        
        // 刷新地区列表
        [pickerView reloadComponent:2];
        // 更换城市 地区列表 恢复到第一行
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        self.cityName = self.citiesNameMuArr[row];
        self.regionName = self.regionNameMuArr[0];
        
        self.cityID = [NSString stringWithFormat:@"%@", self.citiesIDMuArr[row]];
        self.regionID = [NSString stringWithFormat:@"%@", self.regionIDMuArr[0]];
        
    } else {
        
        self.regionName = self.regionNameMuArr[row];
        self.regionID = [NSString stringWithFormat:@"%@", self.regionIDMuArr[row]];
    }
}

- (NSMutableArray *)provincesNameMuArr {
    if (_provincesNameMuArr == nil) {
        _provincesNameMuArr = [NSMutableArray array];
    }
    return _provincesNameMuArr;
}

- (NSMutableArray *)citiesNameMuArr {
    if (_citiesNameMuArr == nil) {
        _citiesNameMuArr = [NSMutableArray array];
    }
    return _citiesNameMuArr;
}

- (NSMutableArray *)regionNameMuArr {
    if (_regionNameMuArr == nil) {
        _regionNameMuArr = [NSMutableArray array];
    }
    return _regionNameMuArr;
}

- (NSMutableArray *)provincesIDMuArr {
    if (_provincesIDMuArr == nil) {
        _provincesIDMuArr = [NSMutableArray array];
    }
    return _provincesIDMuArr;
}

- (NSMutableArray *)citiesIDMuArr {
    if (_citiesIDMuArr == nil) {
        _citiesIDMuArr = [NSMutableArray array];
    }
    return _citiesIDMuArr;
}

- (NSMutableArray *)regionIDMuArr {
    if (_regionIDMuArr == nil) {
        _regionIDMuArr = [NSMutableArray array];
    }
    return _regionIDMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
