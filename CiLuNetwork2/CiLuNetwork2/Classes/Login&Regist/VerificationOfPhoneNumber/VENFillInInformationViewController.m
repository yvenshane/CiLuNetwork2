//
//  VENFillInInformationViewController.m
//  CiLuNetwork
//
//  Created by YVEN on 2018/12/17.
//  Copyright © 2018年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENFillInInformationViewController.h"
#import "VENSetPasswordViewController.h"
//#import <RPSDK/RPSDK.h>

#import "LGPhotoPickerViewController.h"
#import "LGPhotoPickerBrowserViewController.h"

@interface VENFillInInformationViewController () <LGPhotoPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *upDataButton;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) UIImage *pickImage;
@property (nonatomic, assign) BOOL idNumberTextFieldStatus;

@end

@implementation VENFillInInformationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nextButton.layer.cornerRadius = 4.0f;
    self.nextButton.layer.masksToBounds = YES;
    
    NSLog(@"phoneCode - %@", self.phoneCode);
    NSLog(@"verificationCode - %@", self.verificationCode);
    NSLog(@"invitationCode - %@", self.invitationCode);
    
    [self.idNumberTextField addTarget:self action:@selector(idNumberTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)idNumberTextFieldChanged:(UITextField*)textField {
    self.idNumberTextFieldStatus = textField.text.length >= 15 ? YES : NO;
    self.nextButton.backgroundColor = self.idNumberTextFieldStatus == YES && self.pickImage != nil ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 上传免冠正面照
- (IBAction)uploadButtonClick:(id)sender {
    
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
}

- (IBAction)nextButtonClick:(id)sender {
    if (self.pickImage == nil) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请上传免冠正面照"];
        return;
    }
    
    if (self.idNumberTextField.text.length < 15) {
        [[VENMBProgressHUDManager sharedManager] showText:@"请输入身份证号"];
        return;
    }
    
    [self updataFaceImageWith:self.pickImage];
}

#pragma mark - LGPhotoPickerViewControllerDelegate

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
    
    [self.upDataButton setImage:assets[0].compressionImage forState:UIControlStateNormal];
    self.upDataButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.pickImage = assets[0].compressionImage;
    
    self.nextButton.backgroundColor = self.idNumberTextFieldStatus == YES && self.pickImage != nil ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
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
        [self.upDataButton setImage:canamerPhoto.photoImage forState:UIControlStateNormal];
        self.upDataButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.pickImage = canamerPhoto.photoImage;
        
        self.nextButton.backgroundColor = self.idNumberTextFieldStatus == YES && self.pickImage != nil ? COLOR_THEME : UIColorFromRGB(0xDEDEDE);
    };
    [cameraVC showPickerVc:self];
}

- (void)updataFaceImageWith:(UIImage *)image {
//    [[VENNetworkTool sharedManager] uploadImageWithPath:@"auth/uploadFaceImage" image:image name:@"face_image" params:@{@"id_card" : self.idNumberTextField.text} success:^(id response) {
//        
//        if ([response[@"status"] integerValue] == 0) {
//            
//            NSString *face_image = response[@"data"][@"face_image"];
//            NSString *id_card = response[@"data"][@"id_card"];
//            
//            // 获取 人脸识别所需 token
//            [[VENNetworkTool sharedManager] requestWithMethod:HTTPMethodPost path:@"aliyun/getVerifyToken" params:@{@"face_image" : face_image} showLoading:NO successBlock:^(id response) {
//                
//                if ([response[@"status"] integerValue] == 0) {
//                    
//                    NSString *verifyToken = response[@"data"][@"token"];
//                    
//                    // 阿里云 人脸识别
//                    [RPSDK start:verifyToken rpCompleted:^(AUDIT auditState) {
//                        NSLog(@"verifyResult = %ld",(unsigned long)auditState);
//                        if(auditState == AUDIT_PASS) { //认证通过。
//                            VENSetPasswordViewController *vc = [[VENSetPasswordViewController alloc] init];
//                            vc.mobile = self.phoneCode;
//                            vc.face_image = face_image;
//                            vc.id_card = id_card;
//                            vc.invitation_code = self.invitationCode;
//                            vc.union_id = self.union_id;
//                            [self presentViewController:vc animated:YES completion:nil];
//                        }
//                        else if(auditState == AUDIT_FAIL) { //认证不通过。
//                          
//                            [[VENMBProgressHUDManager sharedManager] showText:@"认证不通过"];
//                            [self.upDataButton setImage:[UIImage imageNamed:@"icon_login_add"] forState:UIControlStateNormal];
//                            
//                        } else if(auditState == AUDIT_IN_AUDIT) { //认证中，通常不会出现，只有在认证审核系统内部出现超时、未在限定时间内返回认证结果时出现。此时提示用户系统处理中，稍后查看认证结果即可。
//                        }
//                        else if(auditState == AUDIT_NOT) { //未认证，用户取消。
//                        }
//                        else if(auditState == AUDIT_EXCEPTION) { //系统异常。
//                        }
//                    }withVC:self.navigationController];
//                    
//                }
//                
//            } failureBlock:^(NSError *error) {
//                
//            }];
//            
//        }
//    } failure:^(NSError *error) {
//        
//    }];
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
