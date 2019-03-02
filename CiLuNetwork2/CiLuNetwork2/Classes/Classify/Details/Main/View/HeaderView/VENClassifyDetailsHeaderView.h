//
//  VENClassifyDetailsHeaderView.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/20.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VENClassifyDetailsHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;
@property (weak, nonatomic) IBOutlet UILabel *evaluateNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *evaluateUserIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *evaluateUserPhonenumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluateContentLabel;

@end
