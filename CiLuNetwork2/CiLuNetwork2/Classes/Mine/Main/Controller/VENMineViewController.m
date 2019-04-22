//
//  VENMineViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/3.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMineViewController.h"
#import "VENMineTableViewCellStyleOne.h"
#import "VENMineTableViewCellStyleTwo.h"
#import "VENMineTableViewCellStyleThree.h"
#import "VENLoginViewController.h"

#import "VENPersonalSettingsViewController.h"
#import "VENMyOrderViewController.h"
#import "VENMyBalanceViewController.h"
#import "VENMyPointsViewController.h"
#import "VENMyCommissionViewController.h"
#import "VENMyTeamViewController.h"
#import "VENShoppingCartPlacingOrderReceivingAddressViewController.h"
#import "VENMyCollectionViewController.h"
#import "VENMyEvaluationViewController.h"
#import "VENCustomerManagementViewController.h"
#import "VENSalesManagementViewController.h"

#import "VENMineModel.h"

@interface VENMineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;
@property (nonatomic, strong) VENMineModel *model;
@property (nonatomic, strong) VENMineModel *order_infoModel;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier2 = @"cellIdentifier2";
static NSString *cellIdentifier3 = @"cellIdentifier3";
@implementation VENMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[VENBadgeValueManager sharedManager] setupRedDotWithTabBar:self.tabBarController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self setupSettingButton];
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"RefreshMinePage" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"home/index" params:nil showLoading:YES successBlock:^(id response) {
        
        [self.tableView.mj_header endRefreshing];
        
        if ([response[@"status"] integerValue] == 0) {
        
            self.model = [VENMineModel yy_modelWithJSON:response[@"data"]];
            self.order_infoModel = [VENMineModel yy_modelWithJSON:response[@"data"][@"order_info"]];
            
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.model.is_key_account integerValue] == 1 ? 5 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return [self.model.is_key_account integerValue] == 1 ? 2 : 3;
    } else if (section == 4) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma mark - 头部 登录注册
    if (indexPath.section == 0) {
        VENMineTableViewCellStyleThree *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        
        [cell.iconButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.avatar]]] forState:UIControlStateNormal];
        [cell.nameButton setTitle:self.model.name forState:UIControlStateNormal];
        [cell.otherButton setTitle:[NSString stringWithFormat:@"   %@   ", self.model.tag_name] forState:UIControlStateNormal];
        
        [cell.nameButton addTarget:self action:@selector(nameButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[VENUserStatusManager sharedManager] isLogin]) {
            cell.nameButtonCenterYLayoutConstraint.constant = -14;
            cell.otherButton.hidden = NO;
        } else {
            cell.nameButtonCenterYLayoutConstraint.constant = 0;
            cell.otherButton.hidden = YES;
        }
        
        cell.separatorInset = UIEdgeInsetsMake(0, kMainScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
#pragma mark - 我的订单
    } else if (indexPath.section == 1) {
        VENMineTableViewCellStyleTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.order_infoModel.shipping_count integerValue] > 0) {
            cell.shippingCountLabel.hidden = NO;
            cell.shippingCountLabel.text = self.order_infoModel.shipping_count;
        } else {
            cell.shippingCountLabel.hidden = YES;
        }
        
        if ([self.order_infoModel.receiving_count integerValue] > 0) {
            cell.receivingCountLabel.hidden = NO;
            cell.receivingCountLabel.text = self.order_infoModel.receiving_count;
        } else {
            cell.receivingCountLabel.hidden = YES;
        }
        
        if ([self.order_infoModel.comment_count integerValue] > 0) {
            cell.commentCountLabel.hidden = NO;
            cell.commentCountLabel.text = self.order_infoModel.comment_count;
        } else {
            cell.commentCountLabel.hidden = YES;
        }
        
        [cell.waitingForShipmentButton addTarget:self action:@selector(waitingForShipmentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.waitingForReceivingButton addTarget:self action:@selector(waitingForReceivingButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.waitingForEvaluationButton addTarget:self action:@selector(waitingForEvaluationButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENMineTableViewCellStyleOne *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 2) {
            cell.leftLabel.text = @"我的余额";
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = [NSString stringWithFormat:@"%@元", self.model.balance];
        } else if (indexPath.section == 3) {
            cell.rightLabel.hidden = YES;
            
            if ([self.model.is_key_account integerValue] == 1) {
                if (indexPath.row == 0) {
                    cell.leftLabel.text = @"客户管理";
                } else {
                    cell.leftLabel.text = @"销售管理";
                }
            } else {
                if (indexPath.row == 0) {
                    cell.leftLabel.text = @"地址管理";
                } else if (indexPath.row == 1) {
                    cell.leftLabel.text = @"我的收藏";
                } else {
                    cell.leftLabel.text = @"我的评价";
                }
            }
        } else {
            cell.rightLabel.hidden = YES;
            
            if (indexPath.row == 0) {
                cell.leftLabel.text = @"地址管理";
            } else if (indexPath.row == 1) {
                cell.leftLabel.text = @"我的收藏";
            } else {
                cell.leftLabel.text = @"我的评价";
            }
        }
        return cell;
    }
}

// 登录注册 /
- (void)nameButtonClick {
    if (![[VENUserStatusManager sharedManager] isLogin]) {
        [self pushToLoginView];
    }
}

- (void)waitingForShipmentButtonClick {
    NSLog(@"待发货");
    
    if ([[VENUserStatusManager sharedManager] isLogin]) {
        VENMyOrderViewController *vc = [[VENMyOrderViewController alloc] init];
        vc.pushIndexPath = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self pushToLoginView];
    }
}

