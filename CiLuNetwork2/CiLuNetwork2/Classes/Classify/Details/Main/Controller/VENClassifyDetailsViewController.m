//
//  VENClassifyDetailsViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/19.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENClassifyDetailsViewController.h"
#import "VENClassifyDetailsHeaderView.h"
#import "VENClassifyDetailsPopupView.h"
#import "VENClassifyDetailsToolBarView.h"
#import "VENClassifyDetailsUserEvaluateViewController.h"
#import "VENClassifyDetailsModel.h"
#import "VENShoppingCartPlacingOrderViewController.h"
#import "VENLoginViewController.h"

@interface VENClassifyDetailsViewController () <UITableViewDelegate, SDCycleScrollViewDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) VENClassifyDetailsPopupView *popupView;

@property (nonatomic, strong) VENClassifyDetailsModel *model;
@property (nonatomic, copy) NSArray *albumsArr;
@property (nonatomic, copy) NSDictionary *commentsDict;
@property (nonatomic, copy) NSDictionary *special_goodsDict;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerViewHeight;

@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *collectionButton02;

@property (nonatomic, strong) VENClassifyDetailsToolBarView *bottomToolBarView;

@end

@implementation VENClassifyDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.isBug) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"goods/detail" params:@{@"id" : self.goods_id} showLoading:YES successBlock:^ (id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            
            self.model = [VENClassifyDetailsModel yy_modelWithJSON:response[@"data"]];
            self.albumsArr = response[@"data"][@"album"][@"albums"];
            self.commentsDict = response[@"data"][@"comments"];
            self.special_goodsDict = response[@"data"][@"special_goods"];
            
            [self setupTableView];
            [self setupBottomToolBar];
            [self setupNavigationBar];
            
        } else if ([response[@"status"] integerValue] == 90099){
            [self.navigationController popViewControllerAnimated:YES];
            [[VENMBProgressHUDManager sharedManager] showText:@"商品不存在/商品已下架"];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navigationBar.alpha = scrollView.contentOffset.y <= 0 ? 0 : scrollView.contentOffset.y / statusNavHeight;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 48 - (tabBarHeight - 49)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    // 商品名 用户评论 两行
    if ([self labelHeightWith:self.model.name and:16.0f] > 20 && [self labelHeightWith:self.commentsDict[@"comment"][@"content"] and:14.0f] > 17) {
        self.headerViewHeight = 363;
        
    // 商品名 一行 用户评论 两行
    } else if ([self labelHeightWith:self.model.name and:16.0f] <= 20 && [self labelHeightWith:self.commentsDict[@"comment"][@"content"] and:14.0f] > 17) {
        self.headerViewHeight = 344;
        
    // 商品名 两行 用户评论 一行
    } else if ([self labelHeightWith:self.model.name and:16.0f] > 20 && [self labelHeightWith:self.commentsDict[@"comment"][@"content"] and:14.0f] <= 17) {
        self.headerViewHeight = 347;
        
    // 商品名 用户评论 一行
    } else {
        self.headerViewHeight = 328;
    }
    
    // 特质商品
    if ([self.special_goodsDict[@"is_show"] integerValue] == 1) {
        self.headerViewHeight += 44;
    }
    
    // 评论为空
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.commentsDict[@"comment"][@"content"]]) {
        self.headerViewHeight -= 140;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.headerViewHeight + 375)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    // 轮播图
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 375) delegate:self placeholderImage:nil];
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.5];
    cycleScrollView.pageDotColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:0.2];
    cycleScrollView.imageURLStringsGroup = self.albumsArr;
    cycleScrollView.autoScrollTimeInterval = 3;
    [headerView addSubview:cycleScrollView];
    
    // 返回
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, statusNavHeight - 44 + 7.5, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"icon_back02"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    // 收藏
    UIButton *collectionButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 45, statusNavHeight - 44 + 8, 30, 30)];
    [collectionButton setImage:[UIImage imageNamed:[self.model.is_mark integerValue] == 0 ? @"icon_collection" : @"icon_collection_active"] forState:UIControlStateNormal];
    [collectionButton addTarget:self action:@selector(collectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectionButton];
    
    // headerView
    VENClassifyDetailsHeaderView *detailsHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"VENClassifyDetailsHeaderView" owner:nil options:nil] lastObject];
    detailsHeaderView.frame = CGRectMake(0, 375, kMainScreenWidth, self.headerViewHeight);
    [detailsHeaderView.choiceButton addTarget:self action:@selector(choiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:detailsHeaderView];
    
    detailsHeaderView.titleLabel.text = self.model.name;
    detailsHeaderView.priceLabel.text = self.model.price;

    if ([self.special_goodsDict[@"is_show"] integerValue] == 1 && [self.model.is_new integerValue] == 1) {
        detailsHeaderView.tokenLabel.hidden = NO;
        detailsHeaderView.tokenLabel2.hidden = NO;
        
        detailsHeaderView.tokenLabelLeftLayoutConstraint.constant = 7;
        detailsHeaderView.tokenLabel2LeftLayoutConstraint.constant = 7 + 48 + 7;
        
        detailsHeaderView.tezhiView.hidden = NO;
        detailsHeaderView.tezhiLabel.text = [NSString stringWithFormat:@"购买此特制产品将捐赠付款总金额的%@%给基金会", self.special_goodsDict[@"rate"]];
        detailsHeaderView.tezhiViewHeightLayoutConstraint.constant = 44.0f;
        
    } else if ([self.special_goodsDict[@"is_show"] integerValue] == 0 && [self.model.is_new integerValue] == 1) {
        detailsHeaderView.tokenLabel.hidden = NO;
        detailsHeaderView.tokenLabel2.hidden = YES;
        
        detailsHeaderView.tokenLabelLeftLayoutConstraint.constant = 7;
//        detailsHeaderView.tokenLabel2LeftLayoutConstraint.constant = 7 + 48 + 7;
        
        detailsHeaderView.tezhiView.hidden = YES;
        detailsHeaderView.tezhiViewHeightLayoutConstraint.constant = 0.0f;
        
    } else if ([self.special_goodsDict[@"is_show"] integerValue] == 1 && [self.model.is_new integerValue] == 0) {
        detailsHeaderView.tokenLabel.hidden = YES;
        detailsHeaderView.tokenLabel2.hidden = NO;
        
//        detailsHeaderView.tokenLabelLeftLayoutConstraint.constant = 7;
        detailsHeaderView.tokenLabel2LeftLayoutConstraint.constant = 7;
        
        detailsHeaderView.tezhiView.hidden = NO;
        detailsHeaderView.tezhiLabel.text = [NSString stringWithFormat:@"购买此特制产品将捐赠付款总金额的%@%给基金会", self.special_goodsDict[@"rate"]];
        detailsHeaderView.tezhiViewHeightLayoutConstraint.constant = 44.0f;
        
    } else {
        detailsHeaderView.tokenLabel.hidden = YES;
        detailsHeaderView.tokenLabel2.hidden = YES;
        
        detailsHeaderView.tezhiView.hidden = YES;
        detailsHeaderView.tezhiViewHeightLayoutConstraint.constant = 0.0f;
    }
    
    detailsHeaderView.numberLabel.text = self.model.sales_volume;
    detailsHeaderView.choiceLabel.text = self.model.spec;
    
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.commentsDict[@"comment"][@"content"]]) {
        detailsHeaderView.evaluateRightImageView.hidden = YES;
        detailsHeaderView.evaluateLineView.hidden = YES;
        detailsHeaderView.evaluateLineView2.hidden = YES;
        
        detailsHeaderView.evaluateNumberLabel.hidden = YES;
        detailsHeaderView.evaluateUserIconImageView.hidden = YES;
        detailsHeaderView.evaluateUserPhonenumberLabel.hidden = YES;
        detailsHeaderView.evaluateDateLabel.hidden = YES;
        detailsHeaderView.evaluateContentLabel.hidden = YES;
        detailsHeaderView.evaluateButton.hidden = YES;
        
    } else {
        detailsHeaderView.evaluateNumberLabel.text = [NSString stringWithFormat:@"用户评价（%@）", self.commentsDict[@"count"]];
        [detailsHeaderView.evaluateUserIconImageView sd_setImageWithURL:self.commentsDict[@"comment"][@"avatar"]];
        detailsHeaderView.evaluateUserPhonenumberLabel.text = self.commentsDict[@"comment"][@"name"];
        detailsHeaderView.evaluateDateLabel.text = self.commentsDict[@"comment"][@"commented_at"];
        detailsHeaderView.evaluateContentLabel.text = self.commentsDict[@"comment"][@"content"];
        [detailsHeaderView.evaluateButton addTarget:self action:@selector(evaluateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 商品详情
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.headerViewHeight + 375, kMainScreenWidth, 1)];
    webView.delegate = self;
    webView.scrollView.scrollEnabled = NO;
    [webView loadHTMLString:self.model.content baseURL:nil];
    [headerView addSubview:webView];

    tableView.tableHeaderView = headerView;
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView = tableView;
    _headerView = headerView;
    _collectionButton = collectionButton;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kMainScreenWidth, 375 + self.headerViewHeight + webViewHeight);
    self.tableView.tableHeaderView = self.headerView;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 收藏
