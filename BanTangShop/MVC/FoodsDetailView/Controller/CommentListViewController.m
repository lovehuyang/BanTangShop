//
//  CommentListViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/28.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentViewController.h"
#import "CommentOtherCell.h"
#import "CommentModel.h"

@interface CommentListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    BOOL hasNextPage;// 有没有下一页
}
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArr;
@end

@implementation CommentListViewController
- (instancetype)init{
    if (self = [super init]) {
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评论列表";
    page = 1;// 页码
    [self getCommentsByPages];// 获取评论列表
    [self.view addSubview:self.tableView];
    [self addRefreashAndLoadMore];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreashData) name:NOTIFICATION_COMMENT_SUCCESS object:nil];
}

#pragma mark - 刷新和加载更多
- (void)addRefreashAndLoadMore{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArr removeAllObjects];
        page = 1;
        [self getCommentsByPages];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (hasNextPage) {
            page ++;
            [self getCommentsByPages];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellMark = @"commentCell2";
    CommentOtherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[CommentOtherCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellMark];
    }
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArr[indexPath.row] keyPath:@"model" cellClass:[CommentOtherCell class] contentViewWidth:ScrW];
}
#pragma mark - 分页获取评论
- (void)getCommentsByPages{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)page];
    NSDictionary *paramDict = @{@"foodId":self.foodId,@"page":pageStr};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_GETCOMMENTLIST successBlock:^(id requestData, NSDictionary *dataDict) {
        DLog(@"");
        hasNextPage = [requestData[@"isHasNext"] boolValue];
        for (NSDictionary *tempDict in (NSArray *)dataDict) {
            CommentModel *model = [CommentModel createModelWithDic:tempDict];
            [self.dataArr addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
    }];
}
#pragma mark - 评论
- (void)navBtnClick{
    CommentViewController *cvc = [[CommentViewController alloc]init];
    cvc.foodId = self.foodId;
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark - 接到通知，刷新评论
- (void)refreashData{
    [self.dataArr removeAllObjects];
    page = 1;
    [self getCommentsByPages];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_COMMENT_SUCCESS object:nil];
}
@end
