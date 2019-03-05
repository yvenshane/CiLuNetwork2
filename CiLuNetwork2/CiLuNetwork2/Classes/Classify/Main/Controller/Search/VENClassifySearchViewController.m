//
//  VENClassifySearchViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/11.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifySearchViewController.h"
#import "VENHomePageCollectionViewCell.h"
#import "VENClassifyModel.h"
#import "VENClassifyDetailsViewController.h"

@interface VENClassifySearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *lists_goods;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *keyword;

@end

@implementation VENClassifySearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSearchBar];
    [self setupCollectionView];
}

- (void)textFieldDidChange:(UITextField *)textField {
    UITextRange *selectedRange = textField.markedTextRange;
    if (selectedRange == nil || selectedRange.empty) {
        self.keyword = textField.text;
        
        if (![[VENClassEmptyManager sharedManager] isEmptyString:self.keyword]) {
            [self loadDataWithPage:@"1"];
        } else {
            [self.lists_goods removeAllObjects];
            [self.collectionView reloadData];
        }
    }
}

- (void)loadDataWithPage:(NSString *)page {
    
    NSString *tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tag"] stringValue];
    if ([[VENClassEmptyManager sharedManager] isEmptyString:tag]) {
        NSDictionary *metaData = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"];
        tag = [metaData[@"foundationList"][0][@"id"] stringValue];
        if ([[VENClassEmptyManager sharedManager] isEmptyString:tag]) {
            tag = @"1";
        }
    }
    
    NSDictionary *params = @{@"cate_id" : @"0",
                             @"page" : page,
                             @"tag" : tag,
                             @"keyword" : self.keyword};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"goods/lists" params:params showLoading:NO successBlock:^(id response) {
        if ([response[@"status"] integerValue] == 0) {
            
            if ([page integerValue] == 1) {
                [self.collectionView.mj_header endRefreshing];
                
                self.lists_goods = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENClassifyModel class] json:response[@"data"][@"lists"][@"goods"]]];
                
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
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, statusBarHeight + 30 + 10, kMainScreenWidth, kMainScreenHeight - 30 - 10 - statusBarHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VENHomePageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:collectionView];
    
    // 上拉加载更多
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    self.collectionView = collectionView;
}

- (void)setupSearchBar {
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 27, kMainScreenWidth - 30 - 15 - 32, 30)];
    searchTextField.font = [UIFont systemFontOfSize:12.0f];
    searchTextField.backgroundColor = UIColorFromRGB(0xF1F1F1);
    searchTextField.placeholder = @"请输入关键词搜索";
    
    searchTextField.layer.cornerRadius = 4.0f;
    searchTextField.layer.masksToBounds = YES;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 30)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30 / 2 - 14 / 2, 14, 14)];
    imgView.image = [UIImage imageNamed:@"icon_search02"];
    [leftView addSubview:imgView];
    searchTextField.leftView = leftView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    searchTextField.autocorrectionType = UITextAutocorrectionTypeDefault;
//    searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchTextField becomeFirstResponder];
    
    [self.view addSubview:searchTextField];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15 - 32, 27 + 30 / 2 - 20 / 2, 32, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

- (void)cancelButtonClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
