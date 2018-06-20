//
//  LoginViewController.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/20.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "LoginViewController.h"
#import "UserHelper.h"
#import "RegisterViewController.h"
#import "Record.h"
#import "DataBase.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *psdTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (void)cancelAction{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loginAction:(UIButton *)sender {
    [LCProgressHUD showKeyWindowLoading:@"登录中..."];
    if (self.accountTF.text.length == 0 || self.psdTF.text.length == 0){
        [LCProgressHUD showFailure:@"请输入账号和密码"];
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://cairnsdiveadventures.com.au/wp-content/uploads/2012/07/underwater-photography.jpg"]];
    
    [LCProgressHUD hide];
    if ([@"13773047057" isEqualToString:self.accountTF.text] && [@"123456" isEqualToString:self.psdTF.text]){
        [self loadData];
        [LCProgressHUD showKeyWindowSuccess:@"登录成功"];
        [UserHelper setLoginWithString:@"1"];
        [self cancelAction];
    }else {
        [LCProgressHUD showFailure:@"账号或密码错误"];
    }
    
}
- (IBAction)registAction:(UIButton *)sender {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData {
    Record *record1 = [[Record alloc] init];
    record1.money = @"1000";
    record1.typeStr = @"购物";
    record1.infoStr = @"小米手机";
    record1.dateStr = @"06月18日";
    
    Record *record2 = [[Record alloc] init];
    record2.money = @"50";
    record2.typeStr = @"餐饮";
    record2.infoStr = @"KFC";
    record2.dateStr = @"06月10日";
    
    Record *record3 = [[Record alloc] init];
    record3.money = @"500";
    record3.typeStr = @"交通";
    record3.infoStr = @"充值地铁卡";
    record3.dateStr = @"06月12日";
    
    Record *record4 = [[Record alloc] init];
    record4.money = @"100";
    record4.typeStr = @"通讯";
    record4.infoStr = @"充话费";
    record4.dateStr = @"06月12日";
    
    Record *record5 = [[Record alloc] init];
    record5.money = @"130";
    record5.typeStr = @"书籍";
    record5.infoStr = @"京东618购物";
    record5.dateStr = @"06月18日";
    
    Record *record6 = [[Record alloc] init];
    record6.money = @"40";
    record6.typeStr = @"其他";
    record6.infoStr = @"忘记了";
    record6.dateStr = @"06月19日";
    
    Record *record7 = [[Record alloc] init];
    record7.money = @"15.8";
    record7.typeStr = @"餐饮";
    record7.infoStr = @"早饭";
    record7.dateStr = @"06月20日";
    
    [[DataBase sharedDataBase] addRecord:record1];
     [[DataBase sharedDataBase] addRecord:record2];
     [[DataBase sharedDataBase] addRecord:record3];
     [[DataBase sharedDataBase] addRecord:record4];
     [[DataBase sharedDataBase] addRecord:record5];
     [[DataBase sharedDataBase] addRecord:record6];
     [[DataBase sharedDataBase] addRecord:record7];
}

@end
