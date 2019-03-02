//
//  VENHomePageHorizontalCollectionViewCell.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageHorizontalCollectionViewCell.h"

@implementation VENHomePageHorizontalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 20.0f;
    self.iconImageView.layer.masksToBounds = YES;
}

@end
