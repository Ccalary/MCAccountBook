//
//  MessageViewController.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/19.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight/2.0 - 30, ScreenWidth, 25)];
    label.text = @"很抱歉，什么都没有~";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
