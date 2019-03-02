//
//  VENMBProgressHUDManager.m
//
//  Created by YVEN.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMBProgressHUDManager.h"

static VENMBProgressHUDManager *instance;
static dispatch_once_t onceToken;
@implementation VENMBProgressHUDManager

+ (instancetype)sharedManager {

    dispatch_once(&onceToken, ^{
        instance = [[VENMBProgressHUDManager alloc] init];
    });
    return instance;
}

- (void)showText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:2.0f];
    hud.userInteractionEnabled = NO;
}

- (void)addLoading {
    UIView *view = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:view];
    progressHUD.removeFromSuperViewOnHide = YES;
    [view addSubview:progressHUD];
    [progressHUD show:YES];
}

- (void)removeLoading {
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
