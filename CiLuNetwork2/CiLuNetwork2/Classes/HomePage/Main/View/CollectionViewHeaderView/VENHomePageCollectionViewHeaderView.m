//
//  VENHomePageCollectionViewHeaderView.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageCollectionViewHeaderView.h"

@interface VENHomePageCollectionViewHeaderView ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@end

@implementation VENHomePageCollectionViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.text = @"热门推荐";
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        [self addSubview:titleLabel];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] init];
        rightView.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self addSubview:rightView];
        
        self.lineView = lineView;
        self.titleLabel = titleLabel;
        self.leftView = leftView;
        self.rightView = rightView;
    }
    return self;
}

- (void)setTitle:(NSString *)title {    
    self.titleLabel.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, 0, kMainScreenWidth, 10);
    self.titleLabel.frame = CGRectMake(kMainScreenWidth / 2 - 64 / 2, 25, 64, 22);
    self.leftView.frame = CGRectMake(kMainScreenWidth / 2 - 64 / 2 - 30 - 12, 36, 30, 2);
    self.rightView.frame = CGRectMake(kMainScreenWidth / 2 + 30 + 12, 36, 30, 2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
