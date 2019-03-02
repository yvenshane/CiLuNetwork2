//
//  VENMyOrderViewController.m
//
//  Created by YVEN on 2018/9/5.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOrderViewController.h"
#import "VENMyOrderCategoryView.h"

#import "VENMyOrderAllOrdersViewController.h"
#import "VENMyOrderWaitingForShipmentViewController.h"
#import "VENMyOrderWaitingForReceivingViewController.h"
#import "VENMyOrderWaitingForEvaluationViewController.h"

@interface VENMyOrderViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) VENMyOrderCategoryView *categoryView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageIdx;

@property (nonatomic, assign) BOOL scrollAnimated;

@property (nonatomic, assign) BOOL refreshPageOne;
@property (nonatomic, assign) BOOL refreshPageTwo;
@property (nonatomic, assign) BOOL refreshPageThree;
@property (nonatomic, assign) BOOL refreshPageFour;

@end

@implementation VENMyOrderViewController

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
    
    self.navigationItem.title = @"我的订单";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    [self setupUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.categoryView.btnsArr[self.pushIndexPath] sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.scrollAnimated = YES;
    });
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"GoodsReceived" object:nil];
}

#pragma mark - 确认收货
- (void)notificationCenter:(NSNotification *)noti {
    
    if ([noti.object isEqualToString:@"All"]) {
        self.refreshPageThree = NO;
        self.refreshPageFour = NO;
    } else if ([noti.object isEqualToString:@"WaitingForReceiving"]) {
        self.refreshPageOne = NO;
        self.refreshPageFour = NO;
    } else if ([noti.object isEqualToString:@"WaitingForEvaluation"]) {
        self.refreshPageOne = NO;
    } else {
        
        if (_pageIdx == 0) {
            [self pushToMyOrderAllOrdersViewController];
            self.refreshPageThree = NO;
            self.refreshPageFour = NO;
        } else if (_pageIdx == 2) {
            [self pushToMyOrderWaitingForReceivingViewController];
            self.refreshPageOne = NO;
            self.refreshPageFour = NO;
        }  else if (_pageIdx == 3) {
            [self pushToMyOrderWaitingForEvaluationViewController];
            self.refreshPageOne = NO;
        }
        
        self.refreshPageFour = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isDragging || scrollView.isDecelerating || scrollView.isTracking)) {
        return;
    }
    
    // 获取滚动视图的内容的偏移量 x
    CGFloat offsetX = scrollView.contentOffset.x;
    NSLog(@"%f____%f", offsetX, kMainScreenWidth);
    // 需要将偏移量交给分类视图!
    _categoryView.offset_X = offsetX / 4;
    
    // 计算滚动
    //    NSInteger idx = offsetX / 4 / _categoryView.btnsArr[0].bounds.size.width + 0.5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    _pageIdx = offsetX / kMainScreenWidth;
    
    // 滚动 加载数据
    if (_pageIdx == 0) {
        if (!self.refreshPageOne) {
            self.refreshPageOne = YES;
            [self pushToMyOrderAllOrdersViewController];
        }
    } else if (_pageIdx == 1) {
        if (!self.refreshPageTwo) {
            self.refreshPageTwo = YES;
            [self pushToMyOrderWaitingForShipmentViewController];
        }
    } else if (_pageIdx == 2) {
        if (!self.refreshPageThree) {
            self.refreshPageThree = YES;
            [self pushToMyOrderWaitingForReceivingViewController];
        }
    } else if (_pageIdx == 3) {
        if (!self.refreshPageFour) {
            self.refreshPageFour = YES;
            [self pushToMyOrderWaitingForEvaluationViewController];
        }
    }
}

