//
//  VENMineTableViewCellStyleOne.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineTableViewCellStyleOne.h"

@implementation VENMineTableViewCellStyleOne

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 20;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.rightButton.layer.cornerRadius = 3.0f;
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.borderWidth = 1.0f;
    self.rightButton.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
