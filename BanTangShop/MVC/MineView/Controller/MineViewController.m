//
//  MineViewController.m
//  GitHudStudy
//
//  Created by tzsoft on 2017/12/7.
//  Copyright © 2017年 TZSoft. All rights reserved.
//

#import "MineViewController.h"
#import "CenterViewController.h"
#import "LoginViewController.h"
#import "MyInfoViewController.h"
#import "AddressViewController.h"// 收货地址

#define Height_TopBackImageView  220*ScaleX // 顶部背景图片的高度
@interface MineViewController ()
{
    NSArray *_titleArr;// cell标题
    NSArray *_iconArr;// cell 图标
}
@property (nonatomic ,strong)UITableView *tableView;
// tableview的头视图
@property (nonatomic,strong) UIView *tableviewHeadView;
// tableview的foot视图
@property (nonatomic,strong) UIView *tableviewFootView;
// tableview头视图背景
@property (nonatomic ,strong)UIImageView *topBackView;
//头像
@property (nonatomic,strong) UIImageView *headImageView;
//名字
@property (nonatomic,strong) UIButton *nameBtn;
@property (nonatomic ,strong) UserModel *userModel;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataArr];
    self.view.backgroundColor = Color_Back_Gray;
    [self.view addSubview:self.tableView];
    [self createTableview];// 添加头像控件
    [self setData];// 添加数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setData) name:NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setData) name:NOTIFICATION_EXIT object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setData) name:NOTIFICATION_UPDATEUSERINFO object:nil];
}

#pragma mark - 取数据、设置控件状态
- (void)setData{
    if ([GlobalTools userIsLogin]) {
        DLog(@"用户登录");
        self.userModel = [[InfoDBAccess sharedInstance]getInfoFromUserInfoTable:[GlobalTools getData:USER_ID]];
        self.tableviewFootView.hidden = NO;
        self.nameBtn.userInteractionEnabled = NO;
        [self.nameBtn setTitle:self.userModel.nickname forState:UIControlStateNormal];
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar] placeholderImage:[UIImage imageNamed:@"img_zhanweifu"]];
        
    }else{
        self.tableviewFootView.hidden = YES;
        self.nameBtn.userInteractionEnabled = YES;
        [self.nameBtn setTitle:@"点击登录" forState:UIControlStateNormal];
    }
}

#pragma mark - 创建cell的数据源
- (void)createDataArr{
    NSArray *titleArr1 = @[@"我的资料",@"收货地址",@"我的订单"];
    NSArray *titleArr2 = @[@"意见与反馈",@"设置",@"马超·技术支持"];
    _titleArr = @[titleArr1,titleArr2];
    NSArray *iconArr1 =  @[@"wo_profile",@"wo_ls_gh",@"wo_jkda"];
    NSArray *iconArr2 =  @[@"wo_help",@"wo_set",@"wo_kj"];
    _iconArr = @[iconArr1,iconArr2];
}
#pragma mark - 创建头像、名字视图
- (void)createTableview{

    //头像尺寸
    CGFloat headImageViewWH = 80 *ScaleX;
    UIView *headBackView = [[UIView alloc]init];
    headBackView.frame = CGRectMake(ScrW *0.5 - headImageViewWH *0.5, 50 *ScaleX, headImageViewWH, headImageViewWH);
    headBackView.layer.cornerRadius = headImageViewWH *0.5;
    
    //设置边框的阴影
    //1.设置边框的颜色
    headBackView.layer.shadowColor = [[UIColor blackColor] CGColor];
    //2.设置边框的偏移量CGSizeMake(左右偏移量，上下偏移量)
    headBackView.layer.shadowOffset = CGSizeMake(-5, 10);
    //3.设置阴影的不透明度
    headBackView.layer.shadowOpacity = 0.7;
    [self.tableviewHeadView addSubview:headBackView];
    
    //添加头像
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.frame = CGRectMake(0, 0, headImageViewWH, headImageViewWH);
    headImageView.layer.cornerRadius = headImageViewWH *0.5;
    headImageView.layer.masksToBounds = YES;
    self.headImageView = headImageView;
    [headImageView setImage:[UIImage imageNamed:@"img_zhanweifu"]];
    [headBackView addSubview:self.headImageView];
    // 名字
    UIButton *nameBtn = [[UIButton alloc]init];
    nameBtn.frame = CGRectMake(0, CGRectGetMaxY(headBackView.frame) + 15 , ScrW, 30);
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    nameBtn.titleLabel.textColor = [UIColor whiteColor];
    self.nameBtn = nameBtn;
    [self.tableviewHeadView addSubview:self.nameBtn];
    [self.nameBtn addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW , ScrH - 49 ) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.tableFooterView = self.tableviewFootView;
        _tableView.tableHeaderView = self.tableviewHeadView;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(UIView *)tableviewHeadView{
    if (!_tableviewHeadView) {
        _tableviewHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScrW, Height_TopBackImageView )];
        _tableviewHeadView.userInteractionEnabled = YES;
        [_tableviewHeadView addSubview:self.topBackView];
    }
    return _tableviewHeadView;
}
- (UIView *)tableviewFootView{
    if (!_tableviewFootView) {
        _tableviewFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScrW, Height_TopBackImageView * 0.5)];
        UIButton *exitBtn = [UIButton new];
        [_tableviewFootView addSubview:exitBtn];
        exitBtn.sd_layout
        .leftSpaceToView(_tableviewFootView, LONGBTN_MARGIN)
        .rightSpaceToView(_tableviewFootView, LONGBTN_MARGIN)
        .heightIs(LONGBTN_HEIGHT)
        .centerYEqualToView(_tableviewFootView);
        exitBtn.backgroundColor = Color_Theme;
        exitBtn.sd_cornerRadius = @(LONGBTN_CORNER);
        exitBtn.titleLabel.font = [UIFont systemFontOfSize:LONGBTN_FONT];
        [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableviewFootView;
}

