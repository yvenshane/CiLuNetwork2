//
//  VENHomePageViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/3.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageViewController.h"
#import "VENHomePageNavigationItemTitleView.h"
#import "VENHomePageCollectionViewCell.h"
#import "VENHomePageHorizontalCollectionView.h"
#import "VENHomePageCollectionViewHeaderView.h"
#import "VENHomePageModel.h"
#import "VENClassifyDetailsViewController.h"
#import "VENClassifySearchViewController.h"

@interface VENHomePageViewController () <SDCycleScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *banners;
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, copy) NSArray *hotGoods;
@property (nonatomic, copy) NSArray *newsGoods;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) VENHomePageHorizontalCollectionView *horizontalCollectionView;
@property (nonatomic, strong) VENHomePageCollectionViewHeaderView *collectionViewHeaderView2;

@end

@implementation VENHomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [[VENBadgeValueManager sharedManager] setupRedDotWithTabBar:self.tabBarController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationItemLeftBarButtonItem];
    [self setupNavigationItemRightBarButtonItem];
    [self setupCollectionView];
    
    [self.collectionView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"ResetHomePage" object:nil];
}

- (void)notificationCenter:(NSNotification *)noti {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadData {
    
    NSString *tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tag"] stringValue];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:tag]) {
        NSDictionary *metaData = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"];
        tag = [metaData[@"tag_list"][0][@"id"] stringValue];
    }
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"goods/index" params:@{@"tag" : tag} showLoading:YES successBlock:^(id response) {
        
        [self.collectionView.mj_header endRefreshing];
        
        if ([response[@"status"] integerValue] == 0) {
            
            NSArray *banners = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"banners"]];
            NSArray *categories = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"categories"]];
            NSArray *hotGoods = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"hot_goods"]];
            NSArray *newsGoods = [NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:response[@"data"][@"new_goods"]];
            
            self.banners = banners;
            self.categories = categories;
            self.hotGoods = hotGoods;
            self.newsGoods = newsGoods;
            
            [self setupCycleScrollView];
            [self setupHorizontalCollectionView];
            [self setupNavigationItemTitleView];
            
            [self.collectionView reloadData];
            self.collectionViewHeaderView2.frame = CGRectMake(0, 327 + ceilf(self.hotGoods.count / 2.0) * 248 + ceilf(self.hotGoods.count / 2.0) * 10,  kMainScreenWidth, 62);
        }
    } failureBlock:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? self.hotGoods.count : self.newsGoods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageCollectionViewCell *cell = (VENHomePageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    VENHomePageModel *model = indexPath.section == 0 ? self.hotGoods[indexPath.row] : self.newsGoods[indexPath.row];

    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumb] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.titleLabel.text = model.goods_name;
    cell.priceLabel.text= model.goods_price;
    cell.numberLabel.text= model.sale_status;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageModel *model = indexPath.section == 0 ? self.hotGoods[indexPath.row] : self.newsGoods[indexPath.row];
    
    VENClassifyDetailsViewController *vc = [[VENClassifyDetailsViewController alloc] init];
    vc.goods_id = model.goods_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? CGSizeMake(kMainScreenWidth, 327 - 10) : CGSizeMake(kMainScreenWidth, 62 - 10);
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemWidth = (kMainScreenWidth - 3 * 10) / 2;
    layout.itemSize = CGSizeMake(itemWidth, 248);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight - tabBarHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:collectionView];
    
    // 分割线 + 标题
    VENHomePageCollectionViewHeaderView *collectionViewHeaderView = [[VENHomePageCollectionViewHeaderView alloc] initWithFrame:CGRectMake(0, 265, kMainScreenWidth, 62)];
    collectionViewHeaderView.title = @"热门推荐";
    [collectionView addSubview:collectionViewHeaderView];
    
    // 分割线 + 标题
    VENHomePageCollectionViewHeaderView *collectionViewHeaderView2 = [[VENHomePageCollectionViewHeaderView alloc] init];
    collectionViewHeaderView2.title = @"新品上架";
    [collectionView addSubview:collectionViewHeaderView2];
    
    _collectionViewHeaderView2 = collectionViewHeaderView2;
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    _collectionView = collectionView;
}

#pragma mark - 广告
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    VENHomePageModel *model = self.banners[index];
    
    if (model.is_link == YES) {
        VENClassifyDetailsViewController *vc = [[VENClassifyDetailsViewController alloc] init];
        vc.goods_id = model.link;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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

#pragma mark - 分类
- (void)setupHorizontalCollectionView {

    [self.horizontalCollectionView removeFromSuperview];
    self.horizontalCollectionView = nil;
    
    if (self.horizontalCollectionView == nil) {
        // 分类图标
        VENHomePageHorizontalCollectionView *horizontalCollectionView = [[VENHomePageHorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 160, kMainScreenWidth, 105)];
        horizontalCollectionView.categoriesModel = self.categories;
        horizontalCollectionView.block = ^(NSString *str) {
            self.tabBarController.selectedIndex = 1;
        };
        [self.collectionView addSubview:horizontalCollectionView];
        
        _horizontalCollectionView = horizontalCollectionView;
    }
}

- (void)setupNavigationItemRightBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_search01"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

#pragma mark - 搜索
- (void)rightButtonClick {
    NSLog(@"右边");
    
    VENClassifySearchViewController *vc = [[VENClassifySearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_class"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)leftButtonClick {
    NSLog(@"左边");
    
    self.tabBarController.selectedIndex = 1;
}

- (void)setupNavigationItemTitleView {
    CGFloat titleViewWidth = 212.0f;
    
    VENHomePageNavigationItemTitleView *titleView = [[VENHomePageNavigationItemTitleView alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, 44)];
    titleView.titleViewWidth = titleViewWidth;
    titleView.buttonClickBlock = ^(NSString *str) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *metaData = [userDefaults objectForKey:@"metaData"];
        
        if ([str isEqualToString:@"left"]) {
            NSLog(@"left");
            
            [userDefaults setObject:metaData[@"tag_list"][0][@"id"] forKey:@"tag"];
            [self.collectionView.mj_header beginRefreshing];
        } else if ([str isEqualToString:@"right"]) {
            NSLog(@"right");
            
            [userDefaults setObject:metaData[@"tag_list"][1][@"id"] forKey:@"tag"];
            [self.collectionView.mj_header beginRefreshing];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reset" object:nil];
    };
    
    self.navigationItem.titleView = titleView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
