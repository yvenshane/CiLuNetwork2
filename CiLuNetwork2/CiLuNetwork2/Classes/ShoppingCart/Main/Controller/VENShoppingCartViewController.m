//
//  VENShoppingCartViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/3.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENShoppingCartViewController.h"
#import "VENShoppingCartTableViewCell.h"
#import "VENShoppingCartPlacingOrderViewController.h"
#import "VENShoppingCartModel.h"

@interface VENShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *placeholderBackgroundView;

@property (nonatomic, strong) UIButton *navigationRightButton; // 编辑 / 完成
@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) UIView *shoppingBar;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, assign) BOOL isSelectAll;

@property (nonatomic, strong) NSMutableArray *listMuArr;
@property (nonatomic, strong) NSMutableArray *choiceListMuArr;
@property (nonatomic, strong) NSMutableArray <UIButton *>*choiceButtonsMuArr;
@property (nonatomic, strong) NSMutableArray <UIButton *>*numberButtonsMuArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENShoppingCartViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[VENBadgeValueManager sharedManager] setupRedDotWithTabBar:self.tabBarController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self setupTableView];
    
    if ([[VENUserStatusManager sharedManager] isLogin]) {
        [_tableView.mj_header beginRefreshing];
    } else {
        [self.choiceListMuArr removeAllObjects];
        self.isSelectAll = NO;
        self.isEdit = NO;
        
        [self.shoppingBar removeFromSuperview];
        self.shoppingBar = nil;
        
        self.navigationItem.rightBarButtonItem = nil;
        
        [self.placeholderBackgroundView removeFromSuperview];
        self.placeholderBackgroundView = nil;
        
        if (self.placeholderBackgroundView == nil) {
            [self setupPlaceholderStatus];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"RefreshShoppingCart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"Logout" object:nil];
}

- (void)notification:(NSNotification *)noti {
    [self loadDta];
    
    if ([noti.object isEqualToString:@"pushToClassify"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = 1;
        });
    }
}

- (void)notification2:(NSNotification *)noti {
    [self.listMuArr removeAllObjects];
    
    [self.choiceListMuArr removeAllObjects];
    self.isSelectAll = NO;
    self.isEdit = NO;
    
    [self.shoppingBar removeFromSuperview];
    self.shoppingBar = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.placeholderBackgroundView removeFromSuperview];
    self.placeholderBackgroundView = nil;
    
    if (self.placeholderBackgroundView == nil) {
        [self setupPlaceholderStatus];
    }
    
    [self.tableView reloadData];
}

