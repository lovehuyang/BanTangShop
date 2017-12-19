//
//  MineViewController.m
//  GitHudStudy
//
//  Created by tzsoft on 2017/12/7.
//  Copyright © 2017年 TZSoft. All rights reserved.
//

#import "CenterViewController.h"
#import "CustomNavSearchBar.h"
#import "TopMenuView.h"
#import "MenuButton.h"

#define SEARCHBAR_H  30 //搜索框的高度
#define MENU_H  35 *ScaleX  //菜单栏的高度
#define CELL_H 35 *ScaleX// menuTableView每个cell的高度

@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_searchText;// 搜索框内容
}
@property (nonatomic ,strong)NSArray *menuTitleArr;// 菜单栏:品牌、类别、口味标题数组
@property (nonatomic ,strong)MenuButton *brandBtn;
@property (nonatomic ,strong)MenuButton *categoryBtn;
@property (nonatomic ,strong)MenuButton *flavourBtn;

@property (nonatomic ,strong)UITableView *menuTableView;//菜单栏下拉的tableview
@property (nonatomic ,strong)UIView *backView;// 黑色半透明背景
@property (nonatomic ,strong)NSMutableArray *menuDataArr;// 菜单栏的数据源
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *categoryArr;// 食品类别
@property (nonatomic ,strong)NSMutableArray *flavourArr; // 食品口味
@property (nonatomic ,strong)NSMutableArray *barndArr;// 食品品牌
@end

@implementation CenterViewController
- (instancetype)init{
    if (self = [super init]) {
        CustomNavSearchBar *textFieled = [[CustomNavSearchBar alloc]initWithFrame:CGRectMake(0, 0, ScrW  , SEARCHBAR_H) placeholder:@"输入食品关键字"];
        textFieled.searchBarText = ^(NSString *searchText) {
            _searchText = searchText;
        };
        self.navigationItem.titleView = textFieled;
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"查找" style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTopMenuView];
    [self.view addSubview:self.menuTableView];
    [self.view addSubview:self.backView];
    self.backView.hidden = YES;
    
    UILabel *tempLab = [UILabel new];
    tempLab.frame = CGRectMake(90, MENU_H + 30, 200, 300);
    tempLab.text = @"就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃就知道吃";
    tempLab.numberOfLines = 0;
//    [self.view addSubview:tempLab];
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
    }
    return _tableView;
}
- (UITableView *)menuTableView{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, MENU_H, ScrW, ScrH - High_NavAndStatus - MENU_H) style:UITableViewStylePlain];
        _menuTableView.tableFooterView = [UIView new];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
    }
    return _menuTableView;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5;
        _backView.frame = CGRectMake(0, 0, ScrW, ScrH);
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
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *menuCell = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:menuCell];
    }
    cell.backgroundColor = [UIColor whiteColor];
    Model *model = [self.menuDataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_H;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Model *model = [self.menuDataArr objectAtIndex:indexPath.row];
    if (self.brandBtn.selected) {
        [self.brandBtn setTitle:model.name forState:UIControlStateNormal];
        [self updateMenuBtnStatus:self.brandBtn];
    }else if (self.categoryBtn.selected) {
        [self.categoryBtn setTitle:model.name forState:UIControlStateNormal];
        [self updateMenuBtnStatus:self.categoryBtn];
    }else if (self.flavourBtn.selected) {
        [self.flavourBtn setTitle:model.name forState:UIControlStateNormal];
        [self updateMenuBtnStatus:self.flavourBtn];
    }
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
#pragma mark - 点击事件
- (void)searchBtnClick{
    DLog(@"查找内容：%@",_searchText);
}
- (void)menuBtnClick:(MenuButton *)btn{
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
        
        [self.menuTableView setHidden:NO];
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
        
        [UIView animateWithDuration:0.3 animations:^{
            self.menuTableView.frame = CGRectMake(self.menuTableView.frame.origin.x, MENU_H, ScrW, CELL_H *self.menuDataArr.count);
            self.backView.frame = CGRectMake(0, CGRectGetMaxY(self.menuTableView.frame), ScrW, ScrH);
        }];
        
    }else{
        
        [self.menuTableView setHidden:YES];
    }
    self.backView.hidden = self.menuTableView.hidden;
    [self.menuTableView reloadData];
}

- (void)tapBackView{
    self.categoryBtn.selected = NO;
    self.brandBtn.selected = NO;
    self.flavourBtn.selected = NO;
    self.menuTableView.hidden = YES;
    self.backView.hidden = YES;
}
@end
