//
//  FoodsDetailController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/22.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "FoodsDetailController.h"
#import "SDCycleScrollView.h"// 轮播图
#import "CommentViewController.h"// 评论页面
#import "WRNavigationBar.h"
#import "CycleBottomView.h"
#import "HeadViewCell1.h"// taleview头部显示价格的cell
#import "HeadViewCell2.h"// taleview头部显示剩余数量的cell
#import "FoodDetailCountDownCell.h"// 倒计时的cell
#import "EventExplainCell.h"// 活动说明
#import "ExpressInfoCell.h"// 包邮说明
#import "FoodInfoCell.h"// 食品信息
#import "ShopContractsCell.h"
#import "ShopContractsCell2.h"
#import "FoodFootView.h"
#import "CommentModel.h"
#import "CommentFirstCell.h"
#import "CommentOtherCell.h"
#import "CommentListViewController.h"// 评论列表

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + High_NavAndStatus *2 )
#define IMAGE_HEIGHT 340 * ScaleX
#define SCROLL_DOWN_LIMIT 100
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
#define H_CELL 120*ScaleX// CELL的高度
#define H_FOOTVIEW 75// 底部view的高度

@interface FoodsDetailController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UIView *headView;//tableView的头部视图
@property (nonatomic ,strong) HeadViewCell1 *headViewCell1;
@property (nonatomic ,strong) HeadViewCell1 *floatView;//漂浮的view
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;// 轮播图
@property (nonatomic ,strong) NSArray *bannerArr;// 轮播图数据
@property (nonatomic ,strong) CycleBottomView *cycleBottomView;// 轮播图底部半透明视图
@property (nonatomic ,strong) FoodModel *food;// 食品模型
@property (nonatomic ,strong) NSArray *sessionTitleArr;// 每组的标题
@property (nonatomic ,strong) NSArray *shopContractArr;// 铺联系人信息
@property (nonatomic ,strong) NSMutableArray *commentArr;// 评论列表
@property (nonatomic ,strong) FoodFootView *footView;
@end

@implementation FoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"食品详情";
    [self wr_setNavBarBackgroundAlpha:0];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT-High_NavAndStatus, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.cycleScrollView];
    self.tableView.alpha = 0.01;
    [self getFoodDetailById];// 获取食品详情
    [self getFoodImagesById];// 获取食品轮播图
    [self getNewComments];// 获取最新评论
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreashData) name:NOTIFICATION_STOP_COUNT_DOWN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNewComments) name:NOTIFICATION_COMMENT_SUCCESS object:nil];
}

