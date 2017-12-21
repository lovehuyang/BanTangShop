//
//  LoginViewController.m
//  GitHudStudy
//
//  Created by tzsoft on 2017/12/7.
//  Copyright © 2017年 TZSoft. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "SetupTools.h"
#import "systemTabbar.h"
#import "LoginTextField.h"

@interface LoginViewController ()
{
    UITextField * _userPhone;
    UITextField * _passWord;
    UIButton *_forgetPwdBtn;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    UIImageView *logoImgView = [UIImageView new];
    logoImgView.frame = CGRectMake(0, 0, 60 *ScaleX, 60 *ScaleX);
    logoImgView.center = CGPointMake(self.view.center.x,  High_NavAndStatus + 30 *ScaleX);
    [self.view addSubview:logoImgView];
    logoImgView.layer.cornerRadius = 3;
    logoImgView.layer.masksToBounds = YES;
    logoImgView.image = [UIImage imageNamed:@"logo_icon"];
    
    // 输入框左部图片数组及占位文本数组
    NSArray *placeHolder_Array = @[@"请输入手机号",@"请输入密码"];
    NSArray *placeImage_Array = @[@"dl_icon_phone",@"dl_icon_password"];
    // 输入框的位置及宽高
    for(int i=0; i<2; i++){
        
        LoginTextField *tf = [[LoginTextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(logoImgView.frame) + 40 + 60 *i, ScrW - 60, 40) placeholder:placeHolder_Array[i] img:placeImage_Array[i]];
        tf.font = [UIFont systemFontOfSize:15];
        if(i == 0){
            _userPhone = tf;
            _userPhone.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            _passWord = tf;
            _passWord.secureTextEntry = YES;
        }
        [self.view addSubview:tf];
    }
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(30, CGRectGetMaxY(_passWord.frame) + 10, 80, 30);
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerBtn setTitleColor:Color_Theme forState:UIControlStateNormal];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    registerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    registerBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(ScrW - 30 - 80, CGRectGetMaxY(_passWord.frame) + 10, 80, 30);
    forgetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:Color_Theme forState:UIControlStateNormal];
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:forgetBtn];
    
    // 创建"系统登录"按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(LONGBTN_MARGIN, CGRectGetMaxY(registerBtn.frame) + 35, ScrW - 2 *LONGBTN_MARGIN, LONGBTN_HEIGHT);
    [self.view addSubview:loginBtn];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:Color_Theme];
    loginBtn.layer.cornerRadius = LONGBTN_CORNER;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.adjustsImageWhenHighlighted = NO;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:LONGBTN_FONT];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, High_Status +5 , 30, 30);
    backBtn.layer.cornerRadius = 15;
    backBtn.backgroundColor = [UIColor lightGrayColor];
    backBtn.layer.masksToBounds = YES;
    [backBtn setImage:[UIImage imageNamed:@"dismiss_icon"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnCkick) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 登录
- (void)loginBtnClick{
    [_passWord resignFirstResponder];
    [_userPhone resignFirstResponder];
    if (_userPhone.text.length == 0) {
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入手机号"];
        return;
    }else if(_passWord.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输密码"];
        return;
    }
    
    [MBProgressHUDTools showLoadingHudWithtitle:@"正在登录..."];
    NSDictionary *paramDict = @{@"username":_userPhone.text,@"password":_passWord.text};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_LOGINUSER successBlock:^(id requestData, NSDictionary *dataDict) {
        UserModel *model = [UserModel createModelWithDic:dataDict];
        [[InfoDBAccess sharedInstance] databaseUserInfoTable:model];
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showTipMessageHudWithtitle:@"登录成功！"];
        [GlobalTools saveData:model.user_Id key:USER_ID];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN object:nil];
        [self backBtnCkick];
        
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
    }];
}
#pragma mark - 返回
- (void)backBtnCkick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 注册
- (void)registerBtnClick{
    RegisterViewController *rvc = [[RegisterViewController alloc]init];
    [self presentViewController:rvc animated:YES completion:nil];
}
#pragma mark - 生命周期函数
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
