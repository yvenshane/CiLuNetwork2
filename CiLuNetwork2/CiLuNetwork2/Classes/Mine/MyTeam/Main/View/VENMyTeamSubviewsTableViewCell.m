//
//  VENMyTeamSubviewsTableViewCell.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/27.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyTeamSubviewsTableViewCell.h"

@implementation VENMyTeamSubviewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.cornerRadius = 24.0f;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
