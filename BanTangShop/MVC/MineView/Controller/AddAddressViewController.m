//
//  AddAddressViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/29.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "AddAddressViewController.h"
#import "RegisterTextField.h"
#import "BRPickerView.h"

@interface AddAddressViewController ()
{
    BOOL setDefault;// 设为默认
}
@property (nonatomic ,strong) RegisterTextField *nameTF;// 收货人姓名
@property (nonatomic ,strong) RegisterTextField *phoneTF;// 联系电话
@property (nonatomic ,strong) RegisterTextField *districtTF;// 省市区
@property (nonatomic ,strong) RegisterTextField *addressTF;// 详细地址
@property (nonatomic ,strong) RegisterTextField *defaultTF;// 设为默认

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    setDefault = YES;
    self.title = @"添加收货地址";
    [self createTextField];
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 文本框
- (void)createTextField{
    NSArray *titleArr = @[@"收货人姓名",@"联系电话:",@"省市区",@"详细地址",@"设为默认"];
    NSArray *placeholderArr = @[@"收货人姓名",@"手机号",@"点击选择省市区",@"详细地址",@""];
    CGFloat TextField_H = 35;
    for (int i = 0; i < titleArr.count; i ++) {
        
        RegisterTextField *textField = [[RegisterTextField alloc]initWithFrame:CGRectMake(10,  High_NavAndStatus + 5 + (TextField_H + 10) *i, ScrW - 20, TextField_H) title:titleArr[i] placeholder:placeholderArr[i]];
        textField.leftLab.textAlignment = NSTextAlignmentLeft;
        CGRect frame = textField.leftLab.frame;
        frame.size.width = 80;
        textField.leftLab.frame = frame;
        textField.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:textField];
        switch (i) {
            case 0:
                self.nameTF = textField;
                break;
            case 1:
                self.phoneTF = textField;
                self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 2:
            {
                self.districtTF = textField;
                UIView *shelterView = [UIView new];
                shelterView.frame = CGRectMake(0, 0, CGRectGetWidth(textField.frame),TextField_H );
                [self.districtTF addSubview:shelterView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectArea)];
                [shelterView addGestureRecognizer:tap];
            }
                break;
            case 3:
                self.addressTF = textField;
                break;
            case 4:
            {
                self.defaultTF = textField;
                UIView *shelterView = [UIView new];
                shelterView.frame = CGRectMake(0, 0, CGRectGetWidth(textField.frame),TextField_H );
                [self.defaultTF addSubview:shelterView];
                UIButton *defaultBtn = [UIButton new];
                defaultBtn.frame = CGRectMake(CGRectGetWidth(self.defaultTF.frame) - 80, TextField_H/2 - 30/2, 80, 30);
                [shelterView addSubview:defaultBtn];
                [defaultBtn setImage:[UIImage imageNamed:@"bt_weixuan"] forState:UIControlStateNormal];
                [defaultBtn setImage:[UIImage imageNamed:@"bt_xuanzhong"] forState:UIControlStateSelected];
                [defaultBtn setTitle:@" 默认" forState:UIControlStateNormal];
                [defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                defaultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [defaultBtn addTarget:self action:@selector(setDefaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                defaultBtn.selected = setDefault;
            }
                break;
                
            default:
                break;
        }
    }
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(LONGBTN_MARGIN, CGRectGetMaxY(self.defaultTF.frame) + 35, ScrW - 2 *LONGBTN_MARGIN, LONGBTN_HEIGHT);
    [self.view addSubview:saveBtn];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:Color_Theme];
    saveBtn.layer.cornerRadius = LONGBTN_CORNER;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.adjustsImageWhenHighlighted = NO;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:LONGBTN_FONT];
    [saveBtn addTarget:self action:@selector(saveBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设为默认
- (void)setDefaultBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    setDefault = btn.selected;
}

#pragma mark - 保存按钮
- (void)saveBtnBtnClick{
    if (!(self.nameTF.text.length > 0 && self.nameTF.text.length <=20)) {
        [MBProgressHUDTools showTipMessageHudWithtitle:@"收货人姓名长度为1~20位"];
    }else if (![GlobalTools isValidPhone:self.phoneTF.text]){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入正确的手机号码！"];
    }else if (self.districtTF.text.length == 0){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请选择省市区信息！"];
    }else if (!(self.addressTF.text.length > 0 && self.addressTF.text.length <=50)){
        [MBProgressHUDTools showTipMessageHudWithtitle:@"详细地址有效长度为1~50位！"];
    }else{
        [self addAddress];// 添加收货地址
    }
}

#pragma mark - 添加收货地址
- (void)addAddress{
    
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    NSDictionary *paramDict = @{@"username":[GlobalTools getData:USER_PHONE],@"name":self.nameTF.text,@"phone":self.phoneTF.text,@"district":self.districtTF.text,@"address":self.addressTF.text,@"isDefault":setDefault?@"1":@"0"};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_ADDADDRESS successBlock:^(id requestData, NSDictionary *dataDict) {
        NSString *datas = [NSString stringWithFormat:@"%@",dataDict];
        if ([datas isEqualToString:@"1"]) {
            if (@available(iOS 10.0, *)) {
                [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                    [self postNoti];
                }];
            } else {
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(postNoti) userInfo:nil repeats:NO];
            }
        }
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showSuccessHudWithtitle:requestData[@"msg"]];
        DLog(@"");
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showSuccessHudWithtitle:msg];
    }];
}

#pragma mark - 选择地区
- (void)selectArea{
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.addressTF resignFirstResponder];

    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@14, @0, @4] isAutoSelect:NO resultBlock:^(NSArray *selectAddressArr) {
        DLog(@"selectAddressArr:%@",selectAddressArr);
        self.districtTF.text = [NSString stringWithFormat:@"%@%@%@",selectAddressArr[0],selectAddressArr[1],selectAddressArr[2]];
    }];
}

#pragma mark - 发送通知
- (void)postNoti{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADDRADDRESS object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
