//
//  VENCustomerManagementViewController.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/3/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENCustomerManagementViewController.h"
#import "VENCustomerManagementTableViewCell.h"
#import "VENCustomerManagementModel.h"
#import "VENCustomerManagementEditViewController.h"

@interface VENCustomerManagementViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENCustomerManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"客户管理";
    
    [self loadData];
    
    [self setupTableView];
    [self setupAddReceivingAddressButton];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"keyAccount/customers" params:nil showLoading:YES successBlock:^(id response) {
        
        self.dataArr = [NSArray yy_modelArrayWithClass:[VENCustomerManagementModel class] json:response[@"data"][@"lists"]].mutableCopy;
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCustomerManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENCustomerManagementModel *model = self.dataArr[indexPath.row];
    
    cell.nameLabel.text = model.username;
    cell.phoneLabel.text = model.mobile;
    cell.addressLabel.text = model.detail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENCustomerManagementEditViewController *vc = [[VENCustomerManagementEditViewController alloc] init];
    VENCustomerManagementModel *model = self.dataArr[indexPath.row];
    vc.isEdit = YES;
    vc.model = model;
    vc.block = ^(NSString *str) {
        [self loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - 48) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENCustomerManagementTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

- (void)setupAddReceivingAddressButton {
    UIButton *addReceivingAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - statusNavHeight - 48, kMainScreenWidth, 48)];
    addReceivingAddressButton.backgroundColor = COLOR_THEME;
    [addReceivingAddressButton setTitle:@"添加客户" forState:UIControlStateNormal];
    [addReceivingAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addReceivingAddressButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [addReceivingAddressButton addTarget:self action:@selector(addReceivingAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addReceivingAddressButton];
}

#pragma mark - 新增收货地址
- (void)addReceivingAddressButtonClick {
    VENCustomerManagementEditViewController *vc = [[VENCustomerManagementEditViewController alloc] init];
    vc.isEdit = NO;
    vc.block = ^(NSString *str) {
        [self loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
