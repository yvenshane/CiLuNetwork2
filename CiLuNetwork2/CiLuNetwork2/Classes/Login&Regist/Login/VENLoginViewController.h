//
//  VENLoginViewController.h
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^loginSuccessBlock)(NSString *);
@interface VENLoginViewController : UIViewController
@property (nonatomic, copy) loginSuccessBlock block;

@end
