//
//  VENShoppingCartPlacingOrderPaymentOrderViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/25.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENShoppingCartPlacingOrderPaymentOrderViewController.h"
#import "VENShoppingCartPlacingOrderPaymentOrderTableViewCell.h"
#import "VENShoppingCartPlacingOrderSuccessViewController.h"
#import "VENShoppingCartPlacingOrderPaymentOrderModel.h"
#import "VENShoppingCartPlacingOrderPaymentOrderPayTypeModel.h"
//#import "UPPaymentControl.h"

@interface VENShoppingCartPlacingOrderPaymentOrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VENShoppingCartPlacingOrderPaymentOrderModel *model;
@property (nonatomic, copy) NSArray *pay_typeArr;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isFirst2;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENShoppingCartPlacingOrderPaymentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"支付订单";
    
    [self setupNavigationItemLeftBarButtonItem];
    [self handleData];
    
#pragma mark - 微信&支付宝 回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"BALANCE_RESULTDIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"ALIPAY_RESULTDIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"WX_RESULTDIC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"UNIONPAY_RESULTDIC" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    VENShoppingCartPlacingOrderSuccessViewController *vc = [[VENShoppingCartPlacingOrderSuccessViewController alloc] init];
    vc.order_id = self.model.order_id;
    vc.isMyOrder = self.isMyOrder;
    vc.isMyOrderDetail = self.isMyOrderDetail;
    vc.index = self.index;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleData {
    self.model = [VENShoppingCartPlacingOrderPaymentOrderModel yy_modelWithJSON:self.dataDict];
    self.pay_typeArr = [NSArray yy_modelArrayWithClass:[VENShoppingCartPlacingOrderPaymentOrderPayTypeModel class] json:self.dataDict[@"pay_type"]];
    
    [self setupTableView];
    [self setupBottomToolBarButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pay_typeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENShoppingCartPlacingOrderPaymentOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENShoppingCartPlacingOrderPaymentOrderPayTypeModel *model = self.pay_typeArr[indexPath.row];
    
    [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:model.price]) {
        cell.titleLabel.text = model.name;
        cell.errorLabel.hidden = YES;
        
        if (self.isFirst == NO) {
            if ([self.model.is_balance_pay integerValue] == 0) {
                if (indexPath.row == 0) {
                    model.isChoice = YES;
                    
                    self.isFirst = YES;
                }
            }
        }

    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"余额支付%@", model.price]];
        [attributedString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xCCCCCC)} range:NSMakeRange(4, attributedString.length - 4)];
        cell.titleLabel.attributedText = attributedString;
        
        cell.errorLabel.hidden = [[VENClassEmptyManager sharedManager] isEmptyString:model.tip] ? YES : NO;
        cell.errorLabel.text = model.tip;
        
        
        if (self.isFirst == NO) {
            if ([self.model.is_balance_pay integerValue] == 1) {
                model.isChoice = YES;
                
                self.isFirst = YES;
            }
        }
    }
    
    cell.choiceButton.selected = model.isChoice;
    cell.choiceButton.tag = indexPath.row;
    [cell.choiceButton addTarget:self action:@selector(choiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)choiceButtonClick:(UIButton *)button {
    VENShoppingCartPlacingOrderPaymentOrderPayTypeModel *model = self.pay_typeArr[button.tag];
    
    if ([self.model.is_balance_pay integerValue] == 0) {
        if ([[VENClassEmptyManager sharedManager] isEmptyString:model.price]) {
            button.userInteractionEnabled = YES;
        } else {
            button.userInteractionEnabled = NO;
            return;
        }
    } else {
        button.userInteractionEnabled = YES;
    }

    for (VENShoppingCartPlacingOrderPaymentOrderPayTypeModel *model1 in self.pay_typeArr) {
        model1.isChoice = NO;
        
    }
    
    model.isChoice = YES;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENShoppingCartPlacingOrderPaymentOrderPayTypeModel *model = self.pay_typeArr[indexPath.row];
    return [[VENClassEmptyManager sharedManager] isEmptyString:model.tip] ? 54 : 70;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - 48) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENShoppingCartPlacingOrderPaymentOrderTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    // 分割线
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kMainScreenWidth, 17)];
    titleLabel.text = @"订单总金额";
    titleLabel.textColor = UIColorFromRGB(0x999999);
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 + 15 + 15, kMainScreenWidth, 24)];
    priceLabel.textColor = UIColorFromRGB(0x1A1A1A);
    priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.0f];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.model.total_price_formatted];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0f]} range:NSMakeRange(0, 1)];
    priceLabel.attributedText = attributedString;
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:priceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kMainScreenWidth, 10)];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [headerView addSubview:lineView];
    
    _tableView = tableView;
}

