//
//  VENPersonalDataViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2019/1/28.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPersonalDataViewController.h"
#import "VENMineTableViewCellStyleOne.h"
#import "VENPersonalDataNamePageViewController.h"
#import "VENPersonalDataModel.h"
#import "VENPersonalDataInvitationCodePageViewController.h"

#import "LGPhotoPickerViewController.h"
#import "LGPhotoPickerBrowserViewController.h"

@interface VENPersonalDataViewController () <UITableViewDelegate, UITableViewDataSource, LGPhotoPickerViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VENPersonalDataModel *model;

@end

static NSString *cellIdentifier = @"cellIdentifier";
@implementation VENPersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人资料";
    
    [self setupTableView];
    [self loadData];
}

- (void)loadData {
    [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"setting/info" params:nil showLoading:YES successBlock:^(id response) {
        
        self.model = [VENPersonalDataModel yy_modelWithJSON:response[@"data"]];
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMineTableViewCellStyleOne *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *titleArr = @[@[@"头像", @"姓名", @"手机号码"], @[@"邀请码", @"我的邀请码"]];
    cell.leftLabel.text = titleArr[indexPath.section][indexPath.row];
    
    cell.iconImageView.hidden = YES;
    cell.rightLabel.hidden = YES;
    cell.rightButton.hidden = YES;
    cell.rightLabel2.hidden = YES;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.iconImageView.hidden = NO;
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"icon_default_head_big"]];
            cell.rightImageView.hidden = NO;
        } else if (indexPath.row == 1){
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.model.name;
            cell.rightLabel.textColor = UIColorFromRGB(0x1A1A1A);
            cell.rightImageView.hidden = NO;
        } else {
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.model.mobile;
            cell.rightLabel.textColor = UIColorFromRGB(0xCCCCCC);
            cell.rightImageView.hidden = YES;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.rightButton.hidden = NO;
            cell.rightLabel2.hidden = NO;
            cell.rightLabel2.text = self.model.invate_code;
            [cell.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
            cell.rightImageView.hidden = YES;
        }
    }
    
    return cell;
}

- (void)rightButtonClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.model.invate_code;
    
    [[VENMBProgressHUDManager sharedManager] showText:@"复制成功"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self presentCameraSingle];
            }];
            UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:appropriateAction];
            [alert addAction:undeterminedAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else if (indexPath.row == 1) {
            VENPersonalDataNamePageViewController *vc = [[VENPersonalDataNamePageViewController alloc] init];
            vc.name = self.model.name;
            vc.block = ^(NSString *str) {
                [self loadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            VENPersonalDataInvitationCodePageViewController *vc = [[VENPersonalDataInvitationCodePageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }
    }
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - statusNavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENMineTableViewCellStyleOne" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)pickerViewControllerDoneAsstes:(NSArray <LGPhotoAssets *> *)assets isOriginal:(BOOL)original{
    /*
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
     NSMutableArray *thumbImageArray = [NSMutableArray array];
     NSMutableArray *originImage = [NSMutableArray array];
     NSMutableArray *fullResolutionImage = [NSMutableArray array];
     
     for (LGPhotoAssets *photo in assets) {
     //缩略图
     [thumbImageArray addObject:photo.thumbImage];
     //原图
     [originImage addObject:photo.originImage];
     //全屏图
     [fullResolutionImage addObject:fullResolutionImage];
     }
     */
    
    [self updataFaceImageWith:assets[0].compressionImage];
}

/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 1;   // 最多能选9张图片
    pickerVc.delegate = self;
    //    pickerVc.nightMode = YES;//夜间模式
    //    self.showType = style;
    [pickerVc showPickerVc:self];
}

/**
 *  初始化自定义相机（单拍）
 */
- (void)presentCameraSingle {
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 1;
    // 单拍
    cameraVC.cameraType = ZLCameraSingle;
    cameraVC.callback = ^(NSArray *cameras){
        //在这里得到拍照结果
        //数组元素是ZLCamera对象
        /*
         @exemple
         ZLCamera *canamerPhoto = cameras[0];
         UIImage *image = canamerPhoto.photoImage;
         */
        
        ZLCamera *canamerPhoto = cameras[0];
        [self updataFaceImageWith:canamerPhoto.photoImage];
    };
    [cameraVC showPickerVc:self];
}

- (void)updataFaceImageWith:(UIImage *)image {
    
    [[VENNetworkTool sharedManager] uploadImageWithPath:@"setting/uploadAvatar" image:image name:@"avatar" params:nil success:^(id response) {
        
        if ([response[@"status"] integerValue] == 0) {
            VENMineTableViewCellStyleOne *cell = (VENMineTableViewCellStyleOne *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:response[@"data"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_default_head_big"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMinePage" object:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