- (void)waitingForReceivingButtonClick {
    NSLog(@"待收货");
    
    if ([[VENUserStatusManager sharedManager] isLogin]) {
        VENMyOrderViewController *vc = [[VENMyOrderViewController alloc] init];
        vc.pushIndexPath = 2;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushToLoginView];
        });
    }
}

- (void)waitingForEvaluationButtonClick {
    NSLog(@"待评价");
    
    if ([[VENUserStatusManager sharedManager] isLogin]) {
        VENMyOrderViewController *vc = [[VENMyOrderViewController alloc] init];
        vc.pushIndexPath = 3;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {

    }
}

- (void)pushToLoginView {
    VENLoginViewController *vc = [[VENLoginViewController alloc] init];
    vc.block = ^(NSString *str) {
        [self.tableView.mj_header beginRefreshing];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[VENUserStatusManager sharedManager] isLogin]) {
       if (indexPath.section == 1) {
            NSLog(@"全部订单");
            
            VENMyOrderViewController *vc = [[VENMyOrderViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.section == 2) {
            NSLog(@"我的余额");
            
            VENMyBalanceViewController *vc = [[VENMyBalanceViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.section == 3) {
            if ( [self.model.is_key_account integerValue] == 1) {
                if (indexPath.row == 0) {
                    NSLog(@"客户管理");
                    
                    VENCustomerManagementViewController *vc = [[VENCustomerManagementViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    NSLog(@"销售管理");
                    
                    VENSalesManagementViewController *vc = [[VENSalesManagementViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                if (indexPath.row == 0) {
                    NSLog(@"地址管理");
                    
                    VENShoppingCartPlacingOrderReceivingAddressViewController *vc = [[VENShoppingCartPlacingOrderReceivingAddressViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.isMinePage = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 1) {
                    NSLog(@"我的收藏");
                    
                    VENMyCollectionViewController *vc = [[VENMyCollectionViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (indexPath.row == 2) {
                    NSLog(@"我的评价");
                    
                    VENMyEvaluationViewController *vc = [[VENMyEvaluationViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        } else if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                NSLog(@"地址管理");
                
                VENShoppingCartPlacingOrderReceivingAddressViewController *vc = [[VENShoppingCartPlacingOrderReceivingAddressViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.isMinePage = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 1) {
                NSLog(@"我的收藏");
                
                VENMyCollectionViewController *vc = [[VENMyCollectionViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (indexPath.row == 2) {
                NSLog(@"我的评价");
                
                VENMyEvaluationViewController *vc = [[VENMyEvaluationViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        if (indexPath.section != 0) {
            [self pushToLoginView];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 102;
    } else if (indexPath.section == 1) {
        return 111;
    } else {
        return 48;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 个人设置
- (void)settingButtonClick {
    if ([[VENUserStatusManager sharedManager] isLogin]) {
        VENPersonalSettingsViewController *vc = [[VENPersonalSettingsViewController alloc] init];
        vc.isKeyAccount = [self.model.is_key_account integerValue];
        vc.hidesBottomBarWhenPushed = YES;
        vc.block = ^(NSString * str) {
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self pushToLoginView];
    }
}

- (void)setupSettingButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"icon_install"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - tabBarHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCellStyleOne" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCellStyleTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCellStyleThree" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    
    _tableView = tableView;
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
