//
//  VENHomePageHorizontalCollectionViewCell2.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageHorizontalCollectionViewCell2.h"

@implementation VENHomePageHorizontalCollectionViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backView.layer.cornerRadius = 3.0f;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderWidth = 1.0f;
    self.backView.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
}

@end
