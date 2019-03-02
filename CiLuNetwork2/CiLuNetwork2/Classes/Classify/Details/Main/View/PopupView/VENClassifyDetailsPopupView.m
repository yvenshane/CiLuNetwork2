//
//  VENClassifyDetailsPopupView.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/19.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifyDetailsPopupView.h"
#import "VENClassifyDetailsPopupViewTableViewCell.h"

@interface VENClassifyDetailsPopupView () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENClassifyDetailsPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 49.0f;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        [tableView registerNib:[UINib nibWithNibName:@"VENClassifyDetailsPopupViewTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        [self addSubview:tableView];
        
        // 加入购物车
        UIButton *addShoppingCartButton = [[UIButton alloc] init];
        [addShoppingCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addShoppingCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addShoppingCartButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        addShoppingCartButton.backgroundColor = UIColorFromRGB(0xAA7D39);
        [self addSubview:addShoppingCartButton];
        
        // 立即购买
        UIButton *purchaseButton = [[UIButton alloc] init];
        [purchaseButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        purchaseButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        purchaseButton.backgroundColor = COLOR_THEME;
        [self addSubview:purchaseButton];
        
        _tableView = tableView;
        _addShoppingCartButton = addShoppingCartButton;
        _purchaseButton = purchaseButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, self.frame.size.height - tabBarHeight);
    self.addShoppingCartButton.frame = CGRectMake(0, self.frame.size.height - 48, kMainScreenWidth / 2, 48);
    self.purchaseButton.frame = CGRectMake(kMainScreenWidth / 2, self.frame.size.height - 48, kMainScreenWidth / 2, 48);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENClassifyDetailsPopupViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)closeButtonClick {
    self.block(@"");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height - 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
