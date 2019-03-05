//
//  AppDelegate.m
//  CiLuNetwork2
//
//  Created by YVEN on 2019/3/2.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "VENTabBarController.h"
//#import "UPPaymentControl.h"

@interface AppDelegate ()
//<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:kMainScreenFrameRect];
    _window.rootViewController = [[VENTabBarController alloc] init];
    [_window makeKeyAndVisible];
    
#pragma mark - 请求公共数据
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"app/metaData" params:nil showLoading:NO successBlock:^(id response) {

        if ([response[@"status"] integerValue] == 0) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response[@"data"] forKey:@"metaData"];
            
            
        }

    } failureBlock:^(NSError *error) {

    }];
    
    // 注册微信 APPID
//    [WXApi registerApp:@"wx6132aa5b6edb38e6" enableMTA:NO];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//#pragma mark - 支付成功回调
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    
//    NSLog(@"url.host - %@", url.host);
//    
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            
//            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALIPAY_RESULTDIC" object:resultDic];
//            } else {
//                [[VENMBProgressHUDManager sharedManager] showText:resultDic[@"memo"]];
//            }
//        }];
//    } else if ([url.host isEqualToString:@"pay"]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    } else if ([url.host isEqualToString:@"uppayresult"] || [url.host isEqualToString:@"paydemo"]) {
//        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
//            if([code isEqualToString:@"success"]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"UNIONPAY_RESULTDIC" object:nil];
//            } else if ([code isEqualToString:@"fail"]) {
//                [[VENMBProgressHUDManager sharedManager] showText:@"交易失败"];
//            } else if ([code isEqualToString:@"cancel"]) {
//                [[VENMBProgressHUDManager sharedManager] showText:@"交易取消"];
//            }
//        }];
//    }
//    return YES;
//}
//
//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
//    
//    NSLog(@"url.host - %@", url.host);
//    
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            
//            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"ALIPAY_RESULTDIC" object:resultDic];
//            } else {
//                [[VENMBProgressHUDManager sharedManager] showText:resultDic[@"memo"]];
//            }
//        }];
//    } else if ([url.host isEqualToString:@"pay"]) {
//        return [WXApi handleOpenURL:url delegate:self];
//    } else if ([url.host isEqualToString:@"uppayresult"] || [url.host isEqualToString:@"paydemo"]) {
//        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
//            if([code isEqualToString:@"success"]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"UNIONPAY_RESULTDIC" object:nil];
//            } else if ([code isEqualToString:@"fail"]) {
//                [[VENMBProgressHUDManager sharedManager] showText:@"交易失败"];
//            } else if ([code isEqualToString:@"cancel"]) {
//                [[VENMBProgressHUDManager sharedManager] showText:@"交易取消"];
//            }
//        }];
//    }
//    return YES;
//}
//
//- (void)onResp:(BaseResp *)resp {
//    if ([resp isKindOfClass:[PayResp class]]) {// 微信支付
//        PayResp *response = (PayResp *)resp;
//        switch (response.errCode) {
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                [[VENMBProgressHUDManager sharedManager] showText:@"支付成功"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_RESULTDIC" object:nil];
//                break;
//            case WXErrCodeUserCancel:
//                [[VENMBProgressHUDManager sharedManager] showText:@"用户点击取消并返回"];
//                break;
//            default:
//                [[VENMBProgressHUDManager sharedManager] showText:[NSString stringWithFormat:@"支付失败，错误码：%d", resp.errCode]];
//                break;
//        }
//    } else if ([resp isKindOfClass:[SendAuthResp class]]) {// 微信登录
//        SendAuthResp *rep = (SendAuthResp *)resp;
//        
//        /**
//         ERR_OK = 0(用户同意)
//         ERR_AUTH_DENIED = -4（用户拒绝授权）
//         ERR_USER_CANCEL = -2（用户取消）
//         */
//        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//        
//        NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WeChat_Url, WeChat_AppID, WeChat_AppSecret, rep.code];
//        
//        [manager GET:accessUrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            
//            NSLog(@"%@", responseObject);
//            
//            /**
//             "access_token" = "18_LoQiMvHQWcE960iJahqyeh1pCeL7_zYtFvCI3dbRTor-WmMz4iBPeJ4yXOjEG7A8g_mEkzCeKan_13wnW8CL6c8-o8IuoAqXHKs2npoPPpk";
//             "expires_in" = 7200;
//             openid = ohzja5tvZzXZfMCnxNJXAYdmr4Vg;
//             "refresh_token" = "18_P4quxWt4SUrloDv5a0mvY2giqGPRzHMKG6DzQtvLtKEigxmmrYJWXgqvF_cg4iaSM1qhVkcYckPVKPYX6mdOMUEgGkzwWRgu8Utkajfcmbk";
//             scope = "snsapi_userinfo";
//             unionid = "o-90H594QFXz6vHdtxnOZ9jlmMmQ";
//             */
//            
//            NSDictionary *tempDict = responseObject;
//            
//            if (![[VENClassEmptyManager sharedManager] isEmptyString:tempDict[@"access_token"]] &&
//                ![[VENClassEmptyManager sharedManager] isEmptyString:tempDict[@"openid"]]) {
//                
//                [[NSUserDefaults standardUserDefaults] setObject:tempDict[@"access_token"] forKey:@"access_token"];
//                [[NSUserDefaults standardUserDefaults] setObject:tempDict[@"openid"] forKey:@"openid"];
//                [[NSUserDefaults standardUserDefaults] setObject:tempDict[@"refresh_token"] forKey:@"refresh_token"];
//            }
//            
//            // 获取用户个人信息
//            NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
//            NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"];
//            NSString *url = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WeChat_Url, access_token, openid];
//            
//            [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"请求用户信息的response = %@", responseObject);
//                
//                NSDictionary *params = @{@"union_id" : responseObject[@"unionid"]};
//                
//                [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"auth/wechatLogin" params:params showLoading:NO successBlock:^(id response) {
//                    
//                    if ([response[@"status"] integerValue] == 0) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"WechatLoggedInSuccessfully" object:response[@"data"][@"token"]];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshShoppingCart" object:nil];
//                        NSLog(@"微信登录成功");
//                    } else if ([response[@"status"] integerValue] == 10090) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"VerificationOfPhoneNumber" object:responseObject[@"unionid"]];
//                        NSLog(@"微信登录绑定");
//                    }
//                    
//                } failureBlock:^(NSError *error) {
//                    
//                }];
//                
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"获取用户个人信息时出错 = %@", error);
//            }];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"获取access_token时出错 = %@", error);
//        }];
//    }
//}

@end
