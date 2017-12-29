//
//  CommentViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/27.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "CommentViewController.h"
#import "CustomNavView.h"
#define MAX_LIMIT_NUMS 100

@interface CommentViewController ()<UITextViewDelegate>
{
    UITextView *_contentView;
    UILabel *lable;
    UILabel *count;
}
@end

@implementation CommentViewController
- (instancetype)init{
    if (self = [super init]) {
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发表评论";
    _contentView = [UITextView new];
    _contentView.frame = CGRectMake(10, High_NavAndStatus + 10, ScrW - 20, 200 *ScaleX);
    [self.view addSubview:_contentView];
    _contentView.backgroundColor = Color_Back_Gray;
    _contentView.textAlignment = NSTextAlignmentLeft;
    _contentView.font = [UIFont systemFontOfSize:15];
    _contentView.delegate = self;
    
    // 两个lable放在textview里面
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0,5, 100,20)];
    lable.text =@"请输入内容...";
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont systemFontOfSize:15];
    [_contentView addSubview:lable];
    
    count = [[UILabel alloc]initWithFrame:CGRectMake(ScrW - 200 - 20,CGRectGetMaxY(_contentView.frame) , 200, 30)];
    count.text =[NSString stringWithFormat:@"还可以输入%d字",MAX_LIMIT_NUMS];
    count.textColor = [UIColor blackColor];
    count.font = [UIFont systemFontOfSize:13];
    count.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:count];
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
        [self submitComment];
    }
}

- (void)submitComment{
    [_contentView resignFirstResponder];
    [MBProgressHUDTools showLoadingHudWithtitle:@""];
    UserModel *model = [[InfoDBAccess sharedInstance]getInfoFromUserInfoTable:[GlobalTools getData:USER_ID]];
    NSDictionary *paramDict = @{@"username":model.nickname,@"foodId":self.foodId,@"content":_contentView.text,@"userId":model.username,@"pid":@"0"};
    [HLYNetWorkObject requestWithMethod:GET ParamDict:paramDict url:URL_SUBMITCOMMENT successBlock:^(id requestData, NSDictionary *dataDict) {
        [MBProgressHUDTools showTipMessageHudWithtitle:@"发表评论成功！"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_COMMENT_SUCCESS object:nil];
        if (@available(iOS 10.0, *)) {
            [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [self popViewController];
            }];
        } else {
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(popViewController) userInfo:nil repeats:NO];
        }
        
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        [MBProgressHUDTools showTipMessageHudWithtitle:msg];
    }];
}
#pragma mark - 返回
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_contentView resignFirstResponder];
}
@end
