//
//  VENPersonalSettingsViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/15.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPersonalSettingsViewController.h"
#import "VENMineTableViewCellStyleOne.h"

#import "VENPersonalDataViewController.h"
#import "VENResetPasswordViewController.h"
#import "VENAboutUsViewController.h"
#import "VENOnlineMessageViewController.h"

@interface VENPersonalSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENPersonalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人设置";
    
    [self setupTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMineTableViewCellStyleOne *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *titleArr = @[@[@"个人资料", @"修改密码"], @[@"关于我们"], @[@"在线留言", @"清除缓存"]];
    cell.leftLabel.text = titleArr[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 个人资料
            VENPersonalDataViewController *vc = [[VENPersonalDataViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) { // 修改密码
            VENResetPasswordViewController *vc = [[VENResetPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        NSDictionary *metaData = [[NSUserDefaults standardUserDefaults] objectForKey:@"metaData"];
        VENAboutUsViewController *vc = [[VENAboutUsViewController alloc] init];
        vc.isPush = YES;
        vc.navigationItem.title = @"关于我们";
        vc.HTMLString = metaData[@"about_us"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (indexPath.row == 0) { // 在线留言
            VENOnlineMessageViewController *vc = [[VENOnlineMessageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else { // 清除缓存
            
            [[VENMBProgressHUDManager sharedManager] addLoading];
//            [[VENMBProgressHUDManager sharedManager] showText:@"清除缓存中"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[VENMBProgressHUDManager sharedManager] removeLoading];
                [[VENMBProgressHUDManager sharedManager] showText:@"清除缓存成功"];
            });
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *footerView = [[UIView alloc] init];
        UIButton *loginoutButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 18, kMainScreenWidth - 30, 48)];
        loginoutButton.backgroundColor = [UIColor whiteColor];
        [loginoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [loginoutButton setTitleColor:UIColorFromRGB(0xD0021B) forState:UIControlStateNormal];
        [loginoutButton addTarget:self action:@selector(loginoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        loginoutButton.layer.cornerRadius = 4.0f;
        loginoutButton.layer.masksToBounds = YES;
        loginoutButton.layer.borderWidth = 1.0f;
        loginoutButton.layer.borderColor = UIColorFromRGB(0xD0021B).CGColor;
        [footerView addSubview:loginoutButton];
        
        return footerView;
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 48 + 18 : 0.01;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCellStyleOne" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

- (void)loginoutButtonClick {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 登录
    [userDefaults removeObjectForKey:@"token"];
    
//    // 微信登录
//    [userDefaults removeObjectForKey:@"access_token"];
//    [userDefaults removeObjectForKey:@"openid"];
//    [userDefaults removeObjectForKey:@"refresh_token"];

    self.block(@"loginoutSuccess");
    
    // 刷新 首页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetHomePage" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
    
    [self.tabBarController.tabBar.items[2] setBadgeValue:nil];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RedDot"];
    
    [self.navigationController popViewControllerAnimated:YES];
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
