//
//  VENClassifyDetailsHeaderView.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/20.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifyDetailsHeaderView.h"

@implementation VENClassifyDetailsHeaderView

- (void)drawRect:(CGRect)rect {
    self.tokenLabel.layer.cornerRadius = 3.0f;
    self.tokenLabel.layer.masksToBounds = YES;
    
    self.evaluateUserIconImageView.layer.cornerRadius = 12.0f;
    self.evaluateUserIconImageView.layer.masksToBounds = YES;
}

@end
