//
//  VENMineTableViewCellStyleTwo.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/13.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENMineTableViewCellStyleTwo : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *waitingForShipmentButton;
@property (weak, nonatomic) IBOutlet UIButton *waitingForReceivingButton;
@property (weak, nonatomic) IBOutlet UIButton *waitingForEvaluationButton;

@property (weak, nonatomic) IBOutlet UILabel *shippingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end
