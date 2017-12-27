//
//  MineViewController.m
//  GitHudStudy
//
//  Created by tzsoft on 2017/12/7.
//  Copyright © 2017年 TZSoft. All rights reserved.
//

#import "CenterViewController.h"
#import "CustomNavSearchBar.h"
#import "HomeTableViewCell.h"
#import "MBProgressHUDTools.h"
#import "TopMenuView.h"
#import "MenuButton.h"
#import "FoodListModel.h"
#import "FoodsDetailController.h"

#define SEARCHBAR_H  30 //搜索框的高度
#define MENU_H  35 *ScaleX  //菜单栏的高度
#define CELL_H 35 *ScaleX// menuTableView每个cell的高度

@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_keyword;// 插叙关键字
    NSString *_catagory;// 类别
    NSString *_brand;// 品牌
    NSString *_flavor;// 口味
    int _page;// 页码
    BOOL _haveNextPage;// 是否还有下一页数据
}
@property (nonatomic ,strong)CustomNavSearchBar *textFieled;// 导航栏搜索框
@property (nonatomic ,strong)NSArray *menuTitleArr;// 菜单栏:品牌、类别、口味标题数组
@property (nonatomic ,strong)MenuButton *brandBtn;
@property (nonatomic ,strong)MenuButton *categoryBtn;
@property (nonatomic ,strong)MenuButton *flavourBtn;
@property (nonatomic ,strong)UIView *backView;// 黑色半透明背景
@property (nonatomic ,strong)UITableView *menuTableView;//菜单栏下拉的tableview
@property (nonatomic ,strong)NSMutableArray *menuDataArr;// 菜单栏的数据源
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArr;// 列表的数据源
@property (nonatomic ,strong)NSMutableArray *categoryArr;// 食品类别
@property (nonatomic ,strong)NSMutableArray *flavourArr; // 食品口味
@property (nonatomic ,strong)NSMutableArray *barndArr;// 食品品牌
@end

@implementation CenterViewController
- (instancetype)init{
    if (self = [super init]) {
        CustomNavSearchBar *textFieled = [[CustomNavSearchBar alloc]initWithFrame:CGRectMake(0, 0, ScrW  , SEARCHBAR_H) placeholder:@"输入食品关键字"];
        textFieled.delegate = self;
        self.textFieled = textFieled;
        self.navigationItem.titleView = self.textFieled;
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"查找" style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    _keyword = @"";
    _brand = @"0";
    _catagory = @"0";
    _flavor = @"0";
    _haveNextPage = YES;
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTopMenuView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.menuTableView];
    [self getFoodListPage];
    [self addRefreashAndLoadMore];// 添加刷新和加载更多
    [MBProgressHUDTools showLoadingHudWithtitle:nil];
}

#pragma mark - 懒加载
- (NSArray *)menuTitleArr{
    if (!_menuTitleArr) {
        _menuTitleArr = [NSArray arrayWithObjects:@"品牌",@"类别",@"口味", nil];
    }
    return _menuTitleArr;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MENU_H, ScrW, ScrH - High_NavAndStatus - MENU_H) style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MENU_H, ScrW, ScrH - High_NavAndStatus - MENU_H) style:UITableViewStylePlain];
        _menuTableView.tableFooterView = [UIView new];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.hidden = YES;
    }
    return _menuTableView;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5;
        _backView.frame = CGRectMake(0, MENU_H, ScrW, ScrH - MENU_H - High_NavAndStatus);
        _backView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}
- (NSMutableArray *)barndArr{
    if (!_barndArr) {
        _barndArr = [[InfoDBAccess sharedInstance]loadAllInfoTable:Table_FoodBrand_ENUM];
        Model *model = [[Model alloc]init];
        model.ID = @"0";
        model.name = @"全部品牌";
        [_barndArr insertObject:model atIndex:0];
    }
    return _barndArr;
}
- (NSMutableArray *)flavourArr{
    if (!_flavourArr) {
        _flavourArr = [[InfoDBAccess sharedInstance]loadAllInfoTable:Table_FoodFlavour_ENUM];
        Model *model = [[Model alloc]init];
        model.ID = @"0";
        model.name = @"全部口味";
        [_flavourArr insertObject:model atIndex:0];
    }
    return _flavourArr;
}
- (NSMutableArray *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = [[InfoDBAccess sharedInstance]loadAllInfoTable:Table_FoodCatagory_ENUM];
        Model *model = [[Model alloc]init];
        model.ID = @"0";
        model.name = @"全部类别";
        [_categoryArr insertObject:model atIndex:0];
    }
    return _categoryArr;
}

