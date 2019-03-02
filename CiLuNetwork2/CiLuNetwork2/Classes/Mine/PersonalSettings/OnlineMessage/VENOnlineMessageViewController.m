//
//  VENOnlineMessageViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/30.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENOnlineMessageViewController.h"

@interface VENOnlineMessageViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;


@end

@implementation VENOnlineMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"在线留言";
    
    self.contentTextView.delegate = self;
    
    [self setupSaveButton];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

- (void)setupSaveButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)saveButtonClick {
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.titleTextField.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入留言标题"];
        return;
    }
    
    if ([[VENClassEmptyManager sharedManager] isEmptyString:self.contentTextView.text]) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入留言内容"];
        return;
    }

    NSDictionary *params = @{@"title" : self.titleTextField.text,
                             @"content" : self.contentTextView.text};

    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"setting/feedback" params:params showLoading:YES successBlock:^(id response) {

        if ([response[@"status"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failureBlock:^(NSError *error) {

    }];
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
