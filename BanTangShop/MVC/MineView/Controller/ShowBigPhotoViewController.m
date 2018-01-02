//
//  ShowBigPhotoViewController.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/29.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "ShowBigPhotoViewController.h"
#import "GZActionSheet.h"
#import "PureCamera.h"
#import "TOCropViewController.h"
#import <Photos/Photos.h>

@interface ShowBigPhotoViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong)UIImageView *imageView;
@end

@implementation ShowBigPhotoViewController

- (instancetype)init{
    if (self = [super init]) {
        UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClick)];
        self.navigationItem.rightBarButtonItem = navItem;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"个人头像";
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, High_NavAndStatus, ScrW, ScrH - High_NavAndStatus)];
    [self.view addSubview:self.scrollView];
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 2.5;
    self.scrollView.delegate = self;
    
    //在view上添加一个ImageView
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_BASEIP,_model.avatar]] placeholderImage:[UIImage imageNamed:@"img_zhanweifu"]];
    image.frame = CGRectMake(0, 0, ScrW, ScrW);
    self.imageView = image;
    self.imageView.center = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2 - High_NavAndStatus);
    [self.scrollView addSubview:self.imageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect frame = self.imageView.frame;
    frame.origin.y = (self.scrollView.frame.size.height - self.imageView.frame.size.height) > 0 ? (self.scrollView.frame.size.height - self.imageView.frame.size.height) * 0.5 - High_NavAndStatus: 0;
    frame.origin.x = (self.scrollView.frame.size.width - self.imageView.frame.size.width) > 0 ? (self.scrollView.frame.size.width - self.imageView.frame.size.width) * 0.5 : 0;
    self.imageView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width + 30, self.imageView.frame.size.height + 30);
}

#pragma mark - 导航栏点击事件
- (void)navBtnClick{
    
    NSArray *operateArr = nil;
    // 判断是否支持相机
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(cameraAvailable){
        operateArr = @[@"保存图片",@"从手机相册选择",@"拍照"];
    }else{
        operateArr = @[@"保存图片",@"从手机相册选择"];
    }
    
    GZActionSheet *sheet = [[GZActionSheet alloc]initWithTitleArray:operateArr andShowCancel:YES];

    __weak typeof(self) weakSelf = self;
    sheet.ClickIndex = ^(NSInteger index){
        
        NSUInteger sourceType = 0;
        if (cameraAvailable) {// 相机可用
            switch (index)
            {
                case 3:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                
                case 1:
                    DLog(@"保存相册");
                    [self loadImageFinished:self.imageView.image];
                    return;
                case 0:
                    DLog(@"取消");
                    return;
            }
        }else{
            switch (index)
            {
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 1:
                    DLog(@"保存相册");
                    [self loadImageFinished:self.imageView.image];
                    return;
                case 0:
                    DLog(@"取消");
                    return;
            }
        }
        
        [weakSelf photoOperate:sourceType];// 相机的操作
    };
    [self.view.window addSubview:sheet];
}

- (void)photoOperate:(NSInteger)sourceType{
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            PureCamera *homec = [[PureCamera alloc] init];
            __weak typeof(self) myself = self;
            homec.fininshcapture = ^(UIImage *ss) {
                [self uploadHeadImage:ss];
            };
            [myself presentViewController:homec animated:NO completion:^{}];
        }else{
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = NO;
            picker.delegate   = self;
            picker.sourceType = sourceType;
            picker.navigationBarHidden = NO;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
    cropController.delegate = self;
    [picker presentViewController:cropController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectZero completion:^{
        
        [self uploadHeadImage:image];
    }];
}

#pragma mark - 上传图片
- (void)uploadHeadImage:(UIImage *)image{
    [MBProgressHUDTools showLoadingHudWithtitle:@"请稍后"];
    
    [HLYNetWorkObject updateHeadImage:image url:URL_UPDATEHEADIMAGE paramDict:@{@"username":[GlobalTools getData:USER_PHONE]} successBlock:^(id requestData, NSDictionary *dataDict) {
        DLog(@"");
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showSuccessHudWithtitle:@"修改成功！"];
        self.imageView.image = image;
    } failureBlock:^(NSInteger errCode, NSString *msg) {
        DLog(@"");
        [MBProgressHUDTools hideHUD];
        [MBProgressHUDTools showWarningHudWithtitle:msg];
    }];
}

#pragma mark - 图片保存至本地
/**
 *  将图片添加到本地相册
 */

- (void)loadImageFinished:(UIImage *)image
{
    __weak typeof (self)weakSelf = self;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            
        }else{

        }
    }];
}


@end
