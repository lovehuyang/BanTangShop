//
//  FoodsDetailController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/22.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "FoodsDetailController.h"
#import "SDCycleScrollView.h"// 轮播图
#import "WRNavigationBar.h"
#import "CycleBottomView.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + High_NavAndStatus*2)
#define IMAGE_HEIGHT 260 * ScaleX
#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
#define H_CELL 120*ScaleX// CELL的高度

@interface FoodsDetailController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UIView *headView;//tableView的头部视图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;// 轮播图
@property (nonatomic ,strong) NSArray *bannerArr;// 轮播图数据
@property (nonatomic ,strong) CycleBottomView *cycleBottomView;// 轮播图底部半透明视图
@end

@implementation FoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"食品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getFoodDetailById];// 获取食品详情
    [self getFoodImagesById];// 获取食品轮播图
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-High_NavAndStatus, 0, 0, 0);
    [self.tableView addSubview:self.cycleScrollView];
    [self.tableView addSubview:self.cycleBottomView];
    [self.view addSubview:self.tableView];
    
    [self wr_setNavBarBackgroundAlpha:0];
}

#pragma mark - 懒加载
// 创建tableView头视图
- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [UIView new];
        headView.frame = CGRectMake(0, 0, ScrW, 120);
        headView.backgroundColor= [UIColor orangeColor];
        _headView = headView;
    }
    return _headView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        //2、创建图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -IMAGE_HEIGHT, ScrW, IMAGE_HEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
        cycleScrollView.showPageControl = YES;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 5;
        cycleScrollView.backgroundColor =[UIColor whiteColor];
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

- (CycleBottomView *)cycleBottomView{
    if (!_cycleBottomView) {
        _cycleBottomView = [[CycleBottomView alloc]initWithFrame:CGRectMake(0,  - 55, ScrW, 55 ) model:nil];
    }
    return _cycleBottomView;
}
#pragma mark - 获取食品详情
- (void)getFoodDetailById{
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"foodId":self.foodId} url:URL_GETFOODDETAILBYID successBlock:^(id requestData, NSDictionary *dataDict) {
        DLog(@"");
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
    }];
}
#pragma mark - 获取食品轮播图
- (void)getFoodImagesById{
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"foodId":self.foodId} url:URL_GETFOODIMAGEBYID successBlock:^(id requestData, NSDictionary *dataDict) {
        DLog(@"");
        self.bannerArr = (NSArray *)dataDict;
        [self loadScrollViewData];
    } failureBlock:^(NSInteger errCode, NSString *msg) {

    }];
}

#pragma mark - 加载轮播图数据
- (void)loadScrollViewData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //3、加载网络图片
        NSMutableArray *image_url_Arr = [NSMutableArray array];
        [image_url_Arr removeAllObjects];
        for (NSDictionary *dataDict in self.bannerArr) {
            [image_url_Arr addObject:[NSString stringWithFormat:@"%@%@",URL_BASEIP,dataDict[@"avatar"]]];
        }
        self.cycleScrollView.imageURLStringsGroup = image_url_Arr;
        
    });
}
#pragma mark - 导航栏事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / High_NavAndStatus;
        [self wr_setNavBarBackgroundAlpha:alpha];
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
    }
    //限制下拉的距离
    if(offsetY < LIMIT_OFFSET_Y) {
        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    }
    // 改变图片框的大小 (上滑的时候不改变)
    // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
    CGFloat newOffsetY = scrollView.contentOffset.y;
    if (newOffsetY < -IMAGE_HEIGHT)
    {
        self.cycleScrollView.frame = CGRectMake(0, newOffsetY, ScrW, -newOffsetY);
    }
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    NSString *str = [NSString stringWithFormat:@"WRNavigationBar %zd",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [UIViewController new];
    NSString *str = [NSString stringWithFormat:@"WRNavigationBar %zd",indexPath.row];
    vc.title = str;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
