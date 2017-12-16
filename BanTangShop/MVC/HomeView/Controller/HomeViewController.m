//
//  HomeViewController.m
//  GitHudStudy
//
//  Created by tzsoft on 2017/12/7.
//  Copyright © 2017年 TZSoft. All rights reserved.
//

#import "HomeViewController.h"
#import "NextViewController.h"
#import "UIScrollView+JElasticPullToRefresh.h"// 下拉刷新
#import "SDCycleScrollView.h"// 轮播图

@interface HomeViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIView *headView;
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.headView addSubview:self.cycleScrollView];
    [self loadScrollViewData];// 加载轮播图数据
    [self addRefreashAnimation];// 添加刷新动画
}

#pragma mark - 下拉刷新
- (void)addRefreashAnimation{
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView stopLoading];
        });
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:Color_Theme];
    [self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        DLog(@"导航栏高度:%f",High_NavAndStatus);
        DLog(@"屏幕高度:%f",ScrH);
        DLog(@"tableview高度:%f",ScrH - High_NavAndStatus - 49);
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH - High_NavAndStatus - 49) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        //2、创建图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScrW, CGRectGetHeight(self.headView.frame)) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
        cycleScrollView.showPageControl = YES;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}
// 创建tableView头视图
- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [UIView new];
        headView.frame = CGRectMake(0, 0, ScrW, 180);
        headView.backgroundColor= [UIColor clearColor];
        _headView = headView;
    }
    
    return _headView;
}
#pragma mark - 代理 UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *homeCell =@"homeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:homeCell];
    }
    cell.textLabel.text = @"哈哈";
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

#pragma mark - 加载轮播图数据

- (void)loadScrollViewData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //3、加载网络图片
        self.cycleScrollView.imageURLStringsGroup = @[@"http://101.132.191.36/uploads/ad/2017/11/1511362750-3972-11.jpg",@"http://101.132.191.36/uploads/ad/2017/11/1.png"];
        
        self.cycleScrollView.titlesGroup = @[@"吃吃吃",@"就知道吃"];
    });
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    DLog(@"去吃吧");
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}
@end
