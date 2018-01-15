//
//  ForgetViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2018/1/15.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import "ForgetViewController.h"
#import "CustomNavView.h"
#import "RegisterTextField.h"
#import "RegisterTextField2.h"
#import <SMS_SDK/SMSSDK.h>

@interface ForgetViewController ()
{
    RegisterTextField *_phone_TF;
    RegisterTextField *_newPWD_TF1;// 新密码
    RegisterTextField *_newPWD_TF2;// 确认密码
    RegisterTextField2 *_code_TF;
}
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];// 导航栏
    [self createTextField];
}
#pragma mark - 文本框
- (void)createTextField{
    NSArray *titleArr = @[@"手机号:",@"验证码:",@"新密码:",@"确认密码:"];
    NSArray *placeholderArr = @[@"请输入您的手机号",@"请输入手机验证码",@"请输入新密码",@"请再次输入密码"];
    CGFloat TextField_H = 35;
    for (int i = 0; i < titleArr.count; i ++) {
        if (i!=1) {
            RegisterTextField *textField = [[RegisterTextField alloc]initWithFrame:CGRectMake(20, High_NavAndStatus + 10 + (TextField_H + 10) *i, ScrW - 40, TextField_H) title:titleArr[i] placeholder:placeholderArr[i]];
            UILabel *leftLab = textField.leftLab;
            leftLab.textAlignment = NSTextAlignmentLeft;
            CGRect frame = leftLab.frame;
            frame.size.width = 65;
            leftLab.frame = frame;
            if(i == 0){
                _phone_TF = textField;
            }else if(i == 2){
                _newPWD_TF1 = textField;
            }else if (i == 3){
                _newPWD_TF2 = textField;
            }
            
            [self.view addSubview:textField];
            
        }else{
            RegisterTextField2 *textField = [[RegisterTextField2 alloc]initWithFrame:CGRectMake(20, High_NavAndStatus +10 + (TextField_H + 10) *i, ScrW - 40, TextField_H) title:titleArr[i] placeholder:placeholderArr[i]];
            _code_TF = textField;
            textField.getSecurityCode = ^{
                [self getSecurityCode];
            };
            [self.view addSubview:textField];
        }
    }
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(LONGBTN_MARGIN, CGRectGetMaxY(_newPWD_TF2.frame) + 35, ScrW - 2 *LONGBTN_MARGIN, LONGBTN_HEIGHT);
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:Color_Theme];
    nextBtn.layer.cornerRadius = LONGBTN_CORNER;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.adjustsImageWhenHighlighted = NO;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:LONGBTN_FONT];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 获取验证码
- (void)getSecurityCode{
    
    BOOL isPhoneNum = [GlobalTools isValidPhone:_phone_TF.text];
    if (!isPhoneNum) {
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入正确的手机号码"];
        return;
    }
    
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    // 验证手机号是否可用(手机号不可用时才可注册)
    [HLYNetWorkObject requestWithMethod:GET ParamDict:@{@"username":_phone_TF.text} url:URL_EXISTPHONE successBlock:^(id requestData, NSDictionary *dataDict) {
        BOOL isAvailable = [(NSString *)dataDict boolValue];
        if (!isAvailable) {
            [self getVerificationCode:_phone_TF.text];// mob发送验证码
        }else{
            [MBProgressHUDTools showTipMessageHudWithtitle:requestData[@"msg"]];
        }
        
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
    }];
}

#pragma mark - mob发送验证码
- (void)getVerificationCode:(NSString *)phone{
    //不带自定义模版
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86"  result:^(NSError *error) {
        
        if (!error)
        {
            [_code_TF openCountdown];
            [MBProgressHUDTools showTipMessageHudWithtitle:@"获取验证码成功！"];
        }
        else
        {
            [MBProgressHUDTools showTipMessageHudWithtitle:@"获取验证码失败，请稍后重试"];
        }
    }];
}

#pragma mark - mob提交验证码
- (void)commitVerificationCode{
    
    [SMSSDK commitVerificationCode:_code_TF.text phoneNumber:_phone_TF.text zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            [self checkoutPWD];// 验证码正确，验证两次密码是否一致
        }
        else
        {
            [MBProgressHUDTools showTipMessageHudWithtitle:@"验证码不正确！"];
        }
    }];
}

#pragma mark - 验证密码一致性
- (void)checkoutPWD{
    if ([_newPWD_TF1.text isEqualToString:_newPWD_TF2.text]) {
        [MBProgressHUDTools showLoadingHudWithtitle:@""];
        NSDictionary *paramDict = @{@"username":_phone_TF.text,@"password":_newPWD_TF1.text};
        [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_UPDATEUSERPASSORD successBlock:^(id requestData, NSDictionary *dataDict) {
            DLog(@"");
            [MBProgressHUDTools hideHUD];
            [MBProgressHUDTools showSuccessHudWithtitle:@""];
        } failureBlock:^(NSInteger errCode, NSString *msg) {
            DLog(@"");
            [MBProgressHUDTools hideHUD];
            [MBProgressHUDTools showWarningHudWithtitle:msg];
        }];
    }else{
        [MBProgressHUDTools showWarningHudWithtitle:@"两次密码不一致，请重新输入！"];
    }
}
#pragma mark - 确定
- (void)nextBtnClick{
    if (_phone_TF.text.length > 0 && _code_TF.text.length > 0 && _newPWD_TF1.text.length > 0 && _newPWD_TF2.text.length > 0) {
        [self commitVerificationCode];// 验证验证码的正确性
    
    }else if(_phone_TF.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入手机号"];
    }else if(_code_TF.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入验证码"];
    }else if(_newPWD_TF1.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输新密码"];
    }else if(_newPWD_TF2.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请再次输入密码"];
    }
}

#pragma mark - 导航栏
- (void)setupNavBar{
    
    CustomNavView *nav = [[CustomNavView alloc]initWithFrame:CGRectMake(0, 0, ScrW, High_NavAndStatus) title:@"忘记密码"];
    nav.returnEvent = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:nav];
}

@end
