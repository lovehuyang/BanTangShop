//
//  ChangeSexViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/28.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "ChangeSexViewController.h"
#import "SelectSexView.h"

@interface ChangeSexViewController ()

@property (nonatomic, strong)SelectSexView *sexView;
@end

@implementation ChangeSexViewController
- (instancetype)init{
    if (self = [super init]) {
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置性别";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSelectSexView];
}

#pragma mark - 性别选择
- (void)setupSelectSexView{
    self.sexView = [[SelectSexView alloc]initWithFrame:CGRectMake(0, High_NavAndStatus + 30, ScrW, 130)];
    if ([self.model.sex isEqualToString:@"女士"]) {
        self.sexView.girlBtn.selected = YES;
        self.sexView.boyBtn.selected = NO;
    }else{
        self.sexView.boyBtn.selected = YES;
        self.sexView.girlBtn.selected = NO;
    }
    __weak  typeof (self)weakSelf = self;
    self.sexView.selectSex = ^(Sex sex) {
        switch (sex) {
            case Sex_Boy:
                weakSelf.model.sex = @"先生";
                break;
                
            default:
                weakSelf.model.sex = @"女士";
                break;
        }
    };
    [self.view addSubview:self.sexView];
}

- (void)navBtnClick{
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    NSDictionary *paramDict = @{@"username":self.model.username,@"nickname":self.model.nickname,@"realname":self.model.realname,@"sex":[self.model.sex isEqualToString:@"0"]?@"女士":@"先生",@"phone":self.model.phone,@"wx":self.model.wx,@"qq":self.model.qq};
    [HLYNetWorkObject requestWithMethod:POST ParamDict:paramDict url:URL_UPDATEUSERINFO successBlock:^(id requestData, NSDictionary *dataDict) {
        [[InfoDBAccess sharedInstance] databaseUserInfoTable:self.model];
        if([(NSString *)dataDict isEqualToString:@"1"] ){
            [MBProgressHUDTools showTipMessageHudWithtitle:@"修改信息成功！"];
            if (@available(iOS 10.0, *)) {
                [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
                    [self returnViewController];
                }];
            } else {
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(returnViewController) userInfo:nil repeats:NO];
            }
        }
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
        [MBProgressHUDTools showTipMessageHudWithtitle:@"信息修改失败，请稍后重试"];
    }];
}

// 返回上一级页面
- (void)returnViewController{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATEUSERINFO object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
