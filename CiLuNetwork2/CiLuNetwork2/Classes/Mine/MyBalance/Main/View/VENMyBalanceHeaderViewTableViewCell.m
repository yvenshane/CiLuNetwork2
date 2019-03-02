//
//  VENMyBalanceHeaderViewTableViewCell.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyBalanceHeaderViewTableViewCell.h"

@implementation VENMyBalanceHeaderViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftButton.layer.cornerRadius = 4.0f;
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.borderWidth = 1.0f;
    self.leftButton.layer.borderColor = UIColorFromRGB(0xC7974F).CGColor;
    
    self.rightButton.layer.cornerRadius = 4.0f;
    self.rightButton.layer.masksToBounds = YES;
    
    self.middleButton.layer.cornerRadius = 4.0f;
    self.middleButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
