//
//  VENMyBalanceViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyBalanceViewController.h"
#import "VENMyBalanceHeaderViewTableViewCell.h"
#import "VENMyBalanceTableViewCell.h"

#import "VENMyBalanceRechargeViewController.h"
#import "VENMyBalanceWithdrawViewController.h"
#import "VENMyBalanceModel.h"

@interface VENMyBalanceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *total_balance;
@property (nonatomic, strong) NSMutableArray *listsMuArr;
@property (nonatomic, assign) NSInteger page;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier2 = @"cellIdentifier2";
@implementation VENMyBalanceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的余额";
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataWithPage:(NSString *)page {
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"balance/info" params:@{@"page" : page} showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            
            if ([page integerValue] == 1) {
                [self.tableView.mj_header endRefreshing];
                
                self.total_balance = response[@"data"][@"total_balance"];
                self.listsMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENMyBalanceModel class] json:response[@"data"][@"lists"]]];
                self.page = 1;
            } else {
                [self.tableView.mj_footer endRefreshing];
                
                [self.listsMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENMyBalanceModel class] json:response[@"data"][@"lists"]]];
            }

            if ([response[@"data"][@"hasNext"] integerValue] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.listsMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VENMyBalanceHeaderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.priceLabel.text = self.total_balance;
        
        [cell.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENMyBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        VENMyBalanceModel *model = self.listsMuArr[indexPath.row];
        
        cell.topLabel.text = model.action_name;
        cell.bottomLabel.text = model.add_time;
        cell.rightLabel.text = model.balance;
        
        return cell;
    }
}

- (void)leftButtonClick {
    NSLog(@"充值");

    VENMyBalanceRechargeViewController *vc = [[VENMyBalanceRechargeViewController alloc] init];
    vc.block = ^(NSString *str) {
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightButtonClick {
    NSLog(@"提现");
    
    VENMyBalanceWithdrawViewController *vc = [[VENMyBalanceWithdrawViewController alloc] init];
    vc.block = ^(NSString *str) {
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 192 : 64;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENMyBalanceTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENMyBalanceHeaderViewTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.view addSubview:tableView];

    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithPage:@"1"];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _tableView = tableView;
}

- (NSMutableArray *)listsMuArr {
    if (_listsMuArr == nil) {
        _listsMuArr = [NSMutableArray array];
    }
    return _listsMuArr;
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
