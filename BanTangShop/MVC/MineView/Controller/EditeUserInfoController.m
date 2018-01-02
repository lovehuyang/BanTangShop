//
//  EditeUserInfoController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/28.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "EditeUserInfoController.h"
#import "RegisterTextField.h"

@interface EditeUserInfoController ()
{
    RegisterTextField *textField;
}
@end

@implementation EditeUserInfoController
- (instancetype)init{
    if (self = [super init]) {
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.title = [NSString stringWithFormat:@"设置%@",self.titleStr];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)setupUI{
    textField = [[RegisterTextField alloc]initWithFrame:CGRectMake(10, High_NavAndStatus + 10, ScrW - 20, 40 *ScaleX) title:self.titleStr placeholder:[self contentPlaceholderWithTitle:self.titleStr]];
    textField.text = [self contentTextWithTitle:self.titleStr];
    [self.view addSubview:textField];
}


#pragma mark - 设置文本框的placehohlder
- (NSString *)contentPlaceholderWithTitle:(NSString *)title{
    
    if ([title isEqualToString:@"昵称"]) {
        return  _model.nickname;
    }else if ([title isEqualToString:@"姓名"]) {
        return  [self setContentPlaceholder:_model.realname];
    }else if ([title isEqualToString:@"手机号"]) {
        return  [self setContentPlaceholder:_model.phone] ;
    }else if ([title isEqualToString:@"微信号"]) {
        return [self setContentPlaceholder:_model.wx];
    }else if ([title isEqualToString:@"QQ"]) 
    {
        return  [self setContentPlaceholder:_model.qq];
    }
    return @"";
}

- (NSString *)setContentPlaceholder:(NSString *)content{
    if (content == nil || content.length == 0) {
        return [NSString stringWithFormat:@"请设置%@",self.titleStr];
    }else{
        return content;
    }
}

#pragma mark - 设置文本框的textr
- (NSString *)contentTextWithTitle:(NSString *)title{
    
    if ([title isEqualToString:@"昵称"]) {
        return  _model.nickname;
    }else if ([title isEqualToString:@"姓名"]) {
        return  _model.realname;
    }else if ([title isEqualToString:@"手机号"]) {
        return  _model.phone ;
    }else if ([title isEqualToString:@"微信号"]) {
        return _model.wx;
    }else if ([title isEqualToString:@"QQ"])
    {
        return  _model.qq;
    }
    return @"";
}

- (void)navBtnClick{

    if(textField.text.length > 0){
        [self changeValue];// 修改模型的值
    }else{
        [MBProgressHUDTools showTipMessageHudWithtitle:@"信息不能为空"];
    }
}
- (void)changeValue{
    if ([self.titleStr isEqualToString:@"昵称"]) {
        self.model.nickname = textField.text;
    }else if ([self.titleStr isEqualToString:@"姓名"]) {
        self.model.realname = textField.text;
    }else if ([self.titleStr isEqualToString:@"手机号"]) {
        self.model.phone = textField.text ;
    }else if ([self.titleStr isEqualToString:@"微信号"]) {
        self.model.wx = textField.text;
    }else if ([self.titleStr isEqualToString:@"QQ"])
    {
        self.model.qq = textField.text;
    }
    [self updateUserInfo];
}
#pragma mark - 更新用户信息
- (void)updateUserInfo{
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    NSDictionary *paramDict = @{@"username":self.model.username,@"nickname":self.model.nickname,@"realname":self.model.realname,@"sex":self.model.sex,@"phone":self.model.phone,@"wx":self.model.wx,@"qq":self.model.qq};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_UPDATEUSERINFO successBlock:^(id requestData, NSDictionary *dataDict) {
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
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
