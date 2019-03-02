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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"VerificationOfPhoneNumber" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter2:) name:@"WechatLoggedInSuccessfully" object:nil];
}

#pragma mark - 微信登录 验证注册
- (void)notificationCenter:(NSNotification *)noti {
    VENVerificationOfPhoneNumberViewController *vc = [[VENVerificationOfPhoneNumberViewController alloc] init];
    vc.union_id = noti.object;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)notificationCenter2:(NSNotification *)noti {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:noti.object forKey:@"token"];
    
    self.block(@"loginSuccess");
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WechatLoggedInSuccessfully" object:response[@"data"][@"token"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:nil];
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

#pragma mark - 微信登录
- (IBAction)wxLoginButtonClick:(id)sender {
//    if ([WXApi isWXAppInstalled]) { // 是否安装微信
//        
//        NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
//        NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"];
//        
//        if (access_token && openid) {
//            
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//            
//            NSString *refresh_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
//            NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WeChat_Url, WeChat_AppID, refresh_token];
//            
//            [manager GET:refreshUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"请求reAccess的response = %@", responseObject);
//                
//                NSDictionary *tempDict = responseObject;
//                NSString *tempAccessToken = tempDict[@"access_token"];
//                
//                // 如果 tempAccessToken 为空 说明 tempAccessToken 也过期了,反之则没有过期
//                if (tempAccessToken) {
//
//                    [[NSUserDefaults standardUserDefaults] setObject:tempDict[@"access_token"] forKey:@"access_token"];
//                    [[NSUserDefaults standardUserDefaults] setObject:tempDict[@"openid"] forKey:@"openid"];
//                    [[NSUserDefaults standardUserDefaults] setObject:tempDict[@"refresh_token"] forKey:@"refresh_token"];
//                    
//                    // 获取用户个人信息
//                    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
//                    NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"];
//                    NSString *url = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WeChat_Url, access_token, openid];
//                    
//                    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                        NSLog(@"请求用户信息的response = %@", responseObject);
//                        
//                        NSDictionary *params = @{@"union_id" : responseObject[@"unionid"]};
//                        
//                        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"auth/wechatLogin" params:params showLoading:NO successBlock:^(id response) {
//                            
//                            if ([response[@"status"] integerValue] == 0) {
//                                NSLog(@"微信登录成功");
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"WechatLoggedInSuccessfully" object:response[@"data"][@"token"]];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:nil];
//                            } else if ([response[@"status"] integerValue] == 10090) {
//                                NSLog(@"微信登录绑定");
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"VerificationOfPhoneNumber" object:responseObject[@"unionid"]];
//                            }
//                            
//                        } failureBlock:^(NSError *error) {
//                            
//                        }];
//                        
//                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        NSLog(@"获取用户个人信息时出错 = %@", error);
//                    }];
//                    
//                } else {
//                    SendAuthReq *req = [[SendAuthReq alloc] init];
//                    req.scope = @"snsapi_userinfo";
//                    req.state = @"CiLuNetwork";
//                    [WXApi sendReq:req];
//                }
//                
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                
//            }];
//            
//        } else {
//            SendAuthReq *req = [[SendAuthReq alloc] init];
//            req.scope = @"snsapi_userinfo";
//            req.state = @"CiLuNetwork";
//            [WXApi sendReq:req];
//        }
//        
//    } else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:actionConfirm];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
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
