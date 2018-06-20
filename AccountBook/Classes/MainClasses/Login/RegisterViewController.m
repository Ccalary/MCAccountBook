//
//  RegisterViewController.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/20.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "RegisterViewController.h"
#import "SendCodeButton.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    
    SendCodeButton *button = [[SendCodeButton alloc] initWithTitle:@"验证码" seconds:60];
    [button setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.codeTF);
        make.left.mas_equalTo(self.codeTF.mas_right).offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)registerAction:(UIButton *)sender {
    [LCProgressHUD showFailure:@"验证码不正确"];
}

@end
