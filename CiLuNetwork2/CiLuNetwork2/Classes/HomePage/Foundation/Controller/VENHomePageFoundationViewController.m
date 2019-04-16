//
//  VENHomePageFoundationViewController.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/4/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageFoundationViewController.h"
#import "VENHomePageCollectionViewCell.h"
#import "VENHomePageModel.h"
#import "VENClassifyDetailsViewController.h"
#import "VENHomePageFoundationDonationListView.h"
#import "VENHomePageFoundationHeaderView.h"
#import "VENHomePageFoundationMoreListViewController.h"

@interface VENHomePageFoundationViewController () <SDCycleScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) VENHomePageFoundationDonationListView *donationListView;
@property (nonatomic, strong) VENHomePageFoundationHeaderView *headerView;
@property (nonatomic, strong) VENHomePageFoundationHeaderView *headerView2;

@property (nonatomic, copy) NSArray *banners;
@property (nonatomic, copy) NSArray *donationList;
@property (nonatomic, copy) NSArray *hotGoods;
@property (nonatomic, copy) NSArray *specialGoods;

@end

@implementation VENHomePageFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCollectionView];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"foundation/index" params:nil showLoading:YES successBlock:^(id response) {
        
        [self.collectionView.mj_header endRefreshing];
        
        if ([response[@"status"] integerValue] == 0) {
            
            NSArray *banners = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"banners"]];
            NSArray *donationList = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"donation_list"]];
            NSArray *hotGoods = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"hot_goods"]];
            NSArray *specialGoods = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"special_goods"]];
            
            self.banners = banners;
            self.donationList = donationList;
            self.hotGoods = hotGoods;
            self.specialGoods = specialGoods;
            
            [self setupCycleScrollView];
            [self setupDonationListView];
            [self setupHeaderView];
            
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? self.hotGoods.count : self.specialGoods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageCollectionViewCell *cell = (VENHomePageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    VENHomePageModel *model = indexPath.section == 0 ? self.hotGoods[indexPath.row] : self.specialGoods[indexPath.row];

    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.titleLabel.text = model.goods_name;
    cell.priceLabel.text= model.goods_price;
    cell.numberLabel.text= model.sale_status;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageModel *model = indexPath.section == 0 ? self.hotGoods[indexPath.row] : self.specialGoods[indexPath.row];

    VENClassifyDetailsViewController *vc = [[VENClassifyDetailsViewController alloc] init];
    vc.goods_id = model.goods_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? CGSizeMake(kMainScreenWidth, 160 + self.donationList.count * 30 + 52 + 6 + 84 - 10) : CGSizeMake(kMainScreenWidth, 52 - 10);
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
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:collectionView];

    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _collectionView = collectionView;
}

#pragma mark - headerView
- (void)setupHeaderView {
    [self.headerView removeFromSuperview];
    self.headerView = nil;
    
    if (!self.headerView) {
        // 分割线 + 标题
        VENHomePageFoundationHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"VENHomePageFoundationHeaderView" owner:nil options:nil] lastObject];
        headerView.frame = CGRectMake(0, 160 + self.donationList.count * 30 + 52 + 6, kMainScreenWidth, 84);
        
        [headerView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.collectionView addSubview:headerView];
        
        self.headerView = headerView;
    }
    
    [self.headerView2 removeFromSuperview];
    self.headerView2 = nil;
    
    if (!self.headerView2) {
        // 分割线 + 标题
        VENHomePageFoundationHeaderView *headerView2 = [[[NSBundle mainBundle] loadNibNamed:@"VENHomePageFoundationHeaderView" owner:nil options:nil] lastObject];
        headerView2.frame = CGRectMake(0, 160 + self.donationList.count * 30 + 52 + 6 + 84 + ceilf(self.hotGoods.count / 2.0) * 248 + ceilf(self.hotGoods.count / 2.0) * 10,  kMainScreenWidth, 52);
        
        headerView2.titleLabel.text = @"其他商品";
        headerView2.descripLabel.hidden = YES;
        [headerView2.moreButton addTarget:self action:@selector(moreButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
        [self.collectionView addSubview:headerView2];

        self.headerView2 = headerView2;
    }
}

- (void)moreButtonClick:(UIButton *)button {
    VENHomePageFoundationMoreListViewController *vc = [[VENHomePageFoundationMoreListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButtonClick2:(UIButton *)button {
    VENHomePageFoundationMoreListViewController *vc = [[VENHomePageFoundationMoreListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 捐赠动态
- (void)setupDonationListView {
    
    [self.donationListView removeFromSuperview];
    self.donationListView = nil;
    
    if (!self.donationListView) {
        VENHomePageFoundationDonationListView *donationListView = [[VENHomePageFoundationDonationListView alloc] initWithFrame:CGRectMake(0, 160, kMainScreenWidth, self.donationList.count * 30 + 52 + 6)];
        donationListView.donationList = self.donationList;
        [self.collectionView addSubview:donationListView];
        
        _donationListView = donationListView;
    }
}

#pragma mark - 广告
- (void)setupCycleScrollView {

    [self.cycleScrollView removeFromSuperview];
    self.cycleScrollView = nil;

    if (self.cycleScrollView == nil) {
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 160) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.currentPageDotColor = COLOR_THEME;
        cycleScrollView.pageDotColor = [UIColor whiteColor];

        NSMutableArray *imageURLStringsGroup = [NSMutableArray array];
        for (VENHomePageModel *bannersModel in self.banners) {
            [imageURLStringsGroup addObject:bannersModel.image];
        }

        cycleScrollView.imageURLStringsGroup = imageURLStringsGroup;
        cycleScrollView.autoScrollTimeInterval = 3;
        [self.collectionView addSubview:cycleScrollView];

        _cycleScrollView = cycleScrollView;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    VENHomePageModel *model = self.banners[index];

    if (model.is_link == YES) {
        VENClassifyDetailsViewController *vc = [[VENClassifyDetailsViewController alloc] init];
        vc.goods_id = model.link;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
