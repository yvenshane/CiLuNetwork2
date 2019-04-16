//
//  VENLoginViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLoginViewController.h"
#import "VENRegistViewController.h"
#import "VENVerificationOfPhoneNumberViewController.h"

@interface VENLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *wxLoginButton;

@property (nonatomic, assign) BOOL phoneTextFieldStatus;
@property (nonatomic, assign) BOOL passwordTextFieldStatus;

@end

@implementation VENLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loginButton.layer.cornerRadius = 4.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    self.wxLoginButton.layer.cornerRadius = 4.0f;
    self.wxLoginButton.layer.masksToBounds = YES;
    
    [self.phoneTextField addTarget:self action:@selector(phoneTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}
    
- (void)phoneTextFieldChanged:(UITextField*)textField {
    self.phoneTextFieldStatus = textField.text.length == 11 ? YES : NO;
    self.loginButton.backgroundColor = self.phoneTextFieldStatus == YES && self.passwordTextFieldStatus == YES ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
    
    NSLog(@"%d", self.phoneTextFieldStatus);
}

- (void)passwordTextFieldChanged:(UITextField*)textField {
    self.passwordTextFieldStatus = textField.text.length >= 6 ? YES : NO;
    self.loginButton.backgroundColor = self.phoneTextFieldStatus == YES && self.passwordTextFieldStatus == YES ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
    
    NSLog(@"%d", self.passwordTextFieldStatus);
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 登录
- (IBAction)loginButtonClick:(id)sender {
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.phoneTextField.text] || self.phoneTextField.text.length != 11) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入手机号码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.passwordTextField.text] || self.passwordTextField.text.length < 6) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入密码"];
        return;
    }
    
    NSDictionary *params = @{@"mobile" : self.phoneTextField.text,
                             @"password" : self.passwordTextField.text};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"auth/login" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            // 刷新 首页
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetHomePage" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:nil];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response[@"data"][@"token"] forKey:@"token"];
            
            self.block(@"loginSuccess");
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 注册新用户
- (IBAction)registButtonClick:(id)sender {
    VENVerificationOfPhoneNumberViewController *vc = [[VENVerificationOfPhoneNumberViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 忘记密码
- (IBAction)findPasswordButtonClick:(id)sender {
    VENRegistViewController *vc = [[VENRegistViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
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