- (NSMutableArray *)menuDataArr{
    if (!_menuDataArr) {
        _menuDataArr = [NSMutableArray array];
    }
    return _menuDataArr;
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
        _page = 1;
        [self getFoodListPage];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (_haveNextPage) {
            _page ++;
            [self getFoodListPage];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - tableview重新加载数据
- (void)tableViewReloadData{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - menuTableView重新加载数据
- (void)menuTableViewReloadData{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.menuTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 分页获取食品列表(多条件)
- (void)getFoodListPage{
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSDictionary *paraDict = @{@"keyword":_keyword,@"catagory":_catagory,@"brand":_brand,@"flavour":_flavor,@"page":page};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paraDict url:URL_GETFOODLISTPAGE successBlock:^(id requestData, NSDictionary *dataDict) {
        [MBProgressHUDTools hideHUD];
        _haveNextPage =  [requestData[@"isHasNext"] boolValue];
        NSArray *dataArr = (NSArray *)dataDict;
        
        if (dataArr.count == 0) {
            [MBProgressHUDTools showTipMessageHudWithtitle:@"暂无数据"];
        }else{
            for (NSDictionary *tempDict in dataArr) {
                FoodListModel *food = [FoodListModel createModelWithDic:tempDict];
                [self.dataArr addObject:food];
            }
        }
        [self tableViewReloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuTableView) {
        static NSString *menuCell = @"menuCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCell];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:menuCell];
        }
        cell.backgroundColor = [UIColor whiteColor];
        Model *model = [self.menuDataArr objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
        
    }else{
        
        static NSString *homeCell =@"homeCell";
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell];
        if (cell == nil) {
            cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:homeCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.food = [self.dataArr objectAtIndex:indexPath.row];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.menuTableView) {
        return self.menuDataArr.count;
    }else{
        return self.dataArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.menuTableView) {
        return CELL_H;
    }else{
        return 120 ;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuTableView) {
        _haveNextPage = YES;
        [self.dataArr removeAllObjects];
        Model *model = [self.menuDataArr objectAtIndex:indexPath.row];
        if (self.brandBtn.selected) {
            [self.brandBtn setTitle:model.name forState:UIControlStateNormal];
            [self updateMenuBtnStatus:self.brandBtn];
            _brand = model.ID;
        }else if (self.categoryBtn.selected) {
            [self.categoryBtn setTitle:model.name forState:UIControlStateNormal];
            [self updateMenuBtnStatus:self.categoryBtn];
            _catagory = model.ID;
        }else if (self.flavourBtn.selected) {
            [self.flavourBtn setTitle:model.name forState:UIControlStateNormal];
            [self updateMenuBtnStatus:self.flavourBtn];
            _flavor = model.ID;
        }
        [self tapBackView];
        _page = 1;
        [MBProgressHUDTools showLoadingHudWithtitle:nil];
        [self getFoodListPage];
    }else{
        FoodListModel *food = [self.dataArr objectAtIndex:indexPath.row];
        FoodsDetailController *fdvc =[[FoodsDetailController alloc]init];
        fdvc.foodId = food.ID;
        [self.navigationController pushViewController:fdvc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self tapBackView];
    return YES;
}

#pragma mark - 创建顶部菜单栏
- (void)createTopMenuView{
    CGFloat W = ScrW/self.menuTitleArr.count;
    for (int i = 0; i < self.menuTitleArr.count; i ++) {
        TopMenuView *menuView = [[TopMenuView alloc]initWithFrame:CGRectMake(W *i, 0, W, MENU_H) ];
        menuView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:menuView];
        
        MenuButton *button = [[MenuButton alloc]initWithFrame:CGRectMake(0, 0, menuView.frame.size.width, menuView.frame.size.height - 2)];
        [button setTitle:self.menuTitleArr[i] forState:UIControlStateNormal];
        CGSize btnSize = [GlobalTools sizeWithText:button.titleLabel.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScrW, button.frame.size.height)];
        button.frame = CGRectMake(0, 0, btnSize.width +15, button.frame.size.height);
        button.center = CGPointMake( W/2,CGRectGetHeight(menuView.frame)/2);
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        if (i == 0) {
            self.brandBtn = button;
        }else if(i == 1) {
            self.categoryBtn = button;
        }else if(i == 2) {
            self.flavourBtn = button;
        }
        [menuView addSubview:button];
    }
}

#pragma mark - 更新菜单栏按钮显示
- (void)updateMenuBtnStatus:(MenuButton *)menuBtn{
    CGFloat W = ScrW/self.menuTitleArr.count;
    CGSize btnSize = [GlobalTools sizeWithText:menuBtn.titleLabel.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScrW, menuBtn.frame.size.height)];
    menuBtn.frame = CGRectMake(0, 0, btnSize.width +15, menuBtn.frame.size.height);
    menuBtn.center = CGPointMake( W/2,menuBtn.center.y);
}

#pragma mark - 导航栏查询按钮点击事件
- (void)searchBtnClick{
    _page = 1;
    _keyword = self.textFieled.text;
    _haveNextPage = YES;
    [self.dataArr removeAllObjects];
    [self tapBackView];
    [self getFoodListPage];
    [MBProgressHUDTools showLoadingHudWithtitle:nil];
}

#pragma mark - 下拉菜单的展开与折叠

- (void)menuBtnClick:(MenuButton *)btn{
    [self.textFieled resignFirstResponder];
    [self.menuDataArr removeAllObjects];
    if (btn == self.brandBtn) {
        self.brandBtn.selected = !self.brandBtn.selected;
        self.categoryBtn.selected = NO;
        self.flavourBtn.selected = NO;
    }else if (btn == self.categoryBtn) {
        self.categoryBtn.selected = !self.categoryBtn.selected;
        self.brandBtn.selected = NO;
        self.flavourBtn.selected = NO;
    }else if (btn == self.flavourBtn) {
        self.flavourBtn.selected = !self.flavourBtn.selected;
        self.categoryBtn.selected = NO;
        self.brandBtn.selected = NO;
    }
    if (btn.selected == YES) {
        
        switch (btn.tag - 100) {
            case 0:
                [self.menuDataArr addObjectsFromArray:self.barndArr];
                break;
            case 1:
                [self.menuDataArr addObjectsFromArray:self.categoryArr];
                break;
            case 2:
                [self.menuDataArr addObjectsFromArray:self.flavourArr];
                break;
                
            default:
                break;
        }
        self.menuTableView.frame = CGRectMake(self.menuTableView.frame.origin.x, MENU_H, ScrW, CELL_H *self.menuDataArr.count);
        [self menuTableViewReloadData];
        [UIView animateWithDuration:0.1 animations:^{
            self.backView.alpha = 0.5;
            self.menuTableView.alpha = 1;
        } completion:^(BOOL finished) {
            self.backView.hidden = NO;
            self.menuTableView.hidden = NO;;
        }];
        
    }else{
        [self.menuDataArr removeAllObjects];
        [self menuTableViewReloadData];
        [UIView animateWithDuration:0.3 animations:^{
            self.backView.alpha = 0;
            self.menuTableView.alpha = 0;
        } completion:^(BOOL finished) {
            self.backView.hidden = YES;
            self.menuTableView.hidden = YES;
        }];
    }
}

#pragma mark - 点击黑色半透明背景
- (void)tapBackView{
    self.categoryBtn.selected = NO;
    self.brandBtn.selected = NO;
    self.flavourBtn.selected = NO;
    
    [self.menuDataArr removeAllObjects];
    [self menuTableViewReloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0;
        self.menuTableView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.hidden = YES;
        self.menuTableView.hidden = YES;
    }];
}
@end
