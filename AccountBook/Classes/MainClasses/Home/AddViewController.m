//
//  AddViewController.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/19.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "AddViewController.h"
#import "DateView.h"
#import "CNPPopupController.h"
#import "DataBase.h"
#import "Record.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (strong, nonatomic) DateView *dateView;
@property (nonatomic, strong) CNPPopupController *popController;
@property (nonatomic, strong) NSString *typeStr;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self typeBtnAction:self.normalBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction)];
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTapAction)];
    [self.view addGestureRecognizer:atap];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    [self.dateBtn setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];

}

- (DateView *)dateView {
    if (!_dateView){
        _dateView  = [[DateView alloc] initWithFrame:CGRectMake(0, ScreenHeight -  TopFullHeight, ScreenWidth, 200)];
        __weak typeof (self) weakSelf = self;
        _dateView.block = ^(NSString *dateStr) {
            if (dateStr){
                [weakSelf.dateBtn setTitle:dateStr forState:UIControlStateNormal];
            }
            [weakSelf.popController dismissPopupControllerAnimated:YES];
        };
    }
    return _dateView;
}

- (void)aTapAction {
    
}

- (IBAction)dateAction:(UIButton *)sender {
    self.popController = [[CNPPopupController alloc] initWithContents:@[self.dateView]];
    self.popController.theme.popupStyle = CNPPopupStyleActionSheet;
    self.popController.theme.shouldDismissOnBackgroundTouch = YES;
    [self.popController presentPopupControllerAnimated:YES];
}

- (IBAction)typeBtnAction:(UIButton *)sender {
    
    for (int i = 1000; i <= 1008; i++){
        UIButton *button = [self.view viewWithTag:i];
        button.backgroundColor = [UIColor fontColorLightGray];
    }
    sender.backgroundColor = [UIColor redColor];
    self.typeStr = sender.currentTitle;
}

- (void)rightBarAction {
    
    if (self.moneyTextField.text.length <= 0){
        [LCProgressHUD showFailure:@"请输入金额"];
        return;
    }
    
    Record *record = [[Record alloc] init];
    record.dateStr = self.dateBtn.currentTitle;
    record.typeStr = self.typeStr;
    record.money = self.moneyTextField.text ?: @"0";
    record.infoStr = self.infoTextField.text;
    [[DataBase sharedDataBase] addRecord:record];
    
    if (self.block){
        self.block();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
