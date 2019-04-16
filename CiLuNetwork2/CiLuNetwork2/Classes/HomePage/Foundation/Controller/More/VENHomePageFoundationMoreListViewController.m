//
//  VENHomePageFoundationMoreListViewController.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/14.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageFoundationMoreListViewController.h"
#import "VENHomePageCollectionViewCell.h"
#import "VENClassifyModel.h"
#import "VENClassifyDetailsViewController.h"

@interface VENHomePageFoundationMoreListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *lists_goods;

@end

@implementation VENHomePageFoundationMoreListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"特制商品";
    
    [self setupCollectionView];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadDataWithPage:(NSString *)page {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"foundation/lists" params:nil showLoading:NO successBlock:^(id response) {
        if ([response[@"status"] integerValue] == 0) {
            
            if ([page integerValue] == 1) {
                [self.collectionView.mj_header endRefreshing];
                
                self.lists_goods = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENClassifyModel class] json:response[@"data"][@"goods"]]];
                
                [self.collectionView reloadData];
            } else {
                [self.collectionView.mj_footer endRefreshing];
                
                [self.lists_goods addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENClassifyModel class] json:response[@"data"][@"goods"]]];
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
    VENClassifyModel *model = self.lists_goods[indexPath.row];
    
    VENClassifyDetailsViewController *vc = [[VENClassifyDetailsViewController alloc] init];
    vc.isBug = YES;
    vc.goods_id = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemWidth = (kMainScreenWidth - 3 * 10) / 2;
    layout.itemSize = CGSizeMake(itemWidth, 248);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:collectionView];
    
    // 上拉加载更多
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithPage:@"1"];
    }];
    
    self.collectionView = collectionView;
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
