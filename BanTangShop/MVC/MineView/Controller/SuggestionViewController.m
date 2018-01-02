//
//  SuggestionViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2018/1/2.
//  Copyright © 2018年 HLY. All rights reserved.
//

#import "SuggestionViewController.h"
#import "UIImage+HLY.h"
#define MAX_LIMIT_NUMS 200

@interface SuggestionViewController ()<UITextViewDelegate>
{
    UITextView *_contentView;
    UILabel *lable;
    UILabel *count;
    UIView *backView;
    UITextField *contactTextField;// 联系方式文本框
    NSString *contactType;// 联系方式
}
@end

@implementation SuggestionViewController
- (instancetype)init{
    if (self = [super init]) {
        self.title = @"意见反馈";
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    contactType = @"手机";
    [self createUI];
}

- (void)createUI{
    UILabel *titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    titleLab.sd_layout
    .leftSpaceToView(self.view, 20)
    .topSpaceToView(self.view, High_NavAndStatus + 10)
    .rightSpaceToView(self.view, 20)
    .heightIs(30);
    titleLab.text = @"问题描述:";
    
    _contentView = [UITextView new];
    _contentView.frame = CGRectMake(20, High_NavAndStatus + 50, ScrW - 40, 150 *ScaleX);
    [self.view addSubview:_contentView];
    _contentView.backgroundColor = Color_Back_Gray;
    _contentView.textAlignment = NSTextAlignmentLeft;
    _contentView.font = [UIFont systemFontOfSize:15];
    _contentView.delegate = self;
    
    // 两个lable放在textview里面
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0,5, 250,20)];
    lable.text =@"您的反馈将帮助我们更快的成长...";
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont systemFontOfSize:15];
    [_contentView addSubview:lable];
    
    count = [[UILabel alloc]initWithFrame:CGRectMake(ScrW - 200 - 20,CGRectGetMaxY(_contentView.frame) , 200, 30)];
    count.text =[NSString stringWithFormat:@"还可以输入%d字",MAX_LIMIT_NUMS];
    count.textColor = [UIColor blackColor];
    count.font = [UIFont systemFontOfSize:13];
    count.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:count];
    
    UILabel *Contact = [UILabel new];
    [self.view addSubview:Contact];
    Contact.sd_layout
    .leftEqualToView(titleLab)
    .topSpaceToView(count, 10)
    .autoWidthRatio(0)
    .heightIs(25);
    Contact.text = @"联系方式:";
    [Contact setSingleLineAutoResizeWithMaxWidth:150];
    Contact.backgroundColor = [UIColor whiteColor];
    
    backView = [UIView new];
    [self.view addSubview:backView];
    backView.sd_layout
    .leftSpaceToView(Contact, 0)
    .topEqualToView(Contact)
    .bottomEqualToView(Contact)
    .rightEqualToView(_contentView);
    backView.backgroundColor = [UIColor whiteColor];
    
    NSArray *btn_titleArr = @[@"手机",@"微信",@"QQ",@"邮箱"];
    CGFloat BTN_W = 45;
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton new];
        [backView addSubview:btn];
        btn.sd_layout
        .leftSpaceToView(backView, 20 +  20 *i + BTN_W *i)
        .topEqualToView(backView)
        .bottomEqualToView(backView)
        .widthIs(BTN_W);
        [btn setBackgroundImage:[UIImage imageWithColor:Color_Theme] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 2;
        btn.layer.masksToBounds = YES;
        [btn setTitle:btn_titleArr[i] forState:UIControlStateNormal];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(contractBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
    contactTextField = [UITextField new];
    [self.view addSubview:contactTextField];
    contactTextField.sd_layout
    .leftEqualToView(_contentView)
    .topSpaceToView(Contact, 10)
    .rightEqualToView(_contentView)
    .heightIs(30 *ScaleX);
    contactTextField.backgroundColor = _contentView.backgroundColor;
    contactTextField.layer.cornerRadius = _contentView.layer.cornerRadius;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0)
    {
        lable.hidden = YES;
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0){
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    count.text = [NSString stringWithFormat:@"还可输入%ld字",MAX(0,MAX_LIMIT_NUMS - existTextNum)];
}
#pragma mark - 提交
- (void)submitBtnClick{
    
    if (_contentView.text.length <5) {
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入至少5个字"];
    }else{
        
    }
}

#pragma mark - 提交

- (void)navBtnClick{
    if (_contentView.text.length >= 5) {
        
        [MBProgressHUDTools showLoadingHudWithtitle:@""];
        NSDictionary *paramDict = @{@"name":[GlobalTools getData:USER_PHONE],@"content":_contentView.text,@"contactWay":contactType,@"contactNo":contactTextField.text};
        [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_ADDFEEDBACK successBlock:^(id requestData, NSDictionary *dataDict) {
            NSString *dataStr = [NSString stringWithFormat:@"%@",dataDict];
            [MBProgressHUDTools hideHUD];
            if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUDTools showSuccessHudWithtitle:requestData[@"msg"]];
                
                if (@available(iOS 10.0, *)) {
                    [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                        [self popToView];
                    }];
                } else {
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popToView) userInfo:nil repeats:NO];
                }
                
            }else{
                [MBProgressHUDTools showSuccessHudWithtitle:requestData[@"msg"]];
            }
            
            
        } failureBlock:^(NSInteger errCode, NSString *msg) {
            [MBProgressHUDTools hideHUD];
            [MBProgressHUDTools showSuccessHudWithtitle:msg];
        }];
        
    }else{
        [MBProgressHUDTools showTipMessageHudWithtitle:@"请输入至少5个字"];
    }
}

#pragma mark - 联系方式选择
- (void)contractBtnClick:(UIButton *)btn{
    for (UIButton *subBtn in backView.subviews) {
        if (btn.tag == subBtn.tag) {
            subBtn.selected = YES;
        }else{
            subBtn.selected = NO;
        }
    }
    switch (btn.tag - 10) {
        case 0:
            contactType = @"手机";
            break;
        case 1:
            contactType = @"微信";
            break;
        case 2:
            contactType = @"QQ";
            break;
        case 3:
            contactType = @"邮箱";
            break;
            
        default:
            break;
    }
}

- (void)popToView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
