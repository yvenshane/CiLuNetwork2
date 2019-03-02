//
//  VENMineTableViewCellStyleThree.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineTableViewCellStyleThree.h"

@implementation VENMineTableViewCellStyleThree

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.iconButton.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    self.iconButton.layer.cornerRadius = 36.0f;
    self.iconButton.layer.masksToBounds = YES;
    
    self.otherButton.layer.cornerRadius = 10.0f;
    self.otherButton.layer.masksToBounds = YES;
    self.otherButton.layer.borderWidth = 1.0f;
    self.otherButton.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
    
    [self.otherButton setTitleColor:UIColorFromRGB(0xCCCCCC) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
