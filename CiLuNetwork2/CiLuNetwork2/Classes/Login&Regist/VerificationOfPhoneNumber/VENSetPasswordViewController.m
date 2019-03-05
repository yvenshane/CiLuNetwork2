//
//  VENSetPasswordViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSetPasswordViewController.h"
#import "VENLoginViewController.h"
#import "VENAboutUsViewController.h"

@interface VENSetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *setPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@property (nonatomic, assign) BOOL setPasswordTextFieldStatus;
@property (nonatomic, assign) BOOL rePasswordTextFieldStatus;

@end

@implementation VENSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.registButton.layer.cornerRadius = 4.0f;
    self.registButton.layer.masksToBounds = YES;
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@"点击立即注册代表您同意《用户注册服务协议》"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:COLOR_THEME range:NSMakeRange(attributedStr.length - 10, 10)];
    self.otherLabel.attributedText = attributedStr;
    
    [self.setPasswordTextField addTarget:self action:@selector(setPasswordTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.rePasswordTextField addTarget:self action:@selector(rePasswordTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setPasswordTextFieldChanged:(UITextField *)textField {
    self.setPasswordTextFieldStatus = textField.text.length >= 6 ? YES : NO;
    self.registButton.backgroundColor = self.setPasswordTextFieldStatus == YES && self.rePasswordTextFieldStatus == YES ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
}

- (void)rePasswordTextFieldChanged:(UITextField *)textField {
    self.rePasswordTextFieldStatus = textField.text.length >= 6 ? YES : NO;
    self.registButton.backgroundColor = self.setPasswordTextFieldStatus == YES && self.rePasswordTextFieldStatus == YES ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
}

#pragma mark - 注册
- (IBAction)registerButtonClick:(id)sender {
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.setPasswordTextField.text] || self.setPasswordTextField.text.length < 6) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请设置密码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.rePasswordTextField.text] || self.setPasswordTextField.text.length < 6) {
        
        if (![self.setPasswordTextField.text isEqualToString:self.rePasswordTextField.text]) {
            [[VENMBProgressHUDManager sharedManager] showText:@"两次密码输入不一致"];
            return;
        }
        
        [[VENMBProgressHUDManager sharedManager] showText:@"请设置密码"];
        return;
    }
    
    NSDictionary *params = @{@"mobile" : self.mobile,
                             @"password" : self.setPasswordTextField.text,
                             @"repeat_password" : self.rePasswordTextField.text,
                             @"foundation": self.foundation};
                             
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"auth/register" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
//            // 刷新 首页
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetHomePage" object:nil];
//            // 刷新 分类页面
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Reset" object:nil];

            // dismiss
            UIViewController * presentingViewController = self.presentingViewController;
            do {
                if ([presentingViewController isKindOfClass:[VENLoginViewController class]]) {
                    break;
                }
                presentingViewController = presentingViewController.presentingViewController;
                
            } while (presentingViewController.presentingViewController);
            
            [presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 用户注册协议
- (IBAction)otherButtonClick:(id)sender {
    NSDictionary *metaData = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"];
    
    VENAboutUsViewController *vc = [[VENAboutUsViewController alloc] init];
    vc.isPush = NO;
    vc.navigationItem.title = @"用户注册服务协议";
    vc.HTMLString = metaData[@"user_licence"];
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
