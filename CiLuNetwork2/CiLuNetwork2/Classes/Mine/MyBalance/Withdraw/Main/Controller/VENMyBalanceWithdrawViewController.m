//
//  VENMyBalanceWithdrawViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyBalanceWithdrawViewController.h"
#import "VENMyBalanceWithdrawTableViewCell.h"
#import "VENMyBalanceWithdrawTableViewCell2.h"
#import "VENMyBalanceAddAccountViewController.h"
#import "VENMyBalanceWithdrawModel.h"

@interface VENMyBalanceWithdrawViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSArray *account_listArr;

@property (nonatomic, copy) NSString *type;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier2 = @"cellIdentifier2";
@implementation VENMyBalanceWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"提现";
    
    [self loadData];
    [self setupTableView];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"balance/preWithdraw" params:nil showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            self.balance = response[@"data"][@"balance"];
            self.account_listArr = [NSArray yy_modelArrayWithClass:[VENMyBalanceWithdrawModel class] json:response[@"data"][@"account_list"]];
            
            VENMyBalanceWithdrawModel *model = self.account_listArr[0];
            model.isChoise = YES;
            self.type = model.type;
            
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.account_listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VENMyBalanceWithdrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.priceLabel.text = [NSString stringWithFormat:@"可提现金额：¥%@", self.balance];
        cell.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        // 全部提现
        [cell.allWithdrawButton addTarget:self action:@selector(allWithdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENMyBalanceWithdrawTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        VENMyBalanceWithdrawModel *model = self.account_listArr[indexPath.row];
        
        cell.leftLabel.text = model.name;
        
        if ([[VENClassEmptyManager sharedManager] isEmptyString:model.username]) {
            cell.rightLabel.text = @"未设置";
            cell.rightLabel.textColor = UIColorFromRGB(0xB2B2B2);
        } else {
            cell.rightLabel.text = model.username;
            cell.rightLabel.textColor = [UIColor blackColor];
        }
        
        cell.choiceButton.tag = indexPath.row;
        cell.choiceButton.selected = model.isChoise;
        [cell.choiceButton addTarget:self action:@selector(choiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)choiceButtonClick:(UIButton *)button {
    for (VENMyBalanceWithdrawModel *model in self.account_listArr) {
        model.isChoise = NO;
    }
    
    VENMyBalanceWithdrawModel *model = self.account_listArr[button.tag];
    model.isChoise = YES;
    self.type = model.type;
    
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        VENMyBalanceWithdrawModel *model = self.account_listArr[indexPath.row];
        
        VENMyBalanceAddAccountViewController *vc = [[VENMyBalanceAddAccountViewController alloc] init];
        vc.block = ^(NSString *name) {
            [self loadData];
        };
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 88 + 90 : 54;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENMyBalanceWithdrawTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENMyBalanceWithdrawTableViewCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.view addSubview:tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48 + 31 + 37)];
    tableView.tableFooterView = footerView;
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 31, kMainScreenWidth - 30, 48)];
    [confirmButton setTitle:@"确定提现" forState:UIControlStateNormal];
    confirmButton.backgroundColor = UIColorFromRGB(0xC7974F);
    confirmButton.layer.cornerRadius = 4.0f;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 31 + 48 + 20, kMainScreenWidth - 30, 17)];
    reminderLabel.text = @"线上提现线下打款，具体到账时间请耐心等待";
    reminderLabel.font = [UIFont systemFontOfSize:14.0f];
    reminderLabel.textColor = UIColorFromRGB(0x999999);
    [footerView addSubview:reminderLabel];
    
    _tableView = tableView;
}

- (void)confirmButtonClick {
    VENMyBalanceWithdrawTableViewCell *cell = (VENMyBalanceWithdrawTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell.priceTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入提现金额"];
        return;
    }
    
    NSDictionary *params = @{@"amount" : cell.priceTextField.text,
                             @"type" : self.type};

    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"balance/withdraw" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            [self loadData];
            self.block(@"");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMinePage" object:nil];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)allWithdrawButtonClick {
    VENMyBalanceWithdrawTableViewCell *cell = (VENMyBalanceWithdrawTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.priceTextField.text = [NSString stringWithFormat:@"%@", self.balance];
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