- (UIImageView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScrW, Height_TopBackImageView)];
        _topBackView.image = [UIImage imageNamed:@"wo_banner"];
        _topBackView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _topBackView.clipsToBounds=YES;
        _topBackView.contentMode=UIViewContentModeScaleAspectFill;
    }
    return _topBackView;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArr = _titleArr[indexPath.section];
    NSArray *iconArr = _iconArr[indexPath.section];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:iconArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if([GlobalTools userIsLogin]){
                MyInfoViewController *mvc = [[MyInfoViewController alloc]init];
                [self.navigationController pushViewController:mvc animated:YES];
            }else{
                
                [GlobalTools presentLoginViewController];
            }
        }else if (indexPath.row == 1){
            AddressViewController *avc = [[AddressViewController alloc]init];
            [self.navigationController pushViewController:avc animated:YES];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = _titleArr[section];
    return tempArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section !=0) {
        return 15;
    }
    return 0;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect rect =self.tableviewHeadView.frame;
        rect.origin.y = offset.y;
        rect.size.height =CGRectGetHeight(rect)-offset.y;
        self.topBackView.frame = rect;
        self.tableviewHeadView.clipsToBounds=NO;
    }
}
//分割线从顶端开始的设置1
-(void)viewDidLayoutSubviews{
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
//分割线从顶端开始的设置2
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 退出登录
- (void)exitBtnClick{
    EnsureAlterView *alterView = [[EnsureAlterView alloc] initWithFrame:CGRectMake(0, 0, ScrW, ScrH)];
    __weak __typeof (alterView)WeakAlterView = alterView;
     [WeakAlterView  initWithTitle:@"退出登录" andContent:@"您确定要退出登录吗？" andBtnTitleArr:@[@"取消",@"确定"] andCanDismiss:YES];
    WeakAlterView.clickButtonBlock = ^(UIButton *button) {
        if (button.tag == 101) {
            [GlobalTools removeData:USER_ID];
            [GlobalTools removeData:USER_PASSWORD];
            
            [MBProgressHUDTools showLoadingHudWithtitle:@"正在退出..."];
            
            if (@available(iOS 10.0, *)) {
                [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                    [self exit];
                }];
            } else {
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(exit) userInfo:nil repeats:NO];
            }
        }
    };
    [WeakAlterView show];
    
}
- (void)exit{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_EXIT object:nil];// 退出通知
    [MBProgressHUDTools showTipMessageHudWithtitle:@"退出成功！"];
}
#pragma mark - 登录
- (void)loginEvent{
    LoginViewController *lvc = [[LoginViewController alloc]init];
    [self presentViewController:lvc animated:YES completion:^{
        
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_EXIT object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_UPDATEUSERINFO object:nil] ;
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
}

@end
