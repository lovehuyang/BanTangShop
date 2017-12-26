//
//  ForumViewController.m
//  GitHudStudy
//
//  Created by tzsoft on 2017/12/7.
//  Copyright © 2017年 TZSoft. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FoodsDetailController.h"
#import "HomeTableViewCell.h"
#import "FoodListModel.h"

@interface FavoriteViewController ()
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArr;// 列表的数据源
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self getLikeFood];
    [self.view addSubview:self.tableView];
    [self addRefreashAndLoadMore];
}

#pragma mark - 获取数据
- (void)getLikeFood{
    if([GlobalTools userIsLogin]){
        NSDictionary *paraDict = @{@"username":[GlobalTools getData:USER_PHONE]};
        [HLYNetWorkObject requestWithMethod:GET ParamDict:paraDict url:URL_GETLIKEFOOD successBlock:^(id requestData, NSDictionary *dataDict) {
            [MBProgressHUDTools hideHUD];
            NSArray *dataArr = (NSArray *)dataDict;
            
            if (dataArr.count == 0) {
                [MBProgressHUDTools showTipMessageHudWithtitle:@"暂无数据"];
            }else{
                for (NSDictionary *tempDict in dataArr) {
                    FoodListModel *food = [FoodListModel createModelWithDic:tempDict];
                    [self.dataArr addObject:food];
                }
            }
            [self.tableView.mj_header endRefreshing];
            [self tableViewReloadData];
            
        } failureBlock:^(NSInteger errCode, NSString *msg) {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUDTools showTipMessageHudWithtitle:msg];
        }];
    }else{
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请先登录！"];
    }
    
}
#pragma mark - tableview重新加载数据
- (void)tableViewReloadData{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH - High_NavAndStatus - 49) style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - 刷新和加载更多
- (void)addRefreashAndLoadMore{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArr removeAllObjects];
        [self getLikeFood];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *homeCell =@"homeCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell];
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:homeCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.food = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120 ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodListModel *food = [self.dataArr objectAtIndex:indexPath.row];
    FoodsDetailController *fdvc =[[FoodsDetailController alloc]init];
    fdvc.foodId = food.ID;
    [self.navigationController pushViewController:fdvc animated:YES];
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

@end
