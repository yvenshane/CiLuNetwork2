//
//  VENMyBalanceAddAccountViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/2.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyBalanceAddAccountViewController.h"
#import "VENMyBalanceAddAccountTableViewCell.h"
#import "VENMyBalanceWithdrawModel.h"

@interface VENMyBalanceAddAccountViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMyBalanceAddAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [self.model.type integerValue] == 1 ? @"添加支付宝账号" : @"添加银行卡";
    
    [self setupTableView];
    [self setupSaveButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.type integerValue] == 1 ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMyBalanceAddAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rightTextField.keyboardType = UIKeyboardTypeDefault;
    
    if ([self.model.type integerValue] == 1) {
        cell.leftLabel.text = indexPath.row == 0 ? @"姓名" : @"支付宝账号";
        cell.rightTextField.placeholder = indexPath.row == 0 ? @"请填写真实姓名" : @"请填写支付宝账号";
        cell.rightTextField.userInteractionEnabled = YES;
        cell.rightImageView.hidden = YES;
        
        cell.rightTextField.text = indexPath.row == 0 ? self.model.username : self.model.account;
    } else {
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"开户行";
            cell.rightTextField.placeholder = @"请填写开户行";
            cell.rightTextField.userInteractionEnabled = YES;
            cell.rightImageView.hidden = YES;
            cell.rightTextField.text = self.model.company;
        } else if (indexPath.row == 1) {
            cell.leftLabel.text = @"银行卡号";
            cell.rightTextField.placeholder = @"请填写银行卡号";
            cell.rightTextField.userInteractionEnabled = YES;
            cell.rightImageView.hidden = YES;
            cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.rightTextField.text = self.model.account;
        } else {
            cell.leftLabel.text = @"开户人姓名";
            cell.rightTextField.placeholder = @"请填写开户人姓名";
            cell.rightTextField.userInteractionEnabled = YES;
            cell.rightImageView.hidden = YES;
            cell.rightTextField.text = self.model.username;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENMyBalanceAddAccountTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

- (void)setupSaveButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)saveButtonClick {
    
    VENMyBalanceAddAccountTableViewCell *cell = (VENMyBalanceAddAccountTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    VENMyBalanceAddAccountTableViewCell *cell2 = (VENMyBalanceAddAccountTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    VENMyBalanceAddAccountTableViewCell *cell3 = (VENMyBalanceAddAccountTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell.rightTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:[self.model.type integerValue] == 1 ? @"请填写真实姓名" : @"请填写开户行"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:cell2.rightTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:[self.model.type integerValue] == 1 ? @"请填写支付宝账号" : @"请填写银行卡号"];
        return;
    }
    
    if ([self.model.type integerValue] != 1) {
        if ([[VENClassEmptyManager sharedManager] isEmptyString:cell3.rightTextField.text]) {
            [[VENMBProgressHUDManager sharedManager] showText:@"请填写开户人姓名"];
            return;
        }
    }
    
    NSDictionary *params = @{};

    if ([self.model.type integerValue] == 1) {
        params = @{@"type" : self.model.type,
                   @"company" : @"",
                   @"account" : cell2.rightTextField.text,
                   @"username" : cell.rightTextField.text};
    } else {
        params = @{@"type" : self.model.type,
                   @"company" : cell.rightTextField.text,
                   @"account" : cell2.rightTextField.text,
                   @"username" : cell3.rightTextField.text};
    }

    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"balance/account" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            self.block(@"");
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failureBlock:^(NSError *error) {

    }];
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
