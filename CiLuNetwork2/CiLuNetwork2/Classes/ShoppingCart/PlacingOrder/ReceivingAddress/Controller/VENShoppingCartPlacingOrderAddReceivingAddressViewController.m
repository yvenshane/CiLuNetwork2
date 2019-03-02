//
//  VENShoppingCartPlacingOrderAddReceivingAddressViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/24.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENShoppingCartPlacingOrderAddReceivingAddressViewController.h"
#import "VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell.h"
#import "VENCityPickerView.h"
#import "VENShoppingCartPlacingOrderReceivingAddressModel.h"

@interface VENShoppingCartPlacingOrderAddReceivingAddressViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, strong) VENCityPickerView *cityPickerView;

@property (nonatomic, copy) NSString *provinceID;
@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *districtID;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENShoppingCartPlacingOrderAddReceivingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.isEdit ? @"编辑收货地址" : @"新增收货地址";
    
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        NSLog(@"所在区域");
        
        [tableView endEditing:YES];
        
        [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"address/data" params:nil showLoading:YES successBlock:^(id response) {
            
            if (self.cityPickerView == nil) {
                VENCityPickerView *cityPickerView = [[VENCityPickerView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 260, kMainScreenWidth, 260) forData:response[@"data"]];
                cityPickerView.block = ^(NSDictionary *dict) {
                    
                    [self.cityPickerView removeFromSuperview];
                    self.cityPickerView = nil;
                    
                    if ([[VENClassEmptyManager sharedManager] isEmptyString:[dict objectForKey:@"status"]]) {
                            VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell *regionCell = (VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                        
                        regionCell.rightTextField.text = [NSString stringWithFormat:@"%@%@%@", dict[@"provinceName"], dict[@"cityName"], dict[@"regionName"]];
                        
                        self.provinceID = dict[@"provinceID"];
                        self.cityID = dict[@"cityID"];
                        self.districtID = dict[@"regionID"];
                    }
                };
                [self.view addSubview:cityPickerView];
                self.cityPickerView = cityPickerView;
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 3 ? 64 : 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.leftLabel.text = @"联系人";
        cell.rightTextField.placeholder = @"请填写联系人姓名";
        cell.rightTextField.text = self.model.username;
    } else if (indexPath.row == 1) {
        cell.leftLabel.text = @"手机号码";
        cell.rightTextField.placeholder = @"请填写联系人手机号";
        cell.rightTextField.text = self.model.mobile;
    } else if (indexPath.row == 2) {
        cell.leftLabel.text = @"所在区域";
        cell.rightTextField.placeholder = @"请选择所在区域";
        cell.rightTextField.text = self.model.region;
    } else if (indexPath.row == 3) {
        cell.leftLabel.text = @"详细地址";
        cell.rightTextView.text = [self.model.detail substringFromIndex:self.model.region.length];
    }
    
    cell.rightTextField.keyboardType = indexPath.row == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    
    cell.rightTextField.hidden = indexPath.row == 3 ? YES : NO;
    cell.rightTextView.hidden = indexPath.row == 3 ? NO : YES;
    
    cell.rightTextField.userInteractionEnabled = indexPath.row == 2 ? NO : YES;
    cell.rightImageView.hidden = indexPath.row == 2 ? NO : YES;
    
    if (indexPath.row == 3) {
        if (self.placeholderLabel == nil) {
            cell.rightTextView.delegate = self;
            
            UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 15, kMainScreenWidth - 103 - 15, 17)];
            placeholderLabel.text = @"请填写详细地址";
            placeholderLabel.font = [UIFont systemFontOfSize:14.0f];
            placeholderLabel.textColor = UIColorFromRGB(0xCCCCCC);
            placeholderLabel.hidden = [[VENClassEmptyManager sharedManager] isEmptyString:cell.rightTextView.text] ? NO : YES;
            [cell.contentView addSubview:placeholderLabel];
            
            _placeholderLabel = placeholderLabel;
        }
    }
    
    self.provinceID = self.model.province;
    self.cityID = self.model.city;
    self.districtID = self.model.district;
    
    return cell;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.cityPickerView removeFromSuperview];
    self.cityPickerView = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.cityPickerView removeFromSuperview];
    self.cityPickerView = nil;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.markedTextRange == nil) {
        self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
    }
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
    
    // 分割线
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    headerView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    tableView.tableHeaderView = headerView;
    
    /**
     默认地址
     保存
     */
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 63 + 48)];
    tableView.tableFooterView = footerView;
    
    UIButton *defaultAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 63)];
    [defaultAddressButton setTitle:@"    默认地址" forState:UIControlStateNormal];
    [defaultAddressButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    [defaultAddressButton setImage:[UIImage imageNamed:@"icon_selecte_not"] forState:UIControlStateNormal];
    [defaultAddressButton setImage:[UIImage imageNamed:@"icon_selecte"] forState:UIControlStateSelected];
    defaultAddressButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [defaultAddressButton addTarget:self action:@selector(defaultAddressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    defaultAddressButton.selected = [self.model.is_default integerValue] == 1 ? YES : NO;
    [footerView addSubview:defaultAddressButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 63, kMainScreenWidth - 30, 48)];
    saveButton.backgroundColor = COLOR_THEME;
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    saveButton.layer.cornerRadius = 4.0f;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveButton];
    
    _tableView = tableView;
}

- (void)saveButtonClick {
    NSLog(@"保存");
    
    VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell *usernameCell = (VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell *mobileCell = (VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell *addressCell = (VENShoppingCartPlacingOrderReceivingAddAddressTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:usernameCell.rightTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请填写联系人姓名"];
        return;
    }

    if ([[VENClassEmptyManager sharedManager] isEmptyString:mobileCell.rightTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请填写联系人手机号"];
        return;
    }

    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.provinceID]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请选择所在区域"];
        return;
    }

    if ([[VENClassEmptyManager sharedManager] isEmptyString:addressCell.rightTextView.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请填写详细地址"];
        return;
    }
    
    NSDictionary *params;
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.model.address_id]) {
        params = @{@"username" : usernameCell.rightTextField.text,
                  @"mobile" : mobileCell.rightTextField.text,
                  @"address" : addressCell.rightTextView.text,
                  @"is_default" : [NSString stringWithFormat:@"%d", self.isDefault],
                  @"province" : self.provinceID,
                  @"city" : self.cityID,
                  @"district" : self.districtID};
    } else {
        params = @{@"username" : usernameCell.rightTextField.text,
                   @"mobile" : mobileCell.rightTextField.text,
                   @"address" : addressCell.rightTextView.text,
                   @"is_default" : [NSString stringWithFormat:@"%d", self.isDefault],
                   @"province" : self.provinceID,
                   @"city" : self.cityID,
                   @"district" : self.districtID,
                   @"address_id" : self.model.address_id};
    }
    
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:self.isEdit ? @"address/edit" : @"address/add" params:params showLoading:YES successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            self.block(@"");
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failureBlock:^(NSError *error) {

    }];
    
    
}

- (void)defaultAddressButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    self.isDefault = button.selected;
    
    NSLog(@"%d", self.isDefault);
    
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
