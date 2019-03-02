//
//  VENMyOrderTableViewCell.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/27.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOrderTableViewCell.h"

@implementation VENMyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.priceLabel.textColor = UIColorFromRGB(0x1A1A1A);
    
    self.leftButton.layer.cornerRadius = 2.0f;
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.borderWidth = 1.0f;
    self.leftButton.layer.borderColor = UIColorFromRGB(0x979797).CGColor;
    
    self.rightButton.layer.cornerRadius = 2.0f;
    self.rightButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
