//
//  VENNetworkTool.m
//
//  Created by YVEN.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNetworkTool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AdSupport/AdSupport.h>
//#import "VENLoginViewController.h"

@interface VENNetworkTool ()
@property (nonatomic, assign) BOOL isConnectInternet;
@property (nonatomic, assign) BOOL hasCheckNetwork;

@end

static VENNetworkTool *instance;
static dispatch_once_t onceToken;
@implementation VENNetworkTool

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[VENNetworkTool alloc] initWithBaseURL:[NSURL URLWithString:@"http://liqixiong.ahaiba.com/"]];
    });
    return instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //request
        self.requestSerializer.timeoutInterval = 15;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Login"][@"userid"] forHTTPHeaderField:@"userid"];
        self.requestSerializer.HTTPShouldHandleCookies = YES;
        
        //response
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return self;
}

- (void)requestWithMethod:(HTTPMethod)method path:(NSString *)path params:(NSDictionary *)params showLoading:(BOOL)isShow successBlock:(SuccessBlock)success failureBlock:(FailureBlock)failure {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [self.requestSerializer setValue:![[VENClassEmptyManager sharedManager] isEmptyString:token] ? token : @"" forHTTPHeaderField:@"Authorization"];
    
    path = [[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] lowercaseString];
    NSLog(@"请求接口：%@", path);
    
    if (!_isConnectInternet && _hasCheckNetwork) {
        
        if (failure) {
            failure(nil);
        }
        
        [[VENMBProgressHUDManager sharedManager] showText:@"网络连接已断开，请检查网络!"];
        return;
    }
    
    if (params == nil) {
        params = @{};
    }
    
    

    //移除空value的字典键值、避免签名失败、服务器返回forbidden
    NSMutableDictionary *mutableParams = [params mutableCopy];
    
    for (NSString *tempKey in [params allKeys]) {
        NSString *tempValue = [NSString stringWithFormat:@"%@", [params objectForKey:tempKey]];
        if (tempValue.length == 0) {
            [mutableParams removeObjectForKey:tempKey];
        }
    }
    
    NSLog(@"请求参数：%@", mutableParams);
    
    switch (method) {
        case HTTPMethodGet:{
            [self showLoading:isShow];
            [self GET:path parameters:mutableParams progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                [self hideLoading:isShow];
                NSLog(@"%@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [self hideLoading:isShow];
                failure(error);
            }];
            break;
        }
        case HTTPMethodPost:{
            [self showLoading:isShow];
            [self POST:path parameters:mutableParams progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                [self hideLoading:isShow];
                
                NSLog(@"%@", responseObject);
                
                if (![responseObject[@"message"] isEqualToString:@"请求成功"]) {
                    [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"message"]];
                }
                
                if ([responseObject[@"status"] integerValue] == 10099) {
                    NSLog(@"10099");
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        VENLoginViewController *vc = [[VENLoginViewController alloc] init];
//                        vc.block = ^(NSString *str) {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMinePage" object:nil];
//                        };
//                        [[self findCurrentViewController] presentViewController:vc animated:YES completion:nil];
                    });
                }
                
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [self hideLoading:isShow];
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)startMonitorNetworkWithBlock:(NetworkStatusBlock)block {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                self.isConnectInternet = NO;
                if (block) {
                    block(@"unknown");
                }
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                self.isConnectInternet = NO;
                if (block) {
                    block(@"offline");
                }
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                self.isConnectInternet = YES;
                if (block) {
                    block(@"cell");
                }
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                self.isConnectInternet = YES;
                if (block) {
                    block(@"wifi");
                }
                
                break;
            default:
                self.isConnectInternet = NO;
                break;
        }
        
        self.hasCheckNetwork = YES;
    }];
    
    [mgr startMonitoring];
    
}

- (void)showLoading:(BOOL)isShow {
    if (isShow) {
        //显示loading
        [[VENMBProgressHUDManager sharedManager] addLoading];
    }
}

- (void)hideLoading:(BOOL)isShow {
    if (isShow) {
        //隐藏正在显示的loading
        [[VENMBProgressHUDManager sharedManager] removeLoading];
    }
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)getIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

#pragma mark 上传单张图片
- (void)uploadImageWithPath:(NSString *)path image:(UIImage *)image name:(NSString *)name params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSArray *array;
    if (image == nil) {
        array = @[];
    } else {
        array = [NSArray arrayWithObject:image];
    }
    
    [self uploadImageWithPath:path photos:array name:name params:params success:success failure:failure];
}

#pragma mark 上传图片
- (void)uploadImageWithPath:(NSString *)path photos:(NSArray *)photos name:(NSString *)name params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    path = [[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] lowercaseString];
    
    NSLog(@"请求接口：%@", path);
    
    if (params == nil) {
        params = @{};
    }
    
    NSLog(@"请求参数：%@", params);
    
    NSLog(@"photos：%@", photos);
    
    [self POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < photos.count; i ++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];

            UIImage *image = photos[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);

            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        [[VENMBProgressHUDManager sharedManager] showText:responseObject[@"message"]];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (UIViewController *)findCurrentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}

@end