- (void)loadDta {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/lists" params:nil showLoading:NO successBlock:^(id response) {
        
        [self.tableView.mj_header endRefreshing];
        
        if ([response[@"status"] integerValue] == 0) {
            self.listMuArr = [NSArray yy_modelArrayWithClass:[VENShoppingCartModel class] json:response[@"data"][@"list"]].mutableCopy;

            if (self.listMuArr.count > 0) {
                
                [self.choiceListMuArr removeAllObjects];
                self.isSelectAll = NO;
                self.isEdit = NO;
                
                [self.shoppingBar removeFromSuperview];
                self.shoppingBar = nil;
                if (self.shoppingBar == nil) {
                    [self setupShoppingBar];
                }
                
                // 右上角 编辑按钮
                self.navigationItem.rightBarButtonItem = nil;
                [self setupEditButton];
                
                [self.placeholderBackgroundView removeFromSuperview];
                self.placeholderBackgroundView = nil;
                
            } else {
                
                [self.choiceListMuArr removeAllObjects];
                self.isSelectAll = NO;
                self.isEdit = NO;
                
                [self.shoppingBar removeFromSuperview];
                self.shoppingBar = nil;
                
                self.navigationItem.rightBarButtonItem = nil;
                
                [self.placeholderBackgroundView removeFromSuperview];
                self.placeholderBackgroundView = nil;
                
                if (self.placeholderBackgroundView == nil) {
                    [self setupPlaceholderStatus];
                }
            }
            
             [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listMuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENShoppingCartModel *model = self.listMuArr[indexPath.section];

    VENShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    
    cell.titleLabel.hidden = self.isEdit ? YES : NO;
    cell.numberLabel.hidden = self.isEdit ? YES : NO;
    cell.titleLabel.text = model.goods_name;
    cell.numberLabel.text = [NSString stringWithFormat:@"x%ld", (long)model.number];

    cell.plusButton.hidden = self.isEdit ? NO : YES;
    cell.plusButton.tag = 998 + indexPath.section;
    [cell.plusButton addTarget:self action:@selector(plusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.minusButton.hidden = self.isEdit ? NO : YES;
    cell.minusButton.tag = 998 + indexPath.section;
    [cell.minusButton addTarget:self action:@selector(minusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.deleteButton.hidden = self.isEdit ? NO : YES;
    cell.deleteButton.tag = 998 + indexPath.section;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.numberButton.hidden = self.isEdit ? NO : YES;
    [cell.numberButton setTitle:[NSString stringWithFormat:@"%ld", (long)model.number] forState:normal];

    cell.otherLabel.text = [NSString stringWithFormat:@"规格：%@", model.spec];
    cell.priceLabel.text = model.price_formatted;
    
    cell.choiceButton.tag = 998 + indexPath.section;
    [cell.choiceButton addTarget:self action:@selector(choiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.choiceButton.selected = model.isChoice == YES ? YES : NO;

    if (indexPath.section == 0) {
        [self.choiceButtonsMuArr removeAllObjects];
        [self.numberButtonsMuArr removeAllObjects];
    }

    [self.choiceButtonsMuArr addObject:cell.choiceButton];
    [self.numberButtonsMuArr addObject:cell.numberButton];
    
    return cell;
}

#pragma mark - 编辑 增加
- (void)plusButtonClick:(UIButton *)button {
    
    for (NSInteger i = 0; i < self.choiceButtonsMuArr.count; i++) {
        if (button.tag == self.choiceButtonsMuArr[i].tag) {
            VENShoppingCartModel *model = self.listMuArr[i];
            NSInteger tempNumber = model.number;
            
            NSDictionary *params = @{@"id" : model.shoppingCartID,
                                     @"number" : [NSString stringWithFormat:@"%ld", (long)tempNumber + 1]};
            
            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/modify" params:params showLoading:YES successBlock:^(id response) {
                
                if ([response[@"status"] integerValue] == 0) {
                    model.number++;
                    [self.numberButtonsMuArr[i] setTitle:[NSString stringWithFormat:@"%ld", (long)model.number] forState:normal];
                    [self computedPrice];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 编辑 减少
- (void)minusButtonClick:(UIButton *)button {
    
    for (NSInteger i = 0; i < self.choiceButtonsMuArr.count; i++) {
        if (button.tag == self.choiceButtonsMuArr[i].tag) {
            VENShoppingCartModel *model = self.listMuArr[i];
            NSInteger tempNumber = model.number;
            
            NSDictionary *params = @{@"id" : model.shoppingCartID,
                                     @"number" : [NSString stringWithFormat:@"%ld", (long)tempNumber - 1]};
            
            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/modify" params:params showLoading:YES successBlock:^(id response) {
                
                if ([response[@"status"] integerValue] == 0) {
                    model.number--;
                    [self.numberButtonsMuArr[i] setTitle:[NSString stringWithFormat:@"%ld", (long)model.number] forState:normal];
                    [self computedPrice];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 编辑 删除
- (void)deleteButtonClick:(UIButton *)button {
    
    for (NSInteger i = 0; i < self.choiceButtonsMuArr.count; i++) {
        
        if (button.tag == self.choiceButtonsMuArr[i].tag) {
            VENShoppingCartModel *model = self.listMuArr[i];
            
            NSDictionary *params = @{@"ids" : model.shoppingCartID};
            
            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/remove" params:params showLoading:YES successBlock:^(id response) {
                
                if ([response[@"status"] integerValue] == 0) {
                    
                    if (self.choiceListMuArr.count > 0) {
                        [self.choiceListMuArr removeObject:model];
                    }
                    
                    if (self.listMuArr.count > 0) {
                        [self.listMuArr removeObject:model];
                    }

                    if (self.choiceButtonsMuArr.count > 0) {
                        [self.choiceButtonsMuArr removeObjectAtIndex:i];
                    }
                    
                    if (self.numberButtonsMuArr.count > 0) {
                        [self.numberButtonsMuArr removeObjectAtIndex:i];
                    }
                    
                    [self computedPrice];
                    [self.tableView reloadData];
                    
                    if (self.listMuArr.count < 1) {
                        [self.shoppingBar removeFromSuperview];
                        self.shoppingBar = nil;
                        self.isEdit = NO;
                        self.navigationItem.rightBarButtonItem = nil;
                        [self loadDta];
                    }
                    
                    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/lists" params:nil showLoading:NO successBlock:^(id response) {
                        
                        if ([response[@"status"] integerValue] == 0) {
                            if ([response[@"data"][@"count"] integerValue] > 0) {
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", response[@"data"][@"count"]] forKey:@"RedDot"];
                                [self.tabBarController.tabBar.items[2] setBadgeValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"RedDot"]];
                            } else {
                                [self.tabBarController.tabBar.items[2] setBadgeValue:nil];
                            }
                        }
                        
                    } failureBlock:^(NSError *error) {
                        
                    }];
                }
                
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return lineView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.listMuArr.count - 1 ? 10 : 5;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 44 - statusNavHeight - tabBarHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.rowHeight = 100;
    [tableView registerNib:[UINib nibWithNibName:@"VENShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDta];
    }];
    
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//    }];
    
    _tableView = tableView;
}

#pragma mark - 编辑/完成
- (void)setupEditButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    _navigationRightButton = button;
}

- (void)editButtonClick {
    self.isEdit = self.isEdit == YES ? NO : YES;
    [self.navigationRightButton setTitle:self.isEdit ? @"完成" : @"编辑" forState:UIControlStateNormal];
    [self.payButton setTitle:self.isEdit ? [NSString stringWithFormat:@"删除(%lu)", (unsigned long)self.choiceListMuArr.count] : [NSString stringWithFormat:@"结算(%lu)", (unsigned long)self.choiceListMuArr.count] forState: UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark - 底部 toolBar
- (void)setupShoppingBar {
    UIView *shoppingBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - statusNavHeight - 44 - 49 - (tabBarHeight - 49), kMainScreenWidth, 44)];
    shoppingBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shoppingBar];
    
    UIButton *selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(-6, 0, 100, 44)];
    selectAllButton.backgroundColor = [UIColor whiteColor];
    [selectAllButton setImage:[UIImage imageNamed:@"icon_selecte_not"] forState:UIControlStateNormal];
    [selectAllButton setImage:[UIImage imageNamed:@"icon_selecte"] forState:UIControlStateSelected];
    [selectAllButton setTitle:@"   全选" forState:UIControlStateNormal];
    [selectAllButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [selectAllButton addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shoppingBar addSubview:selectAllButton];
    
    NSString *priceStr = @"0.00";
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 , 44 / 2 - 20 / 2, kMainScreenWidth - 220, 20)];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%@", priceStr]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD0021B) range:NSMakeRange(3, priceStr.length + 1)];
    priceLabel.attributedText = attributedStr;
    priceLabel.font = [UIFont systemFontOfSize:14.0f];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [shoppingBar addSubview:priceLabel];

    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 100, 0, 100, 44)];
    payButton.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [payButton setTitle:@"结算(0)" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [shoppingBar addSubview:payButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xE8E8E8);
    [shoppingBar addSubview:lineView];
    
    _shoppingBar = shoppingBar;
    _selectAllButton = selectAllButton;
    _priceLabel = priceLabel;
    _payButton = payButton;
}

#pragma mark - 结算 / 删除
- (void)payButtonClick {
    if (self.choiceListMuArr.count > 0) {
        
        NSMutableArray *tempMuArr = [NSMutableArray array];
        for (VENShoppingCartModel *model in self.choiceListMuArr) {
            [tempMuArr addObject:model.shoppingCartID];
            
        }
        
        NSDictionary *params = @{@"ids" : [tempMuArr componentsJoinedByString:@","]};
        
        if (self.isEdit == YES) {
            NSLog(@"删除");
            

            
            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/remove" params:params showLoading:YES successBlock:^(id response) {
                
                if ([response[@"status"] integerValue] == 0) {
                    
                    if (self.choiceListMuArr.count > 0) {
                        [self.choiceListMuArr removeAllObjects];
                    }
                    
                    if (self.listMuArr.count > 0) {
                        [self.listMuArr removeAllObjects];
                    }
                    
                    if (self.choiceButtonsMuArr.count > 0) {
                        [self.choiceButtonsMuArr removeAllObjects];
                    }
                    
                    if (self.numberButtonsMuArr.count > 0) {
                        [self.numberButtonsMuArr removeAllObjects];
                    }
                    
                    [self computedPrice];
                    [self.tableView reloadData];
                    
                    if (self.listMuArr.count < 1) {
                        [self.shoppingBar removeFromSuperview];
                        self.shoppingBar = nil;
                        self.isEdit = NO;
                        self.navigationItem.rightBarButtonItem = nil;
                        [self loadDta];
                    }
                    
                    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/lists" params:nil showLoading:NO successBlock:^(id response) {
                        
                        if ([response[@"status"] integerValue] == 0) {
                            if ([response[@"data"][@"count"] integerValue] > 0) {
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", response[@"data"][@"count"]] forKey:@"RedDot"];
                                [self.tabBarController.tabBar.items[2] setBadgeValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"RedDot"]];
                            } else {
                                [self.tabBarController.tabBar.items[2] setBadgeValue:nil];
                            }
                        }
                        
                    } failureBlock:^(NSError *error) {
                        
                    }];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
            
        } else {
            NSLog(@"结算");
            
            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/check" params:params showLoading:YES successBlock:^(id response) {
                
                if ([response[@"status"] integerValue] == 0) {
                    VENShoppingCartPlacingOrderViewController *vc = [[VENShoppingCartPlacingOrderViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 全选
- (void)selectAllButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    for (UIButton *choiceButton in self.choiceButtonsMuArr) {
        VENShoppingCartModel *model = self.listMuArr[choiceButton.tag - 998];
        
        if (button.selected == YES) {
            choiceButton.selected = YES;
            self.isSelectAll = YES;
            model.isChoice = YES;
            
            if (![self.choiceListMuArr containsObject:model]) {
                [self.choiceListMuArr addObject:model];
            }
        } else {
            choiceButton.selected = NO;
            self.isSelectAll = NO;
            model.isChoice = NO;
            
            [self.choiceListMuArr removeAllObjects];
        }
    }
    
    [self computedPrice];
}

#pragma mark - 单选 cell
- (void)choiceButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    VENShoppingCartModel *model = self.listMuArr[button.tag - 998];
    
    if (button.selected == YES) {
        [self.choiceListMuArr addObject:model];
        model.isChoice = YES;
        
        if (self.choiceListMuArr.count == self.listMuArr.count) {
            self.isSelectAll = YES;
            self.selectAllButton.selected = YES;
        }
        
    } else {
        [self.choiceListMuArr removeObject:model];
        model.isChoice = NO;
        
        if (self.choiceListMuArr.count != self.listMuArr.count) {
            self.isSelectAll = NO;
            self.selectAllButton.selected = NO;
        }
    }
    
    [self computedPrice];
}

#pragma mark - 计算价格
- (void)computedPrice {
    CGFloat totalPrice = 0;
    for (VENShoppingCartModel *model in self.choiceListMuArr) {
        CGFloat tempTotalPrice = model.price * model.number;
        totalPrice +=tempTotalPrice;
    }
    
    [self.payButton setTitle:self.isEdit ? [NSString stringWithFormat:@"删除(%lu)", (unsigned long)self.choiceListMuArr.count] : [NSString stringWithFormat:@"结算(%lu)", (unsigned long)self.choiceListMuArr.count] forState: UIControlStateNormal];

    self.payButton.backgroundColor = self.choiceListMuArr.count > 0 ? COLOR_THEME : UIColorFromRGB(0xCCCCCC);
    
    NSString *totalPriceStr = [NSString stringWithFormat:@"合计：¥%.2f", totalPrice];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalPriceStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD0021B) range:NSMakeRange(3, totalPriceStr.length - 3)];
    self.priceLabel.attributedText = attributedStr;
}

#pragma mark - 占位页面
- (void)setupPlaceholderStatus {
    
    CGFloat backgroundViewWidth = kMainScreenWidth - 64;
    UIView *placeholderBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(32, (kMainScreenHeight - statusNavHeight - tabBarHeight) / 2 - (81 + 19 + 20 + 30 + 40) / 2, kMainScreenWidth - 64, 81 + 19 + 20 + 30 + 40)];
    [self.view addSubview:placeholderBackgroundView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundViewWidth / 2 - 129 / 2, 0, 129, 81)];
    iconImageView.image = [UIImage imageNamed:@"icon_shopping_cart_empty"];
    [placeholderBackgroundView addSubview:iconImageView];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = @"购物车是空的哦";
    messageLabel.textColor = UIColorFromRGB(0xB2B2B2);
    messageLabel.font = [UIFont systemFontOfSize:16.0f];
    CGFloat messageLabelWidth = [self label:messageLabel setWidthToHeight:20];
    messageLabel.frame = CGRectMake(backgroundViewWidth / 2 - messageLabelWidth / 2, 81 + 19, messageLabelWidth, 20);
    [placeholderBackgroundView addSubview:messageLabel];
    
    UIButton *strollButton = [[UIButton alloc] initWithFrame:CGRectMake(backgroundViewWidth / 2 - 86 / 2, 81 + 19 + 20 + 30, 86, 40)];
    [strollButton setTitle:@"去逛逛" forState:UIControlStateNormal];
    [strollButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    strollButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    strollButton.layer.borderWidth = 1;
    strollButton.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    strollButton.layer.cornerRadius = 4;
    strollButton.layer.masksToBounds = YES;
    [strollButton addTarget:self action:@selector(strollButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [placeholderBackgroundView addSubview:strollButton];
    
    _placeholderBackgroundView = placeholderBackgroundView;
}

#pragma mark - 去逛逛
- (void)strollButtonClick {
    self.tabBarController.selectedIndex = 1;
}

- (CGFloat)label:(UILabel *)label setWidthToHeight:(CGFloat)Height {
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, Height)];
    return size.width;
}

- (NSMutableArray *)listMuArr {
    if (_listMuArr == nil) {
        _listMuArr = [NSMutableArray array];
    }
    return _listMuArr;
}

- (NSMutableArray *)choiceListMuArr {
    if (_choiceListMuArr == nil) {
        _choiceListMuArr = [NSMutableArray array];
    }
    return _choiceListMuArr;
}

- (NSMutableArray *)choiceButtonsMuArr {
    if (_choiceButtonsMuArr == nil) {
        _choiceButtonsMuArr = [NSMutableArray array];
    }
    return _choiceButtonsMuArr;
}

- (NSMutableArray *)numberButtonsMuArr {
    if (_numberButtonsMuArr == nil) {
        _numberButtonsMuArr = [NSMutableArray array];
    }
    return _numberButtonsMuArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
