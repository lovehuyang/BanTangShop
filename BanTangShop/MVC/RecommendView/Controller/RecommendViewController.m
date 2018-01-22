//
//  RecommendViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/15.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "RecommendViewController.h"
#import "CenterViewController.h"
#import "ConfirmOrderController.h"
#import "ShoppingCarHeaderCell.h"
#import "ShoppingCarCell.h"
#import "ShoppingCarModel.h"
#import "ShoppingCarBottonView.h"

#define H_BOTTOMVIEW 50
@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,copy)UITableView *tableView;
@property (nonatomic ,copy)NSMutableArray *dataArr;
@property (nonatomic ,copy)ShoppingCarBottonView *bottomView;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        CGFloat h = self.pageType == PageType_Other ? 0 : High_TabBar;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH  - High_NavAndStatus - h - H_BOTTOMVIEW) style:UITableViewStylePlain];
        _tableView.delegate =self;
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
- (ShoppingCarBottonView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[ShoppingCarBottonView alloc]init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScrW, H_BOTTOMVIEW);
        _bottomView.backgroundColor = [UIColor whiteColor];
        __weak __typeof (self)weakSelf = self;
        _bottomView.selectAllBtnClick = ^(UIButton *selectAllBtn) {
            for (NSArray *tempArr in weakSelf.dataArr) {
                for (ShoppingCarModel *model in tempArr) {
                    model.isSelected = selectAllBtn.selected;
                }
            }
            
            [weakSelf setBottomViewStatus];
            [weakSelf.tableView reloadData];
        };
        _bottomView.buyRightNow = ^{
            NSMutableArray *tempMutArr = [NSMutableArray array];
            for (NSArray *tempArr in weakSelf.dataArr) {
                for (ShoppingCarModel *model in tempArr) {
                    if (model.isSelected == YES) {
                        [tempMutArr addObject:model];
                    }
                }
            }
            ConfirmOrderController *cvc = [[ConfirmOrderController alloc]init];
            cvc.dataArr = tempMutArr;
            [weakSelf.navigationController pushViewController:cvc animated:YES];
        };
    }
    return _bottomView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        static NSString *cellMark = @"buyCar1";
        ShoppingCarHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMark];
        if (!cell) {
            cell = [[ShoppingCarHeaderCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellMark];
        }
        NSArray *tempArr = [self.dataArr objectAtIndex:indexPath.section];
        ShoppingCarModel *model = [tempArr firstObject];
        cell.model = model;
        cell.dataArr =tempArr;
        cell.tableViewHeaderBtnClick = ^(ShoppingCarModel *shoppingCarModel,UIButton *btn) {
            [self sectionHeaderBtnClick:indexPath btn:btn];
        };
        return cell;
    }else{
        static NSString *cellMark = @"buyCar";
        ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellMark];
        if (!cell) {
            cell = [[ShoppingCarCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellMark];
        }
        NSArray *tempArr = [self.dataArr objectAtIndex:indexPath.section];
        ShoppingCarModel *model =[tempArr objectAtIndex:indexPath.row -1];
        cell.model =model;
        cell.cellSelectBtncClick = ^(UIButton *selectBtn) {
            [self cellSelectBtnClick:indexPath btn:selectBtn];
        };
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArr objectAtIndex:section] count] + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 35;
    }else{
        return 100;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataArr.count;
}

#pragma mark - 获取购物车列表
- (void)getCartList{
    
    if([GlobalTools userIsLogin]){
        [self.dataArr removeAllObjects];
        [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"username":[GlobalTools getData:USER_PHONE]} url:URL_GETCARLIST successBlock:^(id requestData, NSDictionary *dataDict) {
            
            NSMutableArray *tempMutArr = [NSMutableArray array];
            for (NSDictionary *tempDict in (NSArray *)dataDict) {
                ShoppingCarModel *model = [ShoppingCarModel createModelWithDic:tempDict];
                model.isSelected = YES;
                [tempMutArr addObject:model];
            }
            
            NSArray *foodNameArr = [tempMutArr valueForKey:@"brand"];
            NSSet *indexSet = [NSSet setWithArray:foodNameArr];
            [[indexSet allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 根据NSPredicate获取array
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand == %@",obj];
                NSArray *indexArray = [tempMutArr filteredArrayUsingPredicate:predicate];
                
                // 将查询结果加入到resultArray中
                [self.dataArr addObject:indexArray];
            }];
            [self setBottomViewStatus];
            [self.tableView reloadData];
            DLog(@"");
        } failureBlock:^(NSInteger errCode, NSString *msg) {
            DLog(@"");
        }];
    }else{
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请先登录！"];
    }
    
}

#pragma mark - 点击事件
- (void)sectionHeaderBtnClick:(NSIndexPath *)indexPath btn:(UIButton *)titleBtn{

    NSArray *tempArr = [self.dataArr objectAtIndex:indexPath.section];
    for (ShoppingCarModel *model in tempArr) {
        model.isSelected = titleBtn.selected;
    }
    [self setBottomViewStatus];
    [self.tableView reloadData];
}

- (void)cellSelectBtnClick:(NSIndexPath *)indexPath btn:(UIButton *)selectBtn{
    
    NSArray *tempArr = [self.dataArr objectAtIndex:indexPath.section];
    ShoppingCarModel *model = [tempArr objectAtIndex:indexPath.row - 1];
    model.isSelected = !model.isSelected;
    [self setBottomViewStatus];
    [self.tableView reloadData];
}
- (void)setBottomViewStatus{
    CGFloat totalPrice = 0.00f;
    for (NSArray *tempArr in self.dataArr) {
        for (ShoppingCarModel *model in tempArr) {
            if(model.isSelected){
                CGFloat total_price = [model.total_price floatValue];
                totalPrice = totalPrice + total_price;
            }
        }
    }
    self.bottomView.totalLab.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    for (NSArray *tempArr in self.dataArr) {
        for (ShoppingCarModel *model in tempArr) {
            if (model.isSelected == NO) {
                self.bottomView.selectAllBtn.selected = NO;
                return;
            }else{
                self.bottomView.selectAllBtn.selected = YES;
            }
        }
    }
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCartList];// 获取购物车列表
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

@end
