//
//  VENShoppingCartPlacingOrderReceivingAddressViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENShoppingCartPlacingOrderReceivingAddressViewController.h"
#import "VENShoppingCartPlacingOrderReceivingAddressTableViewCell.h"
#import "VENShoppingCartPlacingOrderAddReceivingAddressViewController.h"
#import "VENShoppingCartPlacingOrderReceivingAddressModel.h"

@interface VENShoppingCartPlacingOrderReceivingAddressViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isManage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *navigationRightButton;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENShoppingCartPlacingOrderReceivingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"收货地址";
    
    [self loadData];
    
    [self setupTableView];
    [self setupManageButton];
    [self setupAddReceivingAddressButton];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"address/lists" params:nil showLoading:YES successBlock:^(id response) {
        
        self.dataArr = [NSArray yy_modelArrayWithClass:[VENShoppingCartPlacingOrderReceivingAddressModel class] json:response[@"data"][@"lists"]].mutableCopy;
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENShoppingCartPlacingOrderReceivingAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENShoppingCartPlacingOrderReceivingAddressModel *model = self.dataArr[indexPath.row];
    
    cell.nameLabel.text = model.username;
    cell.phoneLabel.text = model.mobile;
    cell.addressLabel.text = model.detail;
    cell.leftLabel.hidden = [model.is_default integerValue] == 1 ? NO : YES;
    cell.addressLabelLayoutConstraint.constant = [model.is_default integerValue] == 1 ? 75 : 15;
    
    [cell.defaultAddressButton addTarget:self action:@selector(defaultAddressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.defaultAddressButton.tag = indexPath.row;
    cell.defaultAddressButton.selected = [model.is_default integerValue] == 1 ? YES : NO;
//    if (self.isManage) {
//         if (![self.defaultAddressButtonsMuArr containsObject:cell.defaultAddressButton]) {
//             [self.defaultAddressButtonsMuArr addObject:cell.defaultAddressButton];
//         }
//        NSLog(@"%@", self.defaultAddressButtonsMuArr);
//    }
    
    cell.lineView.hidden = self.isManage ? NO : YES;
    cell.defaultAddressButton.hidden = self.isManage ? NO : YES;
    cell.editButton.hidden = self.isManage ? NO : YES;
    cell.deleteButton.hidden = self.isManage ? NO : YES;
    
    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMinePage) {
        VENShoppingCartPlacingOrderReceivingAddressModel *model = self.dataArr[indexPath.row];
        self.block(model);
        [self. navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 选择默认地址
- (void)defaultAddressButtonClick:(UIButton *)button {
    
    VENShoppingCartPlacingOrderReceivingAddressModel *model = self.dataArr[button.tag];
    
    NSDictionary *params = @{@"address_id" : model.address_id,
                             @"status" : @"1"};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"address/setDefault" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            for (VENShoppingCartPlacingOrderReceivingAddressModel *model in self.dataArr) {
                model.is_default = @"0";
            }
            
            model.is_default = @"1";
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 管理收货地址 / 编辑
- (void)editButtonClick:(UIButton *)button {
    
    VENShoppingCartPlacingOrderReceivingAddressModel *model = self.dataArr[button.tag];
    
    VENShoppingCartPlacingOrderAddReceivingAddressViewController *vc = [[VENShoppingCartPlacingOrderAddReceivingAddressViewController alloc] init];
    vc.block = ^(NSString *str) {
        [self loadData];
    };
    vc.model = model;
    vc.isEdit = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 管理收货地址 / 删除
- (void)deleteButtonClick:(UIButton *)button {
    
    VENShoppingCartPlacingOrderReceivingAddressModel *model = self.dataArr[button.tag];
    
    NSDictionary *params = @{@"address_id" : model.address_id};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"address/remove" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            
            [self.dataArr removeObject:model];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isManage ? 134 : 79;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - 48 - (tabBarHeight - 49)) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENShoppingCartPlacingOrderReceivingAddressTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

- (void)setupAddReceivingAddressButton {
    UIButton *addReceivingAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - statusNavHeight - 48 - (tabBarHeight - 49), kMainScreenWidth, 48)];
    addReceivingAddressButton.backgroundColor = COLOR_THEME;
    [addReceivingAddressButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addReceivingAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addReceivingAddressButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [addReceivingAddressButton addTarget:self action:@selector(addReceivingAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addReceivingAddressButton];
}

#pragma mark - 新增收货地址
- (void)addReceivingAddressButtonClick {
    VENShoppingCartPlacingOrderAddReceivingAddressViewController *vc = [[VENShoppingCartPlacingOrderAddReceivingAddressViewController alloc] init];
    vc.block = ^(NSString *str) {
        [self loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupManageButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"管理" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(manageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    _navigationRightButton = button;
}

- (void)manageButtonClick {
    self.isManage = !self.isManage;
    
    [self.navigationRightButton setTitle:self.isManage ? @"完成" : @"管理" forState:UIControlStateNormal];
    self.navigationItem.title = self.isManage ? @"管理收货地址" : @"收货地址";
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
