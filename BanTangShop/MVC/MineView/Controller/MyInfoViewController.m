//
//  MyInfoViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/28.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "MyInfoViewController.h"
#import "HeadImageCell.h"
#import "InfoTableViewCell.h"
#import "EditeUserInfoController.h"
#import "ChangeSexViewController.h"
#import "ShowBigPhotoViewController.h"// 点击头像查看大图

@interface MyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UserModel *model;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataArr;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HeadImageCell *cell= [[HeadImageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.model = self.model;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        InfoTableViewCell *cell =[[InfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = self.dataArr[indexPath.section -1][indexPath.row];
        cell.model = self.model;
        if (indexPath.section == 1 && indexPath.row == 3) {
            cell.accessoryType = UITableViewCellSelectionStyleNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return [self.dataArr[section - 1] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [self.tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[HeadImageCell class] contentViewWidth:ScrW];
    }
    return 40 *ScaleX;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ShowBigPhotoViewController *sbpvc = [[ShowBigPhotoViewController alloc]init];
        sbpvc.model = self.model;
        [self.navigationController pushViewController:sbpvc animated:YES];
    }else  {//(indexPath.section !=0)
        if (!((indexPath.row ==3 && indexPath.section == 1) || (indexPath.section == 1 && indexPath.row == 2))) {
            EditeUserInfoController *evc = [[EditeUserInfoController alloc]init];
            evc.titleStr = self.dataArr[indexPath.section-1][indexPath.row];
            evc.model =self.model;
            [self.navigationController pushViewController:evc animated:YES];
        }else if(indexPath.section == 1 && indexPath.row == 2){
            ChangeSexViewController *cvc = [[ChangeSexViewController alloc]init];
            cvc.model = self.model;
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScrW, ScrH ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = Color_Back_Gray;
    }
    return _tableView;
}
- (NSArray *)dataArr{
    if (!_dataArr) {
        NSArray *tempArr1 = @[@"昵称",@"姓名",@"性别",@"注册时间"];
        NSArray *tempArr2 = @[@"手机号",@"微信号",@"QQ"];
        _dataArr = [NSArray arrayWithObjects:tempArr1,tempArr2, nil];
    }
    return _dataArr;
}

#pragma mark - 读取本地存储的用户信息
- (void)getModel{
    
    _model = [[InfoDBAccess sharedInstance]getInfoFromUserInfoTable:[GlobalTools getData:USER_ID]];
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [self getModel];
    [self.tableView reloadData];
}

@end
