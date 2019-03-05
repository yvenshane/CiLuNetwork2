//
//  VENVerificationOfPhoneNumberViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENVerificationOfPhoneNumberViewController.h"
#import "VENSetPasswordViewController.h"

@interface VENVerificationOfPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getverificationCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, assign) BOOL phoneTextFieldStatus;
@property (nonatomic, assign) BOOL verificationCodeTextFieldStatus;

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, copy) NSString *foundation;

@end

@implementation VENVerificationOfPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nextButton.layer.cornerRadius = 4.0f;
    self.nextButton.layer.masksToBounds = YES;

    [self.phoneTextField addTarget:self action:@selector(phoneTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.verificationCodeTextField addTarget:self action:@selector(verificationCodeTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)choiceButtonClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择所属基金会" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSDictionary *foundationList = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"][@"foundationList"];
    for (NSDictionary *dict in foundationList) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:dict[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.foundation = [dict[@"id"] stringValue];
            [self.choiceButton setTitle:dict[@"name"] forState:UIControlStateNormal];
            
            // 改变按钮颜色
            self.nextButton.backgroundColor = self.phoneTextFieldStatus == YES && self.verificationCodeTextFieldStatus == YES && ![[VENClassEmptyManager sharedManager] isEmptyString:self.foundation] ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)phoneTextFieldChanged:(UITextField *)textField {
    self.phoneTextFieldStatus = textField.text.length == 11 ? YES : NO;
    self.nextButton.backgroundColor = self.phoneTextFieldStatus == YES && self.verificationCodeTextFieldStatus == YES && ![[VENClassEmptyManager sharedManager] isEmptyString:self.foundation] ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
    
    NSLog(@"%d", self.phoneTextFieldStatus);
}

- (void)verificationCodeTextFieldChanged:(UITextField *)textField {
    self.verificationCodeTextFieldStatus = textField.text.length == 4 ? YES : NO;
    self.nextButton.backgroundColor = self.phoneTextFieldStatus == YES && self.verificationCodeTextFieldStatus == YES && ![[VENClassEmptyManager sharedManager] isEmptyString:self.foundation] ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
    
    NSLog(@"%d", self.verificationCodeTextFieldStatus);
}

#pragma mark - 获取验证码
- (IBAction)getVerificationCodeButtonClick:(id)sender {
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.phoneTextField.text] || self.phoneTextField.text.length != 11) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入手机号码"];
        return;
    }
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"auth/getSmsCode" params:@{@"mobile" : self.phoneTextField.text} showLoading:YES successBlock:^(id response) {
        
        self.seconds = 60;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeFireMethod {
    _seconds--;
    
    self.getverificationCodeButton.userInteractionEnabled = NO;
    
    // titleLabel.text 解决频繁刷新 Button 闪烁的问题
    self.getverificationCodeButton.titleLabel.text = [NSString stringWithFormat:@"重获%lds", (long)_seconds];
    [self.getverificationCodeButton setTitle:[NSString stringWithFormat:@"重获%lds", (long)_seconds] forState:UIControlStateNormal];
    
    if(_seconds == 0) {
        [_countDownTimer invalidate];
        [self.getverificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getverificationCodeButton.userInteractionEnabled = YES;
    }
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextButtonClick:(id)sender {
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.phoneTextField.text] || self.phoneTextField.text.length != 11) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入手机号码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.verificationCodeTextField.text] || self.verificationCodeTextField.text.length != 4) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入验证码"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.foundation]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请选择所属基金会"];
        return;
    }
    
    NSDictionary *params = @{@"mobile" : self.phoneTextField.text,
                             @"code" : self.verificationCodeTextField.text,
                             @"type" : @"1"};
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"auth/verifyMobile" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            VENSetPasswordViewController *vc = [[VENSetPasswordViewController alloc] init];
            vc.mobile = self.phoneTextField.text;
            vc.foundation = self.foundation;
            [self presentViewController:vc animated:YES completion:nil];
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
