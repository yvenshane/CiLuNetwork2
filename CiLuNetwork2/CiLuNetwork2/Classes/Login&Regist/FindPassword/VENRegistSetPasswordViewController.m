//
//  VENRegistSetPasswordViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegistSetPasswordViewController.h"

@interface VENRegistSetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField2;

@property (nonatomic, assign) BOOL passwordTextField1Status;
@property (nonatomic, assign) BOOL passwordTextField2Status;

@end

@implementation VENRegistSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"手机号: %@", self.phoneCode);
    NSLog(@"验证码: %@", self.verificationCode);
//    NSLog(@"邀请码: %@", self.invitationCode);

    [self.passwordTextField1 addTarget:self action:@selector(passwordTextField1Changed:) forControlEvents:UIControlEventEditingChanged];
    
    [self.passwordTextField2 addTarget:self action:@selector(passwordTextField2Changed:) forControlEvents:UIControlEventEditingChanged];
}

- (void)passwordTextField1Changed:(UITextField*)textField {
    self.passwordTextField1Status = textField.text.length >= 6 ? YES : NO;
    self.registerButton.backgroundColor = self.passwordTextField1Status == YES && self.passwordTextField2Status == YES ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
    
    NSLog(@"%d", self.passwordTextField1Status);
}

- (void)passwordTextField2Changed:(UITextField*)textField {
    self.passwordTextField2Status = textField.text.length >= 6 ? YES : NO;
    self.registerButton.backgroundColor = self.passwordTextField1Status == YES && self.passwordTextField2Status == YES ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
    
    NSLog(@"%d", self.passwordTextField2Status);
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerButtonClick:(id)sender {
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.passwordTextField1.text] || self.passwordTextField1.text.length < 6) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入新密码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.passwordTextField2.text] || self.passwordTextField2.text.length < 6) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请重复密码"];
        return;
    }
    
    if (![self.passwordTextField1.text isEqualToString:self.passwordTextField2.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"两次输入的密码不一致"];
        return;
    }
    
    if (![[VENClassEmptyManager sharedManager] isEmptyString:self.phoneCode] && ![[VENClassEmptyManager sharedManager] isEmptyString:self.verificationCode]) {
        
        NSDictionary *params = @{@"mobile" : self.phoneCode,
                                 @"password" : self.passwordTextField1.text,
                                 @"repeat_password" : self.passwordTextField2.text};
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"auth/resetPassword" params:params showLoading:YES successBlock:^(id response) {
            
            if ([response[@"status"] integerValue] == 10021) {
                [[VENMBProgressHUDManager sharedManager] showText:response[@"message"]];
                return;
            }
            
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        } failureBlock:^(NSError *error) {
            
        }];
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
