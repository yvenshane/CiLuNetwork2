//
//  VENMyOrderWaitingForReceivingViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/26.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOrderWaitingForReceivingViewController.h"
#import "VENShoppingCartTableViewCell.h"
#import "VENMyOrderOrderDetailsViewController.h"
#import "VENMyOrderAllOrdersModel.h"

@interface VENMyOrderWaitingForReceivingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *responseMuArr;
@property (nonatomic, strong) NSMutableArray *listsMuArr;
@property (nonatomic, assign) NSInteger page;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMyOrderWaitingForReceivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
}

- (void)loadDataWithPage:(NSString *)page {
    
    NSDictionary *params = @{@"status" : @"3",
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
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 76 - 15, 44, 76, 27)];
    rightButton.tag = section;
    rightButton.backgroundColor = UIColorFromRGB(0xC7974F);
    [rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.layer.cornerRadius = 2.0f;
    rightButton.layer.masksToBounds = YES;
    [footerView addSubview:rightButton];
    
    return footerView;
}

#pragma mark - 确认收货
- (void)rightButtonClick:(UIButton *)button {
    VENMyOrderAllOrdersModel *model = self.listsMuArr[button.tag];
    
    NSDictionary *params = @{@"order_id" : model.order_id,
                             @"status" : @"2"};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"order/setOrderStatus" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            [self.listsMuArr removeObject:model];
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoodsReceived" object:@"WaitingForReceiving"];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 85;
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
