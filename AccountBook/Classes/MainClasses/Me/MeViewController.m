//
//  MeViewController.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/19.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "MeViewController.h"
#import "UIColor+App.h"
#import "LCActionSheet.h"
#import "LCProgressHUD.h"
#import "MessageViewController.h"
#import "HHAlertController.h"
#import "MyInfoViewController.h"
#import "UserHelper.h"

@interface MeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topHoldView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *imageArray;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"消息",@"个人资料",@"联系我们",@"清除缓存",@"退出登录"];
    self.imageArray = @[@"icon-xiaoxi",@"icon-zilaio",@"icon-renzheng",@"icon-fucha",@"icon-dingdan"];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initView {
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    gradLayer.frame = CGRectMake(0, 0, ScreenWidth, self.topHoldView.frame.size.height);
    gradLayer.colors =  @[(__bridge id)[UIColor themeColor].CGColor,(__bridge id)[UIColor colorWithHex:0x6ea9dc].CGColor];
    gradLayer.startPoint = CGPointMake(0.5, 0);
    gradLayer.endPoint = CGPointMake(0.5, 1);
    [self.topHoldView.layer addSublayer:gradLayer];
   
    [self.topHoldView bringSubviewToFront:self.headerImageView];
    [self.topHoldView bringSubviewToFront:self.tipsLabel];
    self.headerImageView.layer.cornerRadius = 40;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerAction)];
    [self.headerImageView addGestureRecognizer:aTap];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.row]]];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:// 消息
            [self.navigationController pushViewController:[[MessageViewController alloc] init] animated:YES];
            break;
        case 1:// 个人资料
            [self.navigationController pushViewController:[[MyInfoViewController alloc] init] animated:YES];
            break;
        case 2:// 联系我们
            [self phoneCall];
            break;
        case 3:// 清除缓存
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [LCProgressHUD showSuccess:@"清除成功"];
            });
            break;
        case 4:// 退出登录
            [self logout];
            break;
        default:
            break;
    }
}

- (void)phoneCall {
    //10.0之后好像拨打电话会有两秒的延迟，此方法可以秒打
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
        NSString *phone = [NSString stringWithFormat:@"tel://13773047057"];
        NSURL *url = [NSURL URLWithString:phone];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            NSLog(@"phone success");
        }];
    }
}

- (void)logout{
   HHAlertController *alert = [HHAlertController alertWithTitle:@"退出登录" message:@"确定要退出登录吗？" sureButtonTitle:@"确定" cancelButtonTitle:@"取消" sureHandel:^{
       [UserHelper setLoginWithString:@"0"];
        self.tabBarController.selectedIndex = 0;
    } cancelHandel:^{
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)headerAction
{
    __weak typeof (self) weakSelf = self;
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"头像更改"
                                       cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                                           if (buttonIndex == 1) {
                                                [weakSelf openCamera];
                                           }else if (buttonIndex == 2) {
                                               [weakSelf openPhotoLibrary];
                                           }
    }
                                   otherButtonTitleArray:@[@"拍照",@"相册选择"]];
    
    [sheet show];
}


/** 相机 */
- (void)openCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        
        [LCProgressHUD showInfoMsg:@"该设备不支持拍照"];
    }
}

/** 相册 */
- (void)openPhotoLibrary
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //设置拍照后的图片可被编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.headerImageView.image = image;
}

@end
