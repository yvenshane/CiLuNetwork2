//
//  VENMyOrderAllOrdersViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/26.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOrderAllOrdersViewController.h"
#import "VENShoppingCartTableViewCell.h"
#import "VENMyOrderOrderDetailsViewController.h"
#import "VENMyOrderAllOrdersModel.h"
#import "VENShoppingCartPlacingOrderPaymentOrderViewController.h"
#import "VENMyOrderOrderDetailsOrderEvaluationViewController.h"

@interface VENMyOrderAllOrdersViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *responseMuArr;
@property (nonatomic, strong) NSMutableArray *listsMuArr;
@property (nonatomic, assign) NSInteger page;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMyOrderAllOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"RefreshMyOrder" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    
    NSDictionary *dict = noti.object;
    NSInteger index = [dict[@"index"] integerValue];
    VENMyOrderAllOrdersModel *model = self.listsMuArr[index];
    
    model.status = dict[@"status"];
    model.status_text = dict[@"status_text"];
    
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)loadDataWithPage:(NSString *)page {
    
    NSDictionary *params = @{@"status" : @"0",
                             @"page" : page};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"order/lists" params:params showLoading:YES successBlock:^(id response) {
        if ([response[@"status"] integerValue] == 0) {
            
            if ([page integerValue] == 1) {
                [self.tableView.mj_header endRefreshing];
                
                self.responseMuArr = [NSMutableArray arrayWithArray:response[@"data"][@"lists"]];
                self.listsMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENMyOrderAllOrdersModel class] json:response[@"data"][@"lists"]]];
                self.page = 1;
            } else {
                [self.tableView.mj_footer endRefreshing];
                
                [self.responseMuArr addObjectsFromArray:response[@"data"][@"lists"]];
                [self.listsMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENMyOrderAllOrdersModel class] json:response[@"data"][@"lists"]]];
            }
            
            if ([response[@"data"][@"hasNext"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listsMuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[section];
    return model.goods_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.priceLabel.textColor = UIColorFromRGB(0x1A1A1A);
    cell.iconImageViewLayoutConstraint.constant = -33.0f;
    cell.choiceButton.hidden = YES;
    
    NSDictionary *dict = self.responseMuArr[indexPath.section][@"goods_list"][indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"goods_thumb"]]];
    cell.titleLabel.text = dict[@"goods_name"];
    cell.otherLabel.text = [NSString stringWithFormat:@"规格：%@", dict[@"spec"]];
    cell.priceLabel.text = dict[@"goods_price"];
    cell.numberLabel.text = [NSString stringWithFormat:@"x%@", dict[@"number"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[indexPath.section];
    
    VENMyOrderOrderDetailsViewController *vc = [[VENMyOrderOrderDetailsViewController alloc] init];
    vc.order_id = model.order_id;
    vc.isMyOrder = YES;
    vc.index = indexPath.section;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [headerView addSubview:lineView];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = model.add_time;
    dateLabel.textColor = UIColorFromRGB(0xB2B2B2);
    dateLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width = [self label:dateLabel setWidthToHeight:20.0f];
    dateLabel.frame = CGRectMake(15, 44 / 2 - 20 / 2 + 10, width, 20);
    [headerView addSubview:dateLabel];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = model.status_text;
    statusLabel.textColor = UIColorFromRGB(0xC7974F);
    statusLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width2 = [self label:statusLabel setWidthToHeight:20.0f];
    statusLabel.frame = CGRectMake(kMainScreenWidth - width2 - 15, 44 / 2 - 20 / 2 + 10, width, 20);
    [headerView addSubview:statusLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 54, kMainScreenWidth - 15, 1)];
    lineView2.backgroundColor = UIColorFromRGB(0xE8E8E8);
    [headerView addSubview:lineView2];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[section];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kMainScreenWidth - 15, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xE8E8E8);
    [footerView addSubview:lineView];
    
    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = [NSString stringWithFormat:@"共%@件商品 实付%@", model.goods_count, model.price];
    otherLabel.textColor = UIColorFromRGB(0x333333);
    otherLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width = [self label:otherLabel setWidthToHeight:20.0f];
    otherLabel.frame = CGRectMake(kMainScreenWidth - width - 15, 44 / 2 - 20 / 2, width, 20);
    [footerView addSubview:otherLabel];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 76 * 2 - 15 - 10, 44, 76, 27)];
    leftButton.tag = section;
    [leftButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    leftButton.layer.cornerRadius = 2.0f;
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.borderWidth = 1.0f;
    leftButton.layer.borderColor = UIColorFromRGB(0x979797).CGColor;
    [footerView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 76 - 15, 44, 76, 27)];
    rightButton.tag = section;
    rightButton.backgroundColor = UIColorFromRGB(0xC7974F);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    rightButton.layer.cornerRadius = 2.0f;
    rightButton.layer.masksToBounds = YES;
    [footerView addSubview:rightButton];
    
    if ([model.status integerValue] == 2 || [model.status integerValue] == 10 || [model.status integerValue] == 20) {
        leftButton.hidden = YES;
        rightButton.hidden = YES;
    } else {
        
        rightButton.hidden = NO;
        
        if ([model.status integerValue] == 1) {
            leftButton.hidden = NO;
            [leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [rightButton setTitle:@"去支付" forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        } else  {
            leftButton.hidden = YES;
            
            if ([model.status integerValue] == 3) {
                [rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
                [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [rightButton setTitle:@"评价" forState:UIControlStateNormal];
                [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return footerView;
}

#pragma mark - 取消订单
- (void)leftButtonClick:(UIButton *)button {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[button.tag];
    
    NSDictionary *params = @{@"order_id" : model.order_id,
                             @"status" : @"1"};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"order/setOrderStatus" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            model.status = @"10";
            model.status_text = @"已取消";
            
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 去支付 / 确认收货 / 评价
- (void)rightButtonClick:(UIButton *)button {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[button.tag];
    
    if ([button.titleLabel.text isEqualToString:@"去支付"]) {
        
        NSDictionary *params = @{@"order_id" : model.order_id};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"order/continuePay" params:params showLoading:YES successBlock:^(id response) {
            
            if ([response[@"response"] integerValue] == 0) {
                VENShoppingCartPlacingOrderPaymentOrderViewController *vc = [[VENShoppingCartPlacingOrderPaymentOrderViewController alloc] init];
                vc.dataDict = response[@"data"];
                vc.isMyOrder = YES;
                vc.index = button.tag;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    } else if ([button.titleLabel.text isEqualToString:@"确认收货"]) {
        
        NSDictionary *params = @{@"order_id" : model.order_id,
                                 @"status" : @"2"};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"order/setOrderStatus" params:params showLoading:YES successBlock:^(id response) {
            
            if ([response[@"status"] integerValue] == 0) {
                model.status = @"30";
                model.status_text = @"待评价";
                
                [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GoodsReceived" object:@"All"];
            }
            
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    } else if ([button.titleLabel.text isEqualToString:@"评价"]) {
        VENMyOrderOrderDetailsOrderEvaluationViewController *vc = [[VENMyOrderOrderDetailsOrderEvaluationViewController alloc] init];
        vc.block = ^(NSString *str) {
            // 暂无操作 由通知改变
        };
        vc.order_id = model.order_id;
        vc.index = button.tag;
        vc.pushFrom = @"列表页";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[section];
    
    if ([model.status integerValue] == 2 || [model.status integerValue] == 10 || [model.status integerValue] == 20) {
        return 44;
    } else {
        return 85;
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - tabBarHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENShoppingCartTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];

    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithPage:@"1"];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _tableView = tableView;
}

- (CGFloat)label:(UILabel *)label setWidthToHeight:(CGFloat)Height {
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, Height)];
    return size.width;
}

- (NSMutableArray *)responseMuArr {
    if (_responseMuArr == nil) {
        _responseMuArr = [NSMutableArray array];
    }
    return _responseMuArr;
}

- (NSMutableArray *)listsMuArr {
    if (_listsMuArr == nil) {
        _listsMuArr = [NSMutableArray array];
    }
    return _listsMuArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
