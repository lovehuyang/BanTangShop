//
//  RegisterViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/21.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomNavView.h"
#import <SMS_SDK/SMSSDK.h>
#import "SelectSexView.h"
#import "RegisterTextField.h"
#import "RegisterTextField2.h"

@interface RegisterViewController ()
{
    NSString *_sex;// 性别
}
@property (nonatomic, strong)SelectSexView *sexView;
@property (nonatomic ,strong)RegisterTextField *nickName_TF;
@property (nonatomic ,strong)RegisterTextField *phone_TF;
@property (nonatomic ,strong)RegisterTextField2 *security_TF;
@property (nonatomic ,strong)RegisterTextField *password_TF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sex = @"先生";
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
        if (i !=2) {
            RegisterTextField *textField = [[RegisterTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.sexView.frame) + 5 + (TextField_H + 10) *i, ScrW - 40, TextField_H) title:titleArr[i] placeholder:placeholderArr[i]];
            if(i == 0){
                self.nickName_TF = textField;
            }else if (i == 1){
                self.phone_TF = textField;
                self.phone_TF.keyboardType = UIKeyboardTypeNumberPad;
            }else if (i == 3){
                self.password_TF = textField;
            }
            [self.view addSubview:textField];
            
        }else{
            RegisterTextField2 *textField = [[RegisterTextField2 alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.sexView.frame) + 5 + (TextField_H + 10) *i, ScrW - 40, TextField_H) title:titleArr[i] placeholder:placeholderArr[i]];
            self.security_TF = textField;
            self.security_TF.keyboardType = UIKeyboardTypeNumberPad;
            textField.getSecurityCode = ^{
                [self getSecurityCode];
            };
            [self.view addSubview:textField];
        }
    }
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(LONGBTN_MARGIN, CGRectGetMaxY(self.password_TF.frame) + 35, ScrW - 2 *LONGBTN_MARGIN, LONGBTN_HEIGHT);
    [self.view addSubview:loginBtn];
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:Color_Theme];
    loginBtn.layer.cornerRadius = LONGBTN_CORNER;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.adjustsImageWhenHighlighted = NO;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:LONGBTN_FONT];
    [loginBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 获取验证码
- (void)getSecurityCode{

    BOOL isPhoneNum = [GlobalTools isValidPhone:self.phone_TF.text];
    if (!isPhoneNum) {
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入正确的手机号码"];
        return;
    }
    
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    // 验证手机号是否可用
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"username":self.phone_TF.text} url:URL_EXISTPHONE successBlock:^(id requestData, NSDictionary *dataDict) {
        [self getVerificationCode:self.phone_TF.text];// mob发送验证码
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
    }];
}

#pragma mark - mob发送验证码
- (void)getVerificationCode:(NSString *)phone{
    //不带自定义模版
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86"  result:^(NSError *error) {
        
        if (!error)
        {
            [self.security_TF openCountdown];
            [MBProgressHUDTools hideHUD];
            [MBProgressHUDTools showTipMessageHudWithtitle:@"获取验证码成功！"];
        }
        else
        {
            [MBProgressHUDTools hideHUD];
            [MBProgressHUDTools showTipMessageHudWithtitle:@"获取验证码失败，请稍后重试"];
        }
    }];
}

#pragma mark - mob提交验证码
- (void)commitVerificationCode{
  
    [SMSSDK commitVerificationCode:self.security_TF.text phoneNumber:self.password_TF.text zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            [self commitUserInfo];// 提交注册信息
        }
        else
        {
            [MBProgressHUDTools hideHUD];
            [MBProgressHUDTools showTipMessageHudWithtitle:@"验证码不正确！"];
        }
    }];
}

#pragma mark - 点击注册
- (void)registerBtnClick{
    
    if(self.nickName_TF.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入昵称"];
        return;
    }else  if(self.phone_TF.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入手机号码"];
        return;
    }else if(self.security_TF.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"输入验证码"];
        return;
    }else if(self.password_TF.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请设置密码"];
        return;
    }
    
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    //验证验证码
    [self commitVerificationCode];
}
#pragma mark - 提交注册信息
- (void)commitUserInfo{
    NSDictionary *paramDict = @{@"nickname":self.nickName_TF.text,@"username":self.phone_TF.text,@"password":self.password_TF.text,@"sex":_sex};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_REGISTER successBlock:^(id requestData, NSDictionary *dataDict) {
        [MBProgressHUDTools hideHUD];
        
        EnsureAlterView *alterView = [[EnsureAlterView alloc] initWithFrame:CGRectMake(0, 0, ScrW, ScrH)];
        __weak __typeof (alterView)WeakAlterView = alterView;
        [WeakAlterView  initWithTitle:@"恭喜您！" andContent:@"注册成功！现在可以去登陆！" andBtnTitleArr:@[@"确定"] andCanDismiss:YES];
        WeakAlterView.clickButtonBlock = ^(UIButton *button) {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [WeakAlterView show];
        
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
    }];
}
#pragma mark - 性别选择
- (void)setupSelectSexView{
    self.sexView = [[SelectSexView alloc]initWithFrame:CGRectMake(0, High_NavAndStatus + 30, ScrW, 130)];
    self.sexView.selectSex = ^(Sex sex) {
        switch (sex) {
            case Sex_Boy:
                _sex = @"先生";
                break;
                
            default:
                _sex = @"女士";
                break;
        }
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
