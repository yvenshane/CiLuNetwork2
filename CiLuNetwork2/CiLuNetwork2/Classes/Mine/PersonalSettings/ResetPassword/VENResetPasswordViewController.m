//
//  VENResetPasswordViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/29.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENResetPasswordViewController.h"

@interface VENResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldThree;

@end

@implementation VENResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"修改密码";

    [self setupSaveButton];
}

- (void)setupSaveButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)saveButtonClick {
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.textFieldOne.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入原密码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.textFieldTwo.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入新密码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.textFieldThree.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入重复密码"];
        return;
    }
    
    NSDictionary *params = @{@"origin_password" : self.textFieldOne.text,
                             @"new_password" : self.textFieldTwo.text,
                             @"repeat_password" : self.textFieldThree.text};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"setting/modifyPassword" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
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
