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
#import "HomeTableViewCell.h"
#import "HeadView.h"
#import "FoodListModel.h"

#define H_BANNER 150*ScaleY //Banner图的高度
#define H_CELL 120*ScaleX// CELL的高度

@interface HomeViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong)NSMutableArray *bannerArr;// 轮播图数据源
@property (nonatomic ,strong)NSMutableArray *recommendArr;// 推荐食品数据源
@property (nonatomic ,strong)NSMutableArray *dataArr;// 销量排行数据源
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIView *headView;//tableView的头部视图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;// 轮播图
@property (nonatomic ,strong) UIScrollView *recommendView;// 推荐

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.headView addSubview:self.cycleScrollView];
    [self.headView addSubview:self.recommendView];
    [self loadScrollViewData];// 加载轮播图数据
    [self addRefreashAnimation];// 添加刷新动画
    [self getBannerData];// 获取banner
    [self getRecommends];// 获取推荐食品
    [self getSellTopFoodSummary];// 获取销售排行食品列表
}

- (void)createRecommendUI{
    for (UIView *subView in self.recommendView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat W_Img = 70 *ScaleX;
    for (int i = 0; i < self.recommendArr.count; i ++) {
        NSDictionary *dataDict = [self.recommendArr objectAtIndex:i];
        NSString *avatar = [NSString stringWithFormat:@"%@%@",URL_BASEIP,dataDict[@"avatar"]];
        UIImageView *imgView = [UIImageView new];
        CGFloat x_img = Margin_X + W_Img * i + 10 *i;
        imgView.frame = CGRectMake(x_img, 0 , W_Img, W_Img);
        [imgView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"common_image_empty"]];
        [self.recommendView addSubview:imgView];
        UILabel *titleLab = [UILabel new];
        titleLab.frame = CGRectMake(x_img, CGRectGetMaxY(imgView.frame), W_Img, 20 *ScaleX);
        [self.recommendView addSubview:titleLab];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:11];
        titleLab.textColor = Color_Theme;
        titleLab.text = dataDict[@"foodName"];
    }
    _recommendView.contentSize = CGSizeMake((W_Img  + Margin_X)*self.recommendArr.count, 0);
}

#pragma mark - banner
- (void)getBannerData{
    
    [HLYNetWorkObject requestWithMethod:GET ParamDict:nil url:URL_GETBANNERS successBlock:^(id requestData, NSDictionary *dataDict) {
        [self.bannerArr removeAllObjects];
        [self.bannerArr addObjectsFromArray:(NSArray *)dataDict];
        [self loadScrollViewData];// 加载轮播图数据
    } failureBlock:^(NSInteger errCode, NSString *msg) {
    }];
};

#pragma mark - 推荐食品
- (void)getRecommends{
    
    [HLYNetWorkObject requestWithMethod:GET ParamDict:nil url:URL_GETRECOMMENDS successBlock:^(id requestData, NSDictionary *dataDict) {
        [self.recommendArr removeAllObjects];
        [self.recommendArr addObjectsFromArray:(NSArray *)dataDict];
        [self createRecommendUI];// 创建推荐食品的UI
    } failureBlock:^(NSInteger errCode, NSString *msg) {
    }];
}
#pragma mark - 获取销售排行食品列表
- (void)getSellTopFoodSummary{
    [HLYNetWorkObject requestWithMethod:GET ParamDict:nil url:URL_GETSELLTOPFOODSUMMARY successBlock:^(id requestData, NSDictionary *dataDict) {
        [self.dataArr removeAllObjects];
        for (NSDictionary *tempDict in (NSArray *)dataDict) {
            FoodListModel *food = [FoodListModel createModelWithDic:tempDict];
            [self.dataArr addObject:food];
        }
        [self.tableView stopLoading];
        [self.tableView reloadData];
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [self.tableView stopLoading];
    }];
}
#pragma mark - 下拉刷新
- (void)addRefreashAnimation{
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        [weakSelf getBannerData];// 获取banner
        [weakSelf getRecommends];// 获取推荐食品
        [weakSelf getSellTopFoodSummary]; // 获取销售排行食品列表
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:Color_Theme];
    [self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
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
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScrW, H_BANNER) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
        cycleScrollView.showPageControl = YES;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}
- (UIScrollView *)recommendView{
    if (!_recommendView) {
        
        HeadView *headView = [[HeadView alloc]initWithFrame:CGRectMake(0, H_BANNER, ScrW, 30 *ScaleX ) title:@"推荐食品"];
        headView.moreBtnClick = ^(NSString *title) {
            DLog(@"%@组的更多按钮",title);
        };

        [self.headView addSubview:headView];
        
        _recommendView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, H_BANNER + 30 * ScaleX, ScrW, H_CELL - 30 *ScaleX)];
        _recommendView.backgroundColor = [UIColor whiteColor];
        _recommendView.showsHorizontalScrollIndicator = NO;
    }
    return  _recommendView;
}
- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (NSMutableArray *)recommendArr{
    if (!_recommendArr) {
        _recommendArr = [NSMutableArray array];
    }
    return _recommendArr;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
// 创建tableView头视图
- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [UIView new];
        headView.frame = CGRectMake(0, 0, ScrW, H_BANNER + H_CELL);
        headView.backgroundColor= [UIColor clearColor];
        _headView = headView;
    }
    
    return _headView;
}
#pragma mark - 代理 UITableViewDelegate, UITableViewDataSource
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
//    Class currentClass = [HomeTableViewCell class];
//
//    FoodListModel *model = [self.dataArr objectAtIndex:indexPath.row];
//
//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"food" cellClass:currentClass contentViewWidth:ScrW];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [UIView new];
    backView.frame = CGRectMake(0, 0,ScrW, 40 *ScaleX);
    backView.backgroundColor = Color_Back_Gray;
    HeadView *headView = [[HeadView alloc]initWithFrame:CGRectMake(0, 10 *ScaleX, ScrW, 30 *ScaleX) title:@"销量排行"];
    headView.moreBtnClick = ^(NSString *title) {
        DLog(@"%@",title);
    };
    [backView addSubview:headView];
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 *ScaleX;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 加载轮播图数据

- (void)loadScrollViewData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //3、加载网络图片
        NSMutableArray *image_url_Arr = [NSMutableArray array];
        [image_url_Arr removeAllObjects];
        for (NSDictionary *dataDict in self.bannerArr) {
            [image_url_Arr addObject:[NSString stringWithFormat:@"%@%@",URL_BASEIP,dataDict[@"image_url"]]];
        }
        self.cycleScrollView.imageURLStringsGroup = image_url_Arr;
        
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
