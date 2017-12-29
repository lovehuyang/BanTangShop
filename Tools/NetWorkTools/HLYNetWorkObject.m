//
//  HZYNetWorkObject.m
//  BanTangShop
//
//  Created by tzsoft on 2017/12/18.
//  Copyright © 2017年 HLY. All rights reserved.
//

#import "HLYNetWorkObject.h"

@implementation HLYNetWorkObject
/**
 统一请求接口
 
 @param method 请求方式
 @param paramDict 参数字典
 @param url 请求地址
 @param successBlock 成功回调
 @param failureBlock 失败的回调
 */
+(void)requestWithMethod:(RequestMethod)method ParamDict:(NSDictionary *)paramDict url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    // 判断是否有网络链接
    if(![[self alloc] isConnectionAvailable])
    {
        failureBlock(0,@"您已断开网络链接！");
        return;
    }
    
    // 请求地址
    NSString * urlString = [NSString stringWithFormat:@"%@%@",URL_BASEIP,url];
    // 请求类
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    if(method == POST){
        [manager POST:urlString parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self dealwithreturnDataWithRequestData:responseObject successBlock:successBlock faileBlock:failureBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error.code ,@"网络请求失败，请稍后重试");
        }];
        
    }else{
        
        [manager GET:urlString parameters:paramDict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 统一处理请求数据
            [self dealwithreturnDataWithRequestData:responseObject successBlock:successBlock faileBlock:failureBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error.code,@"网络请求失败，请稍后重试");
        }];
    }
}

/**
 更新用户头像
 
 @param image 图片
 @param url 地址
 @param paramDict 参数
 @param successBlock 成功
 @param failureBlock 失败
 */
+ (void)updateHeadImage:(UIImage *)image url:(NSString *)url paramDict:(NSDictionary *)paramDict  successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    // 判断是否有网络链接
    if(![[self alloc] isConnectionAvailable])
    {
        failureBlock(0,@"您已断开网络链接！");
        return;
    }
    
    // 请求地址
    NSString * urlString = [NSString stringWithFormat:@"%@%@",URL_BASEIP,url];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [manager POST:urlString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data =  UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        //设置时区,这个对于时间的处理有时很重要
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *datenow = [NSDate date];//现在时间
        
        //时间转时间戳的方法:
        NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
        NSString *ts = [NSString stringWithFormat:@"%ld",(long)timeSp];//时间戳的值
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",ts];
        [formData appendPartWithFileData:data name:@"img" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        DLog(@"%.2lf%%", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        DLog(@"请求成功：%@",responseObject);
         [self dealwithreturnDataWithRequestData:responseObject successBlock:successBlock faileBlock:failureBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        DLog(@"请求失败：%@",error);
        failureBlock(error.code,@"网络错误，请稍后重试");
    }];
}

/**
 返回的数据统一处理
 */

+ (void)dealwithreturnDataWithRequestData:(id)requestData successBlock:(SuccessBlock)success faileBlock:(FailureBlock)failure{
    
    //先判断是不是字典类型如果是,则添加通用处理方法,处理字典最外层数据基本的成功失败
    if ([requestData isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *requestDic =(NSDictionary *)requestData;
        BOOL state = [requestData[@"ret"] boolValue];//APP 接口约定的返回数据成功或者失败的标志
        NSString *errMsg = requestData[@"msg"];
        
        if (state){
            //如果服务器返回的状态是成功则返回需要处理的数据,除去最外层的状态字段,比如requestDatat[@"result"]
            success(requestData,requestDic[@"datas"]);
        }
        else{
            //如果服务器返回的状态是失败,则告诉调用者返回失败,
            failure(0,errMsg);
        }
    }
    else{//更新,添加了成功回调的参数,如果非字典类型,则返回的字典为 nil
        
        success(requestData,nil);
    }
    
}

+ (BOOL)isConnection
{
    return [[self alloc] isConnectionAvailable];
}
/**
 *  网络判断
 *
 *  @return 是否可以联网
 */
- (BOOL)isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:                      //无网络(无法判断内外网)
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:                  //WIFI
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:                  //流量
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}
@end
