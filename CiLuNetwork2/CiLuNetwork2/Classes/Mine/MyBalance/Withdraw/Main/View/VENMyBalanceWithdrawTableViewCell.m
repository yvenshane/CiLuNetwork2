//
//  VENMyBalanceWithdrawTableViewCell.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyBalanceWithdrawTableViewCell.h"

@implementation VENMyBalanceWithdrawTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.allWithdrawButton.layer.cornerRadius = 2.0f;
    self.allWithdrawButton.layer.masksToBounds = YES;
    self.allWithdrawButton.layer.borderWidth = 1.0f;
    self.allWithdrawButton.layer.borderColor = UIColorFromRGB(0xC7974F).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
