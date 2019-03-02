//
//  VENShoppingCartPlacingOrderFooterView.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/21.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENShoppingCartPlacingOrderFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *leavingMessageTextField;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@end
