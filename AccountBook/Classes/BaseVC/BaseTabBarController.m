//
//  BaseTabBarController.m
//  TestDemo1
//
//  Created by caohouhong on 17/3/15.
//  Copyright © 2017年 caohouhong. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import "MeViewController.h"
#import "DataViewController.h"
#import "UIColor+App.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBar *tabbar = [UITabBar appearance];
    tabbar.tintColor = [UIColor themeColor];
    
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加子控制器
- (void)addChildViewControllers{
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    homeVC.tabBarItem.badgeValue = @"1";
    
    [self addChildrenViewController:homeVC andTitle:@"明细" andImageName:@"tab_form_n" andSelectImage:@"tab_form_s"];
    [self addChildrenViewController:[[DataViewController alloc] init] andTitle:@"统计" andImageName:@"tab_data_n" andSelectImage:@"tab_data_s"];
    [self addChildrenViewController:[[MeViewController alloc] init] andTitle:@"我的" andImageName:@"tab_me_n" andSelectImage:@"tab_me_s"];
}


- (void)addChildrenViewController:(UIViewController *)childVC andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage =  [UIImage imageNamed:selectedImage];
    childVC.title = title;

    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:childVC];

    [self addChildViewController:baseNav];
}
@end