- (void)setupBottomToolBarButton {
    UIButton *bottomToolBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 48 - statusNavHeight, kMainScreenWidth, 48)];
    bottomToolBarButton.backgroundColor = COLOR_THEME;
    bottomToolBarButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    bottomToolBarButton.titleLabel.textColor = [UIColor whiteColor];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"确认支付%@", self.model.total_price_formatted]];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0f]} range:NSMakeRange(5, attributedString.length - 5)];
    [bottomToolBarButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [bottomToolBarButton addTarget:self action:@selector(bottomToolBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomToolBarButton];
}

#pragma mark - 确认支付
- (void)bottomToolBarButtonClick {
    
//    NSString *type = @"";
//    for (VENShoppingCartPlacingOrderPaymentOrderPayTypeModel *model in self.pay_typeArr) {
//        if (model.isChoice == YES) {
//            type = model.payID;
//        }
//    }
//    
//    NSDictionary *params = @{@"type" : type,
//                             @"order_id" : self.model.order_id};
//    
//    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"order/pay" params:params showLoading:YES successBlock:^(id response) {
//        
//        if ([response[@"status"] integerValue] == 0) {
//            
//            if ([type isEqualToString:@"1"]) { // 余额支付
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"BALANCE_RESULTDIC" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMinePage" object:nil];
//                
//            } else if ([type isEqualToString:@"2"]) { // 支付宝
//                //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//                NSString *appScheme = @"CiluNetworkAlipay";
//                
//                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//                NSString *orderString = response[@"data"][@"sign_data"][@"sign"];
//                
//                // NOTE: 调用支付结果开始支付
//                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                    NSLog(@"reslut = %@",resultDic);
//                }];
//            } else if ([type isEqualToString:@"3"]) { // 微信支付
//                if (WXApi.isWXAppInstalled) {
//                    if (WXApi.isWXAppSupportApi) {
//                        PayReq *request = [[PayReq alloc] init];
//                        request.partnerId = response[@"data"][@"sign_data"][@"partnerid"];
//                        request.prepayId = response[@"data"][@"sign_data"][@"prepayid"];
//                        request.package = response[@"data"][@"sign_data"][@"package"];
//                        request.nonceStr = response[@"data"][@"sign_data"][@"noncestr"];
//                        request.timeStamp = [response[@"data"][@"sign_data"][@"timestamp"] intValue];
//                        request.sign= response[@"data"][@"sign_data"][@"sign"];
//                        [WXApi sendReq:request];
//                    } else {
//                        [[VENMBProgressHUDManager sharedManager] showText:@"请升级微信至最新版本！"];
//                    }
//                } else {
//                    [[VENMBProgressHUDManager sharedManager] showText:@"请安装微信客户端"];
//                }
//            } else if ([type isEqualToString:@"4"]) { // 银联支付
//                NSString *tn = response[@"data"][@"sign_data"][@"sign"];
//                
//                if (![[VENClassEmptyManager sharedManager] isEmptyString:tn]) {
//                    [[UPPaymentControl defaultControl]startPay:tn
//                                                    fromScheme:@"898340150460595"
//                                                          mode:@"00" // 生产环境:00 开发环境:01
//                                                viewController:self];
//                }
//            }
//        }
//        
//    } failureBlock:^(NSError *error) {
//        
//    }];
}

- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)backButtonClick {
    if (self.isMyOrder) {
        // 防止返回手势失效
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
