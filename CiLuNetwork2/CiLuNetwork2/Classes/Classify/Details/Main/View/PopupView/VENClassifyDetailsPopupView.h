//
//  VENClassifyDetailsPopupView.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/19.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^popupViewCloseButtonBlock)(NSString *);
@interface VENClassifyDetailsPopupView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *purchaseButton;
@property (nonatomic, strong) UIButton *addShoppingCartButton;
@property (nonatomic, copy) popupViewCloseButtonBlock block;

@end
