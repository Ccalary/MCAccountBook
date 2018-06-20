//
//  HomeViewController.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/19.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "HomeViewController.h"
#import "MoveButton.h"
#import "AddViewController.h"
#import "HomeTableViewCell.h"
#import "DataBase.h"
#import "HHRefreshNormalHeader.h"
#import "LoginViewController.h"
#import "UserHelper.h"
#import "BaseNavigationController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MoveButton *addButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - TopFullHeight - TabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    __weak typeof (self) weakSelf = self;
    _tableView.hidden = YES;
    _tableView.mj_header = [HHRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [self.view addSubview:_tableView];
    
    _addButton = [[MoveButton alloc] initWithFrame:CGRectMake(ScreenWidth - 60, ScreenHeight - TabBarHeight - TopFullHeight - 80, 60, 60)];
    [_addButton setImage:[UIImage imageNamed:@"add_40"] forState:UIControlStateNormal];
    _addButton.hidden = YES;
    [self.view addSubview:_addButton];
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addButtonAction)];
    [self.addButton addGestureRecognizer:aTap];
    
    _loginBtn = [[UIButton alloc] init];
    _loginBtn.layer.cornerRadius = 25;
    _loginBtn.layer.borderColor = [UIColor themeColor].CGColor;
    _loginBtn.layer.borderWidth = 1;
    [_loginBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    _loginBtn.hidden = YES;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
        make.center.mas_equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UserHelper isLogin]){
        _tableView.hidden = NO;
        _addButton.hidden = NO;
        _loginBtn.hidden = YES;
        [self requestData];
    }else {
        _tableView.hidden = YES;
        _addButton.hidden = YES;
        _loginBtn.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.record = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
//走了左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){//删除操作
        Record *record = self.dataArray[indexPath.row];
        [[DataBase sharedDataBase] deleteRecord:record];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        //删除某行并配有动画
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//更改左滑后的字体显示
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果系统是英文，会显示delete,这里可以改成自己想显示的内容
    return @"删除";
}

- (void)requestData {
    [LCProgressHUD showLoading:@"加载中..."];
    NSMutableArray *mArray = [[DataBase sharedDataBase] getAllRecord];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[mArray copy]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LCProgressHUD hide];
    });
    [self.tableView reloadData];
}


// 添加
- (void)addButtonAction {
    AddViewController *vc = [[AddViewController alloc] init];
    __weak typeof (self) weakSelf = self;
    vc.block = ^{
        [weakSelf requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginAction {
    LoginViewController *vc = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