- (void)collectionButtonClick {
    NSLog(@"收藏");
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"collect/apply" params:@{@"goods_id" : self.goods_id} showLoading:NO successBlock:^(id response) {

        if ([response[@"status"] integerValue] == 0) {
            
            if ([self.model.is_mark integerValue] == 0) {
                
                self.model.is_mark = @"1";
                [self.collectionButton setImage:[UIImage imageNamed:@"icon_collection_active"] forState:UIControlStateNormal];
                [self.collectionButton02 setImage:[UIImage imageNamed:@"icon_collection02_active"] forState:UIControlStateNormal];
                
            } else if ([self.model.is_mark integerValue] == 1) {
                
                self.model.is_mark = @"0";
                [self.collectionButton setImage:[UIImage imageNamed:@"icon_collection"] forState:UIControlStateNormal];
                [self.collectionButton02 setImage:[UIImage imageNamed:@"icon_collection02"] forState:UIControlStateNormal];
            }
            
        }
        
    } failureBlock:^(NSError *error) {

    }];
}

- (void)choiceButtonClick {
    NSLog(@"选择规格");
    
//    [self backgroundView];
//    [self popupView];
}

#pragma mark - 用户评价
- (void)evaluateButtonClick {
    NSLog(@"用户评价");
    
    VENClassifyDetailsUserEvaluateViewController *vc = [[VENClassifyDetailsUserEvaluateViewController alloc] init];
    vc.goods_id = self.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupBottomToolBar {
    [self.bottomToolBarView removeFromSuperview];
    self.bottomToolBarView = nil;
    
    if (self.bottomToolBarView == nil) {
        VENClassifyDetailsToolBarView *bottomToolBarView = [[VENClassifyDetailsToolBarView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 48 - (tabBarHeight  - 49), kMainScreenWidth, 48)];
        [self.view addSubview:bottomToolBarView];
        
        if ([[VENUserStatusManager sharedManager] isLogin]) {
            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/lists" params:nil showLoading:NO successBlock:^(id response) {
                
                if ([response[@"status"] integerValue] == 0) {
                    if ([response[@"data"][@"count"] integerValue] > 0) {
                        bottomToolBarView.redDotLabel.hidden = NO;
                        bottomToolBarView.redDotLabel.text = [NSString stringWithFormat:@"%@", response[@"data"][@"count"]];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", response[@"data"][@"count"]] forKey:@"RedDot"];
                    } else {
                        bottomToolBarView.redDotLabel.hidden = YES;
                    }
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
        [bottomToolBarView.customerServiceButton addTarget:self action:@selector(customerServiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBarView.shoppingCartButton addTarget:self action:@selector(shoppingCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBarView.addShoppingCartButton addTarget:self action:@selector(addShoppingCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBarView.purchaseButton addTarget:self action:@selector(purchaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.bottomToolBarView = bottomToolBarView;
    }
}

#pragma mark - 客服
- (void)customerServiceButtonClick {
    NSLog(@"客服");
    
    NSDictionary *metaData = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"];
    NSString *phoneNumber = metaData[@"service_telephone"];
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

- (void)shoppingCartButtonClick {
    NSLog(@"购物车");
    
    self.tabBarController.selectedIndex = 2;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加入购物车
- (void)addShoppingCartButtonClick {
    NSLog(@"加入购物车");
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"cart/add" params:@{@"id" : self.goods_id} showLoading:NO successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:nil];
            [self setupBottomToolBar];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 立即购买
- (void)purchaseButtonClick {
    NSLog(@"立即购买");
    
    if ([[VENUserStatusManager sharedManager] isLogin]) {
        VENShoppingCartPlacingOrderViewController *vc = [[VENShoppingCartPlacingOrderViewController alloc] init];
        vc.goods_id = self.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VENLoginViewController *vc = [[VENLoginViewController alloc] init];
        vc.block = ^(NSString *str) {
            
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        [[UIApplication sharedApplication].keyWindow addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (VENClassifyDetailsPopupView *)popupView {
    if (_popupView == nil) {
        __weak typeof(self) weakSelf = self;
        
        _popupView = [[VENClassifyDetailsPopupView alloc] init];
        _popupView.backgroundColor = [UIColor whiteColor];
        _popupView.transform = CGAffineTransformMakeTranslation(0.01, kMainScreenHeight);
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.popupView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
            weakSelf.popupView.backgroundColor = [UIColor whiteColor];
            weakSelf.popupView.frame = CGRectMake(0, kMainScreenHeight - 341, kMainScreenWidth, 341);
        }];
        
        // popupView 关闭按钮
        _popupView.block = ^(NSString *str) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.popupView.transform = CGAffineTransformMakeTranslation(0.01, kMainScreenHeight);
            }];
            [weakSelf.popupView removeFromSuperview];
            [weakSelf.backgroundView removeFromSuperview];
            weakSelf.backgroundView = nil;
            weakSelf.popupView = nil;
        };
        
        [_backgroundView addSubview:_popupView];
    }
    return _popupView;
}

- (void)setupNavigationBar {
    // navigationBar
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, statusNavHeight)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.alpha = 0;
    [self.view addSubview:navigationBar];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(8, statusNavHeight - 44, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:backButton];
    
    UIButton *collectionButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 8 - 44, statusNavHeight - 44, 44, 44)];
    [collectionButton setImage:[UIImage imageNamed:[self.model.is_mark integerValue] == 0 ? @"icon_collection02" : @"icon_collection02_active"] forState:UIControlStateNormal];
    [collectionButton addTarget:self action:@selector(collectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:collectionButton];
    
    _navigationBar = navigationBar;
    _collectionButton02 = collectionButton;
}

- (CGFloat)labelHeightWith:(NSString *)text and:(CGFloat)fontSize {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 2;
    
    CGSize size = [label sizeThatFits:CGSizeMake(kMainScreenWidth - 30, CGFLOAT_MAX)];
    
    return size.height;
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
