//
//  VENSalesManagementHeaderViewTableViewCell.h
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/1.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENSalesManagementHeaderViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftDatePickerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightDatePickerButton;
@property (weak, nonatomic) IBOutlet UILabel *leftDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDateLabel;

@end

NS_ASSUME_NONNULL_END