- (void)categoryViewValueChanged:(VENMyOrderCategoryView *)sender {
    
    // 1.获取页码数
    NSUInteger pageNumber = sender.pageNumber;
    _pageIdx = pageNumber;
    // 2.让scrollView滚动
    CGRect rect = CGRectMake(_scrollView.bounds.size.width * pageNumber, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView scrollRectToVisible:rect animated:_scrollAnimated];
    
    // 点击 加载数据
    if (_pageIdx == 0) {
        if (!self.refreshPageOne) {
            self.refreshPageOne = YES;
            [self pushToMyOrderAllOrdersViewController];
        }
    } else if (_pageIdx == 1) {
        if (!self.refreshPageTwo) {
            self.refreshPageTwo = YES;
            [self pushToMyOrderWaitingForShipmentViewController];
        }
    } else if (_pageIdx == 2) {
        if (!self.refreshPageThree) {
            self.refreshPageThree = YES;
            [self pushToMyOrderWaitingForReceivingViewController];
        }
    } else if (_pageIdx == 3) {
        if (!self.refreshPageFour) {
            self.refreshPageFour = YES;
            [self pushToMyOrderWaitingForEvaluationViewController];
        }
    }
}

- (void)setupUI {
    VENMyOrderCategoryView *categoryV = [[VENMyOrderCategoryView alloc] init];
    categoryV.backgroundColor = [UIColor whiteColor];
    [categoryV addTarget:self action:@selector(categoryViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:categoryV];
    
    [categoryV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(48);
    }];
        
    UIScrollView *scrollV = [self setupContentView];
    [self.view addSubview:scrollV];
    
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(categoryV);
        make.top.equalTo(categoryV.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    _categoryView = categoryV;
    _scrollView = scrollV;
}

// 负责创建底部滚动视图的方法
- (UIScrollView *)setupContentView {
    
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.backgroundColor = [UIColor whiteColor];
    scrollV.pagingEnabled = YES;
    scrollV.delegate = self;
    
    NSArray<NSString *> *vcNamesArr = @[@"VENMyOrderAllOrdersViewController", @"VENMyOrderWaitingForShipmentViewController", @"VENMyOrderWaitingForReceivingViewController", @"VENMyOrderWaitingForEvaluationViewController"];
                                        
    NSMutableArray<UIView *> *vcViewsArrM = [NSMutableArray array];
    
    [vcNamesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 2.1 创建vc对象
        Class cls = NSClassFromString(obj);
        UIViewController *vc = [[cls alloc] init];
        
        // 2.2 建立控制器的父子关系
        [self addChildController:vc intoView:scrollV];
        
        // 2.3添加控制器的视图到view中
        [vcViewsArrM addObject:vc.view];
        
    }];
    
    [vcViewsArrM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [vcViewsArrM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(scrollV);
        // 确定内容的高度
        make.bottom.top.equalTo(scrollV);
        
    }];
    
    return scrollV;
}

- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    // 添加子控制器 － 否则响应者链条会被打断，导致事件无法正常传递，而且错误非常难改！
    [self addChildViewController:childController];
    
    // 添加子控制器的视图
    [view addSubview:childController.view];
    
    // 完成子控制器的添加
    [childController didMoveToParentViewController:self];
}

#pragma mark - pushToSubviews
- (void)pushToMyOrderAllOrdersViewController {
    NSString *classNameString = @"VENMyOrderAllOrdersViewController";
    Class cls = NSClassFromString(classNameString);
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:cls]) {
            VENMyOrderAllOrdersViewController *vcc = (VENMyOrderAllOrdersViewController *)vc;
            [vcc.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)pushToMyOrderWaitingForShipmentViewController {
    NSString *classNameString = @"VENMyOrderWaitingForShipmentViewController";
    Class cls = NSClassFromString(classNameString);
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:cls]) {
            VENMyOrderWaitingForShipmentViewController *vcc = (VENMyOrderWaitingForShipmentViewController *)vc;
            [vcc.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)pushToMyOrderWaitingForReceivingViewController {
    NSString *classNameString = @"VENMyOrderWaitingForReceivingViewController";
    Class cls = NSClassFromString(classNameString);
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:cls]) {
            VENMyOrderWaitingForReceivingViewController *vcc = (VENMyOrderWaitingForReceivingViewController *)vc;
            [vcc.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)pushToMyOrderWaitingForEvaluationViewController {
    NSString *classNameString = @"VENMyOrderWaitingForEvaluationViewController";
    Class cls = NSClassFromString(classNameString);
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:cls]) {
            VENMyOrderWaitingForEvaluationViewController *vcc = (VENMyOrderWaitingForEvaluationViewController *)vc;
            [vcc.tableView.mj_header beginRefreshing];
            
        }
    }
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
