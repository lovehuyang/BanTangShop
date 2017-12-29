//
//  AddressViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/29.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "AddressModel.h"
#import "AddAddressViewController.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArr;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.view.backgroundColor = Color_Back_Gray;
    [self createBottomBtn];// 底部按钮
    [self.view addSubview:self.tableView];
    [self getAddress];// 获取收货地址
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddress) name:NOTIFICATION_ADDRADDRESS object:nil];
}
#pragma mark - 获取收货地址
- (void)getAddress{
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"username":[GlobalTools getData:USER_PHONE]} url:URL_GETADDRESS successBlock:^(id requestData, NSDictionary *dataDict) {
        DLog(@"");
        [self.dataArr removeAllObjects];
        for (NSDictionary *tempDict in (NSArray *)dataDict) {
            AddressModel *model = [AddressModel createModelWithDic:tempDict];
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools showWarningHudWithtitle:msg];
    }];
}

#pragma mark - 设置默认地址
- (void)setDefaultAddress:(AddressModel *)address{
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"addressId":address.ID,@"username":[GlobalTools getData:USER_PHONE]} url:URL_SETDEFAULTADDRESS successBlock:^(id requestData, NSDictionary *dataDict) {
        [MBProgressHUDTools hideHUD];
        NSString *datas = [NSString stringWithFormat:@"%@",dataDict];
        if ([datas isEqualToString:@"1"]) {
            
            [self getAddress];
        }
        [MBProgressHUDTools showSuccessHudWithtitle:requestData[@"msg"]];
        
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showWarningHudWithtitle:msg];
    }];
}

#pragma mark - 删除地址
- (void)delAddress:(NSIndexPath *)indexPath{
    [MBProgressHUDTools showLoadingHudWithtitle:@"正在删除"];
    AddressModel *model = [self.dataArr objectAtIndex:indexPath.row];
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"addressId":model.ID} url:URL_DELADDRESS successBlock:^(id requestData, NSDictionary *dataDict) {
         NSString *datas = [NSString stringWithFormat:@"%@",dataDict];
        if ([datas isEqualToString:@"1"]) {
            //删除数据，和删除动画
            [self.dataArr removeObjectAtIndex:indexPath.row];
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showSuccessHudWithtitle:requestData[@"msg"]];
        DLog(@"");
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showSuccessHudWithtitle:@"msg"];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *addressCell = @"addressCell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCell];
    if (!cell) {
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addressCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.address = self.dataArr[indexPath.row];
    cell.setDefaultAddress = ^(AddressModel *address) {
        [self setDefaultAddress:address];
    };
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArr[indexPath.row] keyPath:@"address" cellClass:[AddressCell class] contentViewWidth:ScrW];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    EnsureAlterView *alterView = [[EnsureAlterView alloc] initWithFrame:CGRectMake(0, 0, ScrW, ScrH)];
    __weak __typeof (alterView)WeakAlterView = alterView;
    [WeakAlterView  initWithTitle:@"提示" andContent:@"您确定要删除该条地址信息吗？" andBtnTitleArr:@[@"取消",@"确定"] andCanDismiss:YES];
    WeakAlterView.clickButtonBlock = ^(UIButton *button) {
        if (button.tag == 101) {
            
            [self delAddress:indexPath];//删除收货地址
        }
    };
    [WeakAlterView show];
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, High_NavAndStatus, ScrW , ScrH - 60 - High_NavAndStatus) style:UITableViewStylePlain];
        _tableView.backgroundColor = Color_Back_Gray;
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)createBottomBtn{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, ScrH - 60, ScrW, 60)];
    backView.backgroundColor = Color_Back_Gray;
    [self.view addSubview:backView];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(LONGBTN_MARGIN, CGRectGetHeight(backView.frame)/2 - LONGBTN_HEIGHT/2, ScrW - 2 *LONGBTN_MARGIN, LONGBTN_HEIGHT);
    [backView addSubview:btn];
    btn.layer.cornerRadius = LONGBTN_CORNER;
    [btn setBackgroundColor:Color_Theme];
    [btn setTitle:@"添加收货地址" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:LONGBTN_FONT];
    [btn addTarget:self action:@selector(addAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAddressBtnClick{
    AddAddressViewController *avc = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ADDRADDRESS object:nil];
}

@end
