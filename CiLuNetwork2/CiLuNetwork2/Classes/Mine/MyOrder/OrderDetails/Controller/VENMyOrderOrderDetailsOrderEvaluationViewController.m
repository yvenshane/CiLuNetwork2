//
//  VENMyOrderOrderDetailsOrderEvaluationViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/28.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOrderOrderDetailsOrderEvaluationViewController.h"

@interface VENMyOrderOrderDetailsOrderEvaluationViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation VENMyOrderOrderDetailsOrderEvaluationViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"订单评价";
    
    self.view.backgroundColor = UIColorMake(248, 248, 248);

    self.contentTextView.delegate = self;
    
    [self setupCommitButton];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

- (void)setupCommitButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)commitButtonClick {
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.contentTextView.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"本次购物您满意吗，还有什么想说的～"];
        return;
    }
    
    NSDictionary *params = @{@"order_id" : self.order_id,
                             @"comment" : self.contentTextView.text};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"home/applyComment" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"response"] integerValue] == 0) {
            if ([self.pushFrom isEqualToString:@"列表页"]) {
                NSDictionary *dict = @{@"status" : @"20",
                                       @"status_text" : @"已完成",
                                       @"index" : [NSString stringWithFormat:@"%ld", self.index]};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOrder" object:dict];
            } else if ([self.pushFrom isEqualToString:@"详情页"]) {
                self.block(@"");
            } else if ([self.pushFrom isEqualToString:@"待评价"]) {
                self.block(@"");
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
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
