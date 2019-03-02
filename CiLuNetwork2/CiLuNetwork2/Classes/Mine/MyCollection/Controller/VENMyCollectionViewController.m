//
//  VENMyCollectionViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/27.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyCollectionViewController.h"
#import "VENShoppingCartTableViewCell.h"
#import "VENMyCollectionModel.h"

@interface VENMyCollectionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *navigationRightButton;
@property (nonatomic, assign) BOOL isManage;

@property (nonatomic, strong) UIView *shoppingBar;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *selectAllButton;
//@property (nonatomic, assign) BOOL isSelectAll;

@property (nonatomic, strong) NSMutableArray *listsMuArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *IDsMuArr;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self setupManagementCollectionButton];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataWithPage:(NSString *)page {
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"collect/lists" params:@{@"page" : page} showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            
            if ([page integerValue] == 1) {
                [self.tableView.mj_header endRefreshing];
                
                self.listsMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENMyCollectionModel class] json:response[@"data"][@"lists"]]];
                self.page = 1;
                
                [self.shoppingBar removeFromSuperview];
                self.shoppingBar = nil;
                if (self.isManage) {
                    [self setupShoppingBar];
                }
                
                if (self.listsMuArr.count < 1) {
                    [self.shoppingBar removeFromSuperview];
                    self.shoppingBar = nil;
                    self.isManage = NO;
                    [self.navigationRightButton setTitle:@"管理收藏" forState:UIControlStateNormal];
                    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight);
                }
            } else {
                [self.tableView.mj_footer endRefreshing];
                
                [self.listsMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENMyCollectionModel class] json:response[@"data"][@"lists"]]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listsMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImageViewLayoutConstraint.constant = self.isManage ? 0 : -33.0f;
    cell.choiceButton.hidden = self.isManage ? NO : YES;
    
    cell.priceLabel.hidden = YES;
    cell.numberLabel.hidden = YES;
    cell.otherLabel.textColor = UIColorFromRGB(0x1A1A1A);
    cell.lineImageView.hidden = NO;
    
    VENMyCollectionModel *model = self.listsMuArr[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb]];
    cell.titleLabel.text = model.goods_name;
    cell.otherLabel.text = model.goods_price;
    
    cell.choiceButton.tag = indexPath.row;
    cell.choiceButton.selected = model.isChoise;
    [cell.choiceButton addTarget:self action:@selector(choiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.rowHeight = 100;
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

#pragma mark - 底部 toolBar
- (void)setupShoppingBar {
    UIView *shoppingBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - statusNavHeight - 44, kMainScreenWidth, 44)];
    shoppingBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shoppingBar];
    
    UIButton *selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(-6, 0, 100, 44)];
    selectAllButton.backgroundColor = [UIColor whiteColor];
    [selectAllButton setImage:[UIImage imageNamed:@"icon_selecte_not"] forState:UIControlStateNormal];
    [selectAllButton setImage:[UIImage imageNamed:@"icon_selecte"] forState:UIControlStateSelected];
    [selectAllButton setTitle:@"   全选" forState:UIControlStateNormal];
    [selectAllButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [selectAllButton addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shoppingBar addSubview:selectAllButton];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 100, 0, 100, 44)];
    deleteButton.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    deleteButton.userInteractionEnabled = NO;
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [shoppingBar addSubview:deleteButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xE8E8E8);
    [shoppingBar addSubview:lineView];
    
    _shoppingBar = shoppingBar;
    _deleteButton = deleteButton;
    _selectAllButton = selectAllButton;
}

#pragma mark - 单选
- (void)choiceButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    VENMyCollectionModel *model = self.listsMuArr[button.tag];
    
    if (button.selected == YES) {
        model.isChoise = YES;
        if (![self.IDsMuArr containsObject:model.collectionID]) {
            [self.IDsMuArr addObject:model.collectionID];
        }
    } else {
        model.isChoise = NO;
        if ([self.IDsMuArr containsObject:model.collectionID]) {
            [self.IDsMuArr removeObject:model.collectionID];
        }
    }
    
    self.selectAllButton.selected = self.IDsMuArr.count == self.listsMuArr.count ? YES : NO;
    self.deleteButton.backgroundColor = self.IDsMuArr.count > 0 ? UIColorFromRGB(0xC7974F) : UIColorFromRGB(0xCCCCCC);
    self.deleteButton.userInteractionEnabled = self.IDsMuArr.count > 0 ? YES : NO;
    
    [self.tableView reloadData];
    
    NSLog(@"%@", self.IDsMuArr);
}

#pragma mark - 全选
- (void)selectAllButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    [self.IDsMuArr removeAllObjects];
    if (button.selected) {
        for (VENMyCollectionModel *model in self.listsMuArr) {
            model.isChoise = YES;
            [self.IDsMuArr addObject:model.collectionID];
        }
    } else {
        for (VENMyCollectionModel *model in self.listsMuArr) {
            model.isChoise = NO;
        }
    }
    
    self.deleteButton.backgroundColor = self.IDsMuArr.count > 0 ? UIColorFromRGB(0xC7974F) : UIColorFromRGB(0xCCCCCC);
    self.deleteButton.userInteractionEnabled = self.IDsMuArr.count > 0 ? YES : NO;
    
    [self.tableView reloadData];
    
    NSLog(@"%@", self.IDsMuArr);
}

#pragma mark - 删除
- (void)deleteButtonClick {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"collect/remove" params:@{@"ids" : [self.IDsMuArr componentsJoinedByString:@","]} showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            [self.IDsMuArr removeAllObjects];
            [self.tableView.mj_header beginRefreshing];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 管理收藏
- (void)setupManagementCollectionButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [button setTitle:@"管理收藏" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(managementCollectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    _navigationRightButton = button;
}

- (void)managementCollectionButtonClick {
    self.isManage = self.isManage == YES ? NO : YES;
    [self.navigationRightButton setTitle:self.isManage ? @"完成" : @"管理收藏" forState:UIControlStateNormal];

    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, self.isManage ? kMainScreenHeight - statusNavHeight - 44: kMainScreenHeight - statusNavHeight);
    
    [_shoppingBar removeFromSuperview];
    _shoppingBar = nil;
    if (self.isManage) {
        [self setupShoppingBar];
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)IDsMuArr {
    if (_IDsMuArr == nil) {
        _IDsMuArr = [NSMutableArray array];
    }
    return _IDsMuArr;
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
