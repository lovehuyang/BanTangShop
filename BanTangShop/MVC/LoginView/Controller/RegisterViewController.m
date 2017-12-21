//
//  RegisterViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomNavView.h"
#import "SelectSexView.h"
#import "RegisterTextField.h"

@interface RegisterViewController ()
@property (nonatomic, strong)SelectSexView *sexView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];// 导航栏
    [self setupSelectSexView];// 性别选择
    [self createTextField];// 创建文本框
}
#pragma mark - 文本框
- (void)createTextField{
    NSArray *titleArr = @[@"昵  称:",@"手机号:",@"验证码:",@"密  码:"];
    NSArray *placeholderArr = @[@"请输入您的昵称",@"请输入您的手机号",@"请输入手机验证码",@"请设置登录密码"];
    CGFloat TextField_H = 35;
    for (int i = 0; i < 4; i ++) {
        RegisterTextField *textField = [[RegisterTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.sexView.frame) + 5 + (TextField_H + 10) *i, ScrW - 40, TextField_H) title:titleArr[i] placeholder:placeholderArr[i]];
        [self.view addSubview:textField];
    }
}
#pragma mark - 性别选择
- (void)setupSelectSexView{
    self.sexView = [[SelectSexView alloc]initWithFrame:CGRectMake(0, High_NavAndStatus + 30, ScrW, 130)];
    self.sexView.selectSex = ^(Sex sex) {
    };
    [self.view addSubview:self.sexView];
}

#pragma mark - 导航栏
- (void)setupNavBar{
    
    CustomNavView *nav = [[CustomNavView alloc]initWithFrame:CGRectMake(0, 0, ScrW, High_NavAndStatus) title:@"注册"];
    nav.returnEvent = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:nav];
}

@end
