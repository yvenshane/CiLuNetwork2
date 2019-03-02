//
//  VENShoppingCartPlacingOrderReceivingAddressTableViewCell.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENShoppingCartPlacingOrderReceivingAddressTableViewCell.h"

@implementation VENShoppingCartPlacingOrderReceivingAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftLabel.layer.borderWidth = 1.0f;
    self.leftLabel.layer.borderColor = COLOR_THEME.CGColor;
    self.leftLabel.layer.cornerRadius = 2.0f;
    self.leftLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
