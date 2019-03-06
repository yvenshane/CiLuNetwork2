//
//  VENMineTableViewCellStyleThree.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENMineTableViewCellStyleThree : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameButtonCenterYLayoutConstraint;

@end
