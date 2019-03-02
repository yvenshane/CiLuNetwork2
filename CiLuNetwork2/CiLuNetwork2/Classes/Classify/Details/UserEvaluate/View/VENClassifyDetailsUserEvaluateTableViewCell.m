//
//  VENClassifyDetailsUserEvaluateTableViewCell.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/20.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifyDetailsUserEvaluateTableViewCell.h"

@implementation VENClassifyDetailsUserEvaluateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userIconImageView.layer.cornerRadius = 12.0f;
    self.userIconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
