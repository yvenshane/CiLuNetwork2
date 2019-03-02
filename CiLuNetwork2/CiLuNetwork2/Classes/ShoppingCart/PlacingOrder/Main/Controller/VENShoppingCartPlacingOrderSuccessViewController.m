//
//  VENShoppingCartPlacingOrderSuccessViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/26.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENShoppingCartPlacingOrderSuccessViewController.h"
#import "VENMyOrderOrderDetailsViewController.h"

@interface VENShoppingCartPlacingOrderSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *viewOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *continueBuyButton;

@end

@implementation VENShoppingCartPlacingOrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"下单成功";
    
    self.viewOrderButton.layer.cornerRadius = 4.0f;
    self.viewOrderButton.layer.masksToBounds = YES;
    self.viewOrderButton.layer.borderWidth = 1.0f;
    self.viewOrderButton.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    
    self.continueBuyButton.layer.cornerRadius = 4.0f;
    self.continueBuyButton.layer.masksToBounds = YES;
    self.continueBuyButton.layer.borderWidth = 1.0f;
    self.continueBuyButton.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    
    [self setupFinishButton];
    [self setupNavigationItemLeftBarButtonItem];
}

#pragma marl - 查看订单
- (IBAction)checkOrderButtonClick:(id)sender {
    VENMyOrderOrderDetailsViewController *vc = [[VENMyOrderOrderDetailsViewController alloc] init];
    vc.order_id = self.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma marl - 继续逛逛
- (IBAction)continueShopping:(id)sender {
    if (self.isMyOrder) {

        NSDictionary *dict = @{@"status" : @"2",
                               @"status_text" : @"待发货",
                               @"index" : [NSString stringWithFormat:@"%ld", (long)self.index]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrder" object:dict];
        
        if (self.isMyOrderDetail) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrderDetail" object:nil];
        }
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:((int)[[self.navigationController viewControllers]indexOfObject:self] -2)] animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:@"pushToClassify"];
    }
}

- (void)setupFinishButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)backButtonClick {
    if (self.isMyOrder) {
        
        NSDictionary *dict = @{@"status" : @"2",
                               @"status_text" : @"待发货",
                               @"index" : [NSString stringWithFormat:@"%ld", self.index]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrder" object:dict];
        
        if (self.isMyOrderDetail) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrderDetail" object:nil];
        }
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:((int)[[self.navigationController viewControllers]indexOfObject:self] -2)] animated:YES];
            
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:nil];
    }
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
