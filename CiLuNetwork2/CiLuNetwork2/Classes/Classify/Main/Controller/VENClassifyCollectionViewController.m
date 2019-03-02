//
//  VENClassifyCollectionViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/14.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifyCollectionViewController.h"
#import "VENHomePageCollectionViewCell.h"
#import "VENClassifyDetailsViewController.h"
#import "VENClassifyModel.h"

@interface VENClassifyCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *price_sort;
@property (nonatomic, copy) NSString *sales_volume_sort;

@end

@implementation VENClassifyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];

    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithPage:@"1"];
    }];
    
    // 上拉加载更多
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    // 第0个 刷新
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.collectionView.mj_header beginRefreshing];
    });
    
    // 条件选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"refreshClassifySubviews" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    
    NSDictionary *tempDict = noti.object;
    
    if ([self.model.cate_id isEqualToString:tempDict[@"pageIndex"]]) {
        
        if ([tempDict[@"type"] isEqualToString:@"price"]) {
            self.price_sort = [tempDict[@"id"] stringValue];
            self.sales_volume_sort = @"";
        } else if ([tempDict[@"type"] isEqualToString:@"salesVolume"]) {
            self.price_sort = @"";
            self.sales_volume_sort = [tempDict[@"id"] stringValue];
        }
        [self.collectionView.mj_header beginRefreshing];
    }
}

- (void)loadDataWithPage:(NSString *)page {
    
    NSString *tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tag"] stringValue];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:tag]) {
        NSDictionary *metaData = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"];
        tag = [metaData[@"tag_list"][0][@"id"] stringValue];
    }
    
    NSDictionary *params = @{};

    if (![[VENClassEmptyManager sharedManager] isEmptyString:self.price_sort]) {
        params = @{@"cate_id" : self.model.cate_id,
                   @"price_sort" : self.price_sort,
                   @"page" : page,
                   @"tag" : tag};
    } else if (![[VENClassEmptyManager sharedManager] isEmptyString:self.sales_volume_sort]) {
        params = @{@"cate_id" : self.model.cate_id,
                   @"sales_volume_sort" : self.sales_volume_sort,
                   @"page" : page,
                   @"tag" : tag};
    } else {
        params = @{@"cate_id" : self.model.cate_id,
                   @"page" : page,
                   @"tag" : tag};
    }
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"goods/lists" params:params showLoading:YES successBlock:^(id response) {
        if ([response[@"status"] integerValue] == 0) {

            if ([page integerValue] == 1) {
                [self.collectionView.mj_header endRefreshing];

                VENClassifyModel *current_conditionsModel = [VENClassifyModel yy_modelWithJSON:response[@"data"][@"current_conditions"]];

                self.lists_goods = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENClassifyModel class] json:response[@"data"][@"lists"][@"goods"]]];
                self.model = current_conditionsModel;

                // 解决点击首页分类按钮 分类页面第一次不跳转到指定页面 BUG
                if (![[VENClassEmptyManager sharedManager] isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLoading"]]) {

                    self.block1([[[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLoading"] integerValue]);
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstLoading"];
                }

                self.page = 1;

                [self.collectionView reloadData];
            } else {
                [self.collectionView.mj_footer endRefreshing];

                [self.lists_goods addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENClassifyModel class] json:response[@"data"][@"lists"][@"goods"]]];
            }

            if ([response[@"data"][@"hasNext"] integerValue] == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }

            [self.collectionView reloadData];
        }

    } failureBlock:^(NSError *error) {
        if ([page integerValue] == 1) {
            [self.collectionView.mj_header endRefreshing];
        }else {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists_goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageCollectionViewCell *cell = (VENHomePageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    VENClassifyModel *model = self.lists_goods[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.titleLabel.text = model.goods_name;
    cell.priceLabel.text= model.goods_price;
    cell.numberLabel.text= model.sale_status;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.block([NSString stringWithFormat:@"%ld", (long)indexPath.row]);
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
