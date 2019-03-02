//
//  VENMineTableViewCellStyleTwo.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineTableViewCellStyleTwo.h"

@implementation VENMineTableViewCellStyleTwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.shippingCountLabel.layer.cornerRadius = 8.0f;
    self.shippingCountLabel.layer.masksToBounds = YES;
    
    self.receivingCountLabel.layer.cornerRadius = 8.0f;
    self.receivingCountLabel.layer.masksToBounds = YES;
    
    self.commentCountLabel.layer.cornerRadius = 8.0f;
    self.commentCountLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
