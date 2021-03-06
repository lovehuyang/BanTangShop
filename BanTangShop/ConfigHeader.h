//
//  ConfigHeader.h
//  BanTangShop
//
//  Created by tzsoft on 2017/12/16.
//  Copyright © 2017年 HLY. All rights reserved.
//

#ifndef ConfigHeader_h
#define ConfigHeader_h

#define URL_BASEIP @"http://101.132.191.36"

#define URL_EXISTPHONE @"/shop/existphone" //手机号是否可用
#define URL_REGISTER @"/shop/registUser"//用户注册
#define URL_LOGINUSER @"/shop/loginuser"// 登录
#define URL_UPDATEUSERINFO @"/shop/updateUserInfo"// 修改用户基本信息
#define URL_UPDATEHEADIMAGE @"/shop/updateHeadImage"// 修改用户头像
#define URL_UPDATEUSERPASSORD @"/shop/updateUserPassword"//修改用户密码
#define URL_GETBANNERS @"/shop/getbanners"//获取banner轮播图
#define URL_GETFOODCATAGORY @"/shop/getFoodCatagory"// 获取食品类别
#define URL_GETFOODFLAVOUR @"/shop/getFoodFlavour"// 获取食品口味
#define URL_GETFOODBRAND @"/shop/getFoodBrand"// 获取食品品牌
#define URL_GETRECOMMENDS @"/shop/getrecommends"//获取推荐食品
#define URL_GETSELLTOPFOODSUMMARY @"/shop/getSellTopFoodSummary"//获取销售排行食品列表
#define URL_GETFOODLISTPAGE @"/shop/getFoodListPage"// 分页获取食品列表(多条件)
#define URL_GETLIKEFOOD @"/shop/getLikeFood"// 获取收藏食品列表(未分页)
#define URL_GETFOODDETAILBYID @"/shop/getFoodDetailById"//获取食品详情(通过ID)
#define URL_GETFOODIMAGEBYID @"/shop/getFoodImagesById"// 获取食品轮播图
#define URL_ISLIKEFOOD @"/shop/isLikeFood"// 食品是否已收藏
#define URL_LIKEFOOD @"/shop/likeFood"// 收藏食品
#define URL_UNLIKEFOOD @"/shop/unLikeFood" //取消收藏
#define URL_GETFOODPACKAGE @"/shop/getFoodPackage"// 获取食品包装单位
#define URL_GETFOODUNIT @"/shop/getFoodUnit"// 获取食品单位
#define URL_GETSHOPCONTRACT @"/shop/getShopContacts"// 获取店铺联系人信息
#define URL_GETNEWCOMMENTS @"/shop/getNewComments"// 获取最新评论
#define URL_SUBMITCOMMENT @"/shop/submitComment"// 提交评论
#define URL_GETCOMMENTLIST @"/shop/getCommentsByPages"// 分页获取最新评论
#define URL_GETADDRESS @"/shop/getAddress" //获取收货地址
#define URL_SETDEFAULTADDRESS @"/shop/setDefaultAddress"// 设置默认地址
#define URL_ADDADDRESS @"/shop/addAddress"// 添加收货地址
#define URL_DELADDRESS @"/shop/delAddress"// 删除收货地址
#define URL_ADDFEEDBACK @"/shop/addFeedback"// 提交意见反馈
#define URL_ADDBUYCART @"/shop/addBuyCart"//加入购物车
#define URL_GETCARLIST @"/shop/getCartList"//获取购车列表
#define URL_DELCARTLIST @"/shop/delCartList"//删除购物车

// 常用颜色
#define Color_Theme HXYGetColor(@"#BD0220")// 主题色
#define Color_Back_Gray HXYGetColor(@"#EAEAEA")// 背景灰色
#define Color_Text_Gray HXYGetColor(@"#7F7F7F")// 字体灰色


// 常用的键值
#define USER_ID @"user_id"// 用户ID
#define USER_PHONE @"user_phone"// 用户登录手机号
#define USER_PASSWORD @"user_password" // 用户密码

// 通知
#define NOTIFICATION_LOGIN @"Notification_Login"// 登录成功
#define NOTIFICATION_EXIT @"Notification_Exit"// 退出账号
#define NOTIFICATION_STOP_COUNT_DOWN @"Notification_Stop_CountDown"// 停止计时
#define NOTIFICATION_COMMENT_SUCCESS @"Notification_Comment_Success"// 发表评论成功
#define NOTIFICATION_ADDRADDRESS @"Notification_AddAddress"// 添加收货地址


#endif /* ConfigHeader_h */
