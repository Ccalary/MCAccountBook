//
//  DataViewController.m
//  AccountBook
//
//  Created by caohouhong on 2018/6/19.
//  Copyright © 2018年 caohouhong. All rights reserved.
//

#import "DataViewController.h"
#import <PNChart/PNChart.h>
#import "DataBase.h"
#import "Record.h"
#import "AnalyzeViewController.h"
#import "DataTableViewCell.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "UserHelper.h"

@interface DataViewController ()<UITableViewDelegate, UITableViewDataSource, PNChartDelegate>
@property (nonatomic, strong) PNPieChart *pieChart;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UserHelper isLogin]){
        _pieChart.hidden = NO;
        _totalLabel.hidden = NO;
        _tableView.hidden = NO;
        _loginBtn.hidden = YES;
        [self requestData];
    }else {
        _pieChart.hidden = YES;
        _totalLabel.hidden = YES;
        _tableView.hidden = YES;
        _loginBtn.hidden = NO;
    }
}

- (void)initView {
    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(ScreenWidth/3.0/2.0, 50, ScreenWidth/3.0*2, ScreenWidth/3.0*2) items:nil];
    _pieChart.descriptionTextColor = [UIColor whiteColor];
    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    _pieChart.delegate = self;
    [_pieChart strokeChart];
    [self.view addSubview:_pieChart];
    
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.font = [UIFont systemFontOfSize:18];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_totalLabel];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.pieChart.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.totalLabel.mas_bottom);
    }];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[DataTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.cellArray[indexPath.row];
    cell.dic = dic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)requestData {
     NSMutableArray *mArray = [NSMutableArray array];
     NSMutableArray *itemArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _cellArray = [NSMutableArray array];
    double totalMoney = 0.0;
     NSArray *typeArray = @[@"一般",@"交通",@"通讯",@"购物",@"医疗",@"餐饮",@"旅行",@"书籍",@"其他"];
    for (int i = 0; i < typeArray.count; i++) {
        NSMutableArray *array = [[DataBase sharedDataBase] getRecordWithType:typeArray[i]];
        [mArray addObject:array];
    }
    
    for (int i = 0; i < mArray.count; i++){
        NSArray *array = mArray[i];
        double money = 0.0;
        NSString *typeStr;
        if (array.count <= 0) continue;
        for (int j = 0; j < array.count; j++){
            Record *record = array[j];
            money += [record.money doubleValue];
            typeStr = record.typeStr;
            totalMoney += [record.money doubleValue];
        }
        [_cellArray addObject:@{@"type":typeStr,@"money":[NSString stringWithFormat:@"%.2f",money]}];
        [itemArray addObject:[PNPieChartDataItem dataItemWithValue:money color:[UIColor randomColor] description:typeStr]];
        [_dataArray addObject:array];
    }
    
    [_pieChart updateChartData:itemArray];
    [_pieChart strokeChart];
    [self.tableView reloadData];
    if (totalMoney > 0){
      _totalLabel.text = [NSString stringWithFormat:@"共计花费：%.2f元",totalMoney];
    }
}

- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex {
    AnalyzeViewController *vc = [[AnalyzeViewController alloc] init];
    vc.dataArray = self.dataArray[pieIndex];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginAction {
    LoginViewController *vc = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
