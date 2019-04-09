//
//  VENSalesManagementViewController.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/1.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSalesManagementViewController.h"
#import "VENSalesManagementHeaderViewTableViewCell.h"
#import "VENSalesManagementTableViewCell.h"
#import "VENDatePickerView.h"
#import "VENSalesManagementModel.h"

@interface VENSalesManagementViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VENDatePickerView *datePickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, strong) NSMutableArray *listsMuArr;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *countPrice;
@property (nonatomic, copy) NSString *todayStr;
@property (nonatomic, copy) NSString *aMonthAgoStr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
static NSString *cellIdentifier2 = @"cellIdentifier2";
@implementation VENSalesManagementViewController

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
    
    self.navigationItem.title = @"销售管理";
    
    NSDate *today = [NSDate date];
    NSDate *aMonthAgo = [today dateByAddingTimeInterval: - 60 * 60 * 24 * 30];

    self.todayStr = [self.dateFormatter stringFromDate:today];
    self.aMonthAgoStr = [self.dateFormatter stringFromDate:aMonthAgo];
    
    [self setupTableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataWithPage:(NSString *)page {
    NSDictionary *params = @{@"page" : page,
                             @"start_date" : self.aMonthAgoStr,
                             @"end_date" : self.todayStr};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"keyAccount/sales" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {

            if ([page integerValue] == 1) {
                [self.tableView.mj_header endRefreshing];

                self.countPrice = response[@"data"][@"countPrice"];

                self.listsMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENSalesManagementModel class] json:response[@"data"][@"lists"]]];
                self.page = 1;
            } else {
                [self.tableView.mj_footer endRefreshing];

                [self.listsMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENSalesManagementModel class] json:response[@"data"][@"lists"]]];
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
        VENSalesManagementHeaderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.priceLabel.text = self.countPrice;
        cell.leftDateLabel.text = self.aMonthAgoStr;
        cell.rightDateLabel.text = self.todayStr;
        
        [cell.leftDatePickerButton addTarget:self action:@selector(leftDatePickerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightDatePickerButton addTarget:self action:@selector(rightDatePickerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENSalesManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        return cell;
    }
}

- (void)leftDatePickerButtonClick:(UIButton *)button {
    button.selected = YES;
    [self setupDatePickerViewWithDate:self.aMonthAgoStr];
}

- (void)rightDatePickerButtonClick:(UIButton *)button {
    button.selected = YES;
    [self setupDatePickerViewWithDate:self.todayStr];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 135 : 64;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENSalesManagementTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"VENSalesManagementHeaderViewTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithPage:@"1"];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _tableView = tableView;
}

- (void)setupDatePickerViewWithDate:(NSString *)date {
    [_datePickerView removeFromSuperview];
    _datePickerView = nil;
    
    if (!_datePickerView) {
        _datePickerView = [[VENDatePickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - (216 + 44) - statusNavHeight, kMainScreenWidth, 216 + 44)];
        _datePickerView.date = date;
        _datePickerView.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:- 24 * 60 * 60 * 30];
        _datePickerView.maximumDate = [NSDate date];
        
        __weak typeof(self) weakSelf = self;
        _datePickerView.datePickerBlock = ^(NSString *dateStr) {
            weakSelf.dateStr = dateStr;
        };
        
        [_datePickerView.doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_datePickerView];
    }
}

- (void)doneButtonClick:(UIButton *)button {
    VENSalesManagementHeaderViewTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (cell.leftDatePickerButton.selected == YES) {
        cell.leftDatePickerButton.selected = NO;
        
        if (![[VENClassEmptyManager sharedManager] isEmptyString:self.dateStr]) {
            self.aMonthAgoStr = self.dateStr;
            [self loadDataWithPage:@"1"];
        }
        
    } else if (cell.rightDatePickerButton.selected == YES) {
        cell.rightDatePickerButton.selected = NO;
        
        if (![[VENClassEmptyManager sharedManager] isEmptyString:self.dateStr]) {
            self.todayStr = self.dateStr;
            [self loadDataWithPage:@"1"];
        }
    }
    
    self.dateStr = nil;
    
    [_datePickerView removeFromSuperview];
    _datePickerView = nil;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
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
