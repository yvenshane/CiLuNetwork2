//
//  VENClassifyDetailsToolBarView.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/19.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifyDetailsToolBarView.h"

@interface VENClassifyDetailsToolBarView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconImageView2;
@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UILabel *wordLabel2;
@property (nonatomic, strong) UIView *splitLineView;

@end

@implementation VENClassifyDetailsToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 客服
        UIButton *customerServiceButton = [[UIButton alloc] init];
        customerServiceButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:customerServiceButton];
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"icon_customer_service"];
        [self addSubview:iconImageView];
        
        UILabel *wordLabel = [[UILabel alloc] init];
        wordLabel.text = @"客服";
        wordLabel.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:wordLabel];
        
        // 购物车
        UIButton *shoppingCartButton = [[UIButton alloc] init];
        shoppingCartButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:shoppingCartButton];
        
        UIImageView *iconImageView2 = [[UIImageView alloc] init];
        iconImageView2.image = [UIImage imageNamed:@"icon_shopping_cart"];
        [self addSubview:iconImageView2];
        
        UILabel *wordLabel2 = [[UILabel alloc] init];
        wordLabel2.text = @"购物车";
        wordLabel2.font = [UIFont systemFontOfSize:10.0f];
        [self addSubview:wordLabel2];
        
        // 小红点
        UILabel *redDotLabel = [[UILabel alloc] init];
        redDotLabel.textAlignment = NSTextAlignmentCenter;
        redDotLabel.backgroundColor = [UIColor redColor];
        redDotLabel.font = [UIFont systemFontOfSize:10.0f];
        redDotLabel.textColor = [UIColor whiteColor];
        redDotLabel.layer.cornerRadius = 6.5f;
        redDotLabel.layer.masksToBounds = YES;
        redDotLabel.hidden = YES;
        [iconImageView2 addSubview:redDotLabel];
        
        // 加入购物车
        UIButton *addShoppingCartButton = [[UIButton alloc] init];
        [addShoppingCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        addShoppingCartButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        addShoppingCartButton.backgroundColor = UIColorFromRGB(0xAA7D39);
        [self addSubview:addShoppingCartButton];
        
        // 立即购买
        UIButton *purchaseButton = [[UIButton alloc] init];
        [purchaseButton setTitle:@"立即购买" forState:UIControlStateNormal];
        purchaseButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        purchaseButton.backgroundColor = COLOR_THEME;
        [self addSubview:purchaseButton];
        
        // 线
        UIView *splitLineView = [[UIView alloc] init];
        splitLineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self addSubview:splitLineView];
        
        self.customerServiceButton = customerServiceButton;
        self.shoppingCartButton = shoppingCartButton;
        self.addShoppingCartButton = addShoppingCartButton;
        self.purchaseButton = purchaseButton;
        
        self.iconImageView = iconImageView;
        self.iconImageView2 = iconImageView2;
        self.wordLabel = wordLabel;
        self.wordLabel2 = wordLabel2;
        self.redDotLabel = redDotLabel;
        self.splitLineView = splitLineView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.customerServiceButton.frame = CGRectMake(0, 0, kMainScreenWidth / 3 / 2 - 10, 48);
    self.shoppingCartButton.frame = CGRectMake(kMainScreenWidth / 3  / 2 + 10, 0, kMainScreenWidth / 3 / 2 + 10, 48);
    self.addShoppingCartButton.frame = CGRectMake((kMainScreenWidth / 3 + 20), 0, (kMainScreenWidth / 3 - 10), 48);
    self.purchaseButton.frame = CGRectMake(kMainScreenWidth - (kMainScreenWidth / 3 - 10), 0, (kMainScreenWidth / 3 - 10), 48);
    
    self.iconImageView.frame = CGRectMake((kMainScreenWidth / 3 + 20) / 5 / 2 + (kMainScreenWidth / 3 + 20) / 5 - 18 / 2, 8, 18, 18);
    self.iconImageView2.frame = CGRectMake((kMainScreenWidth / 3 + 20) / 5 / 2 + ((kMainScreenWidth / 3 + 20) / 5 * 3) - 18 / 2, 8, 18, 18);
    self.wordLabel.frame = CGRectMake((kMainScreenWidth / 3 + 20) / 5 / 2 + (kMainScreenWidth / 3 + 20) / 5 - 24 / 2, 8 + 18 + 3, 24, 14);
    self.wordLabel2.frame = CGRectMake((kMainScreenWidth / 3 + 20) / 5 / 2 + ((kMainScreenWidth / 3 + 20) / 5 * 3) - 32 / 2, 8 + 18 + 3, 32, 14);
    self.redDotLabel.frame = CGRectMake(12, -4, 13, 13);
    self.splitLineView.frame = CGRectMake(0, 0, kMainScreenWidth, 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