#pragma mark - 懒加载
#pragma mark - 创建tableView头视图
- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [UIView new];
        headView.frame = CGRectMake(0, 0, ScrW, 70 *ScaleX);
        _headView = headView;
    }
    return _headView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH - H_FOOTVIEW) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = Color_Back_Gray;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIView *)createTableviewFootViewWithCommentCount:(NSInteger )count{
    UIView *backView = [UIView new];
    backView.frame = CGRectMake(0, 0, ScrW, 45);
    backView.backgroundColor = Color_Back_Gray;
    UILabel *lineLab = [UILabel new];
    lineLab.frame = CGRectMake(0, 0, ScrW, 1);
    lineLab.backgroundColor = Color_Back_Gray;
    [backView addSubview:lineLab];
    UIButton *commnetBtn = [UIButton new];
    commnetBtn.frame = CGRectMake(count>3? ScrW/2:0, 1, count >3?ScrW/2:ScrW,44);
    [backView addSubview:commnetBtn];
    commnetBtn.backgroundColor = [UIColor whiteColor];
    [commnetBtn setTitle:@"我要评论" forState:UIControlStateNormal];
    [commnetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commnetBtn.tag = 10;
    [commnetBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    commnetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIButton *moreBtn = [UIButton new];
    moreBtn.frame = CGRectMake(0, 1,count > 3?ScrW/2-1:0,44);
    [backView addSubview:moreBtn];
    moreBtn.backgroundColor = [UIColor whiteColor];
    [moreBtn setTitle:[NSString stringWithFormat:@"更多评论(%ld条)",(long)count] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreBtn.tag = 11;
    [moreBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.titleLabel.font = commnetBtn.titleLabel.font;
    return backView;
}

- (void)createFootView{
    if (!_footView) {
        _footView = [[FoodFootView alloc]init];
        _footView.frame = CGRectMake(0, ScrH - H_FOOTVIEW, ScrW, H_FOOTVIEW);
    }
    _footView.food = self.food;
    [self.view addSubview:_footView];
}
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        //2、创建图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -IMAGE_HEIGHT, ScrW, IMAGE_HEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
        cycleScrollView.showPageControl = YES;
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.autoScrollTimeInterval = 5;
        cycleScrollView.backgroundColor =[UIColor whiteColor];
        cycleScrollView.pageControlBottomOffset = 50;
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

- (NSArray *)sessionTitleArr{
    if (!_sessionTitleArr) {
        _sessionTitleArr = [NSArray arrayWithObjects:@"活动倒计时",@"活动说明",@"食品信息",@"联系店家",@"食品评论", nil];
    }
    return _sessionTitleArr;
}

- (NSArray *)shopContractArr{
    if (!_shopContractArr) {
        _shopContractArr = [[InfoDBAccess sharedInstance] loadAllShopContacts];
    }
    return _shopContractArr;
}

- (NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}
#pragma mark - 创建轮播图底部的半透明视图
- (void)createCycleBottomView{
    
    self.cycleBottomView = [[CycleBottomView alloc]initWithFrame:CGRectMake(0,  - 50, ScrW, 50 ) model:self.food];
    
    [self.tableView addSubview:self.cycleBottomView];
}
#pragma mark - tableView头视图的第一个cell
- (void)createHeadViewCell1{
    self.headViewCell1 = [[HeadViewCell1 alloc]initWithFrame:CGRectMake(0, 0, ScrW, 35 *ScaleX) modle:self.food];
    __weak typeof (self)weakSelf = self;
    self.headViewCell1.setEnjoyBtnStatus  = ^(BOOL select) {
        [weakSelf.floatView setEnjoyBtnSelectdd:select];
    };
    
    [self.headView addSubview:self.headViewCell1];
}

#pragma mark - tableView头视图的第二个cell
- (void)createHeadViewCell2{
    HeadViewCell2 *headViewCell2 = [[HeadViewCell2 alloc]initWithFrame:CGRectMake(0, 35 *ScaleX, ScrW, 35 *ScaleX) modle:self.food];
    [self.headView addSubview:headViewCell2];
}
#pragma mark - 顶部悬浮的view
- (void)createFloatView{
    self.floatView = [[HeadViewCell1 alloc]initWithFrame:CGRectMake(0, High_NavAndStatus, ScrW, 35 *ScaleX) modle:self.food];
    __weak typeof (self)weakSelf = self;
    self.floatView.setEnjoyBtnStatus = ^(BOOL select) {
        [weakSelf.headViewCell1 setEnjoyBtnSelectdd:select];
    };
    self.floatView.hidden = YES;
    [self.view addSubview:self.floatView];
}
#pragma mark - 获取食品详情
- (void)getFoodDetailById{
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"foodId":self.foodId} url:URL_GETFOODDETAILBYID successBlock:^(id requestData, NSDictionary *dataDict) {
        [MBProgressHUDTools hideHUD];
        self.food = [FoodModel createModelWithDic:dataDict];
        [self createCycleBottomView];
        [self createHeadViewCell1];
        [self createHeadViewCell2];
        [self createFloatView];
        self.tableView.alpha = 1;
        [self.tableView reloadData];
        [self createFootView];

    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
        [MBProgressHUDTools showTipMessageHudWithtitle:@"食品信息获取失败"];

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

#pragma mark - 获取最新评论
- (void)getNewComments{
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"foodId":self.foodId} url:URL_GETNEWCOMMENTS successBlock:^(id requestData, NSDictionary *dataDict) {
        [self.commentArr removeAllObjects];
        for (NSDictionary *tempDict in (NSArray *)dataDict) {
            CommentModel *model = [CommentModel createModelWithDic:tempDict];
            [self.commentArr addObject:model];
        }
        self.tableView.tableFooterView = [self createTableviewFootViewWithCommentCount:[requestData[@"count"] integerValue]];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:4];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        DLog(@"");
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
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
    
    CGRect rect = [self.view convertRect:self.headView.frame  fromView:self.tableView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(rect.origin.y <= High_NavAndStatus){
        self.floatView.hidden = NO;
    }else{
        self.floatView.hidden = YES;
    }
    
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
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return self.shopContractArr.count;
            break;
        case 4:
            return self.commentArr.count;
            break;
          
        default:
            return 2;
            break;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FoodDetailCountDownCell *cell = [[FoodDetailCountDownCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil  title:self.sessionTitleArr[indexPath.section]];
        cell.food =self.food;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 1){
        
        EventExplainCell *cell = [[EventExplainCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title:self.sessionTitleArr[indexPath.section]];
        cell.food = self.food;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.section == 2){
        FoodInfoCell *cell = [[FoodInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title:self.sessionTitleArr[indexPath.section]];
        cell.food = self.food;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            ShopContractsCell *cell = [[ShopContractsCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title:self.sessionTitleArr[indexPath.section] ];
            cell.model = self.shopContractArr[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.makePhoneCalls = ^(NSString *phoneNum) {
                NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",phoneNum];
                
                UIWebView *callWebview = [[UIWebView alloc]init];
                
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                
                [self.view addSubview:callWebview];
            };
            return cell;
        }
        ShopContractsCell2 *cell = [[ShopContractsCell2 alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title:self.sessionTitleArr[indexPath.section] ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.shopContractArr[indexPath.row];
        cell.makePhoneCalls = ^(NSString *phoneNum) {
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",phoneNum];
            
            UIWebView *callWebview = [[UIWebView alloc]init];
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [self.view addSubview:callWebview];
        };
        return cell;
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            static NSString *commentCell = @"commentCell";
            CommentFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
            if (cell == nil) {
                cell = [[CommentFirstCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commentCell title:self.sessionTitleArr[indexPath.section]];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.commentArr[indexPath.row];
            return cell;
        }else{
            static NSString *commentCell = @"commentCell2";
            CommentOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
            if (cell == nil) {
                cell = [[CommentOtherCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commentCell];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.commentArr[indexPath.row];
            return cell;
        }
    }
    static NSString *cellMark = @"food";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMark];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellMark ];
    }
    cell.detailTextLabel.text = @"haha";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return [self.tableView cellHeightForIndexPath:indexPath model:self.food keyPath:@"food" cellClass:[FoodDetailCountDownCell class] contentViewWidth:ScrW];
            break;
        case 1 :
            return [self.tableView cellHeightForIndexPath:indexPath model:self.food keyPath:@"food" cellClass:[EventExplainCell class] contentViewWidth:ScrW];
            break;
        case 2 :
            return [self.tableView cellHeightForIndexPath:indexPath model:self.food keyPath:@"food" cellClass:[FoodInfoCell class] contentViewWidth:ScrW];
            break;
        case 3 :
            if (indexPath.row == 0) {
                return [self.tableView cellHeightForIndexPath:indexPath model:self.shopContractArr[indexPath.row] keyPath:@"model" cellClass:[ShopContractsCell class] contentViewWidth:ScrW];
            }else{
                return [self.tableView cellHeightForIndexPath:indexPath model:self.shopContractArr[indexPath.row] keyPath:@"model" cellClass:[ShopContractsCell2 class] contentViewWidth:ScrW];
            }
            
            break;
        case 4 :
            if (indexPath.row == 0) {
                return [self.tableView cellHeightForIndexPath:indexPath model:self.commentArr[indexPath.row] keyPath:@"model" cellClass:[CommentFirstCell class] contentViewWidth:ScrW];
            }else{
                return [self.tableView cellHeightForIndexPath:indexPath model:self.commentArr[indexPath.row] keyPath:@"model" cellClass:[CommentOtherCell class] contentViewWidth:ScrW];
            }
            
            break;
            
        default:
            break;
    }
    return 40 *ScaleX;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sessionTitleArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 接收到通知，刷新页面显示
- (void)refreashData{
    [self.tableView reloadData];
}

#pragma mark - 我要评论
- (void)commentBtnClick:(UIButton *)btn{
    if (btn.tag == 10) {
        if([GlobalTools userIsLogin]){
            CommentViewController *cvc = [[CommentViewController alloc]init];
            cvc.foodId = self.foodId;
            [self.navigationController pushViewController:cvc animated:YES];
        }else{
            [GlobalTools presentLoginViewController];
        }
    }else{
        CommentListViewController *clvc = [[CommentListViewController alloc]init];
        clvc.foodId = self.foodId;
        [self.navigationController pushViewController:clvc animated:YES];
    }
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_STOP_COUNT_DOWN object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_COMMENT_SUCCESS object:nil];
}
@end
