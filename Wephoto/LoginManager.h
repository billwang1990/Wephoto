//
//  LoginManager.h
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import "HttpEngine.h"
#import "AppDelegate.h"
#import "time.h"
#import "JSON.h"
#import "head.h"

@interface LoginManager : NSObject <ASIHTTPRespondDelegate>
{
    NSTimer    *m_tokenTimer;        //token保持计时，每十分钟保持一次
    BOOL       refreshToken;         //YES 表示是因为token保持失败，重新刷新token，此时不需要发送通知 NO 表示是登录获取token，此时要发送通知，告知登录成功的相关信息
    
    NSString   *m_loginUserName;      //用户名
    NSString   *m_loginPassword;      //用户密码
    
    NSInteger  m_error_code;         //请求返回的error_code，用于判断登录是否成功
    NSString   *m_err_msg;           //请求返回的error_msg
    NSString   *m_token;             //本次登录分配的token信息，由服务器分配
    NSString   *m_loninID;           //请求返回的ID，用于注销登录
    long       m_time;               //请求返回的time
    NSString   *m_is_active;         //请求返回的is_active
    NSString   *m_currentAppkey;     //请求返回的appkey
    
    NSInteger  m_dologid;            //保持token返回的dologid
    NSArray    *m_dologdir;          //保持token返回的dologdir
    NSString *urlString;

}

@property (nonatomic,retain) NSString    *loginUserName;
@property (nonatomic,retain) NSString    *loginUserPassword;
@property (nonatomic,assign) NSInteger   error_code;
@property (nonatomic,retain) NSString    *err_msg;
@property (nonatomic,retain) NSString    *token;
@property (nonatomic,retain) NSString    *loninID;
@property (nonatomic,assign) long        returnTime;
@property (nonatomic,retain) NSString    *is_active;
@property (nonatomic,retain) NSString    *currentAppkey;
@property (nonatomic,assign) NSInteger   dologid;
@property (nonatomic,retain) NSArray     *dologdir;
@property (nonatomic,retain) NSString *urlString;
//单例接口
+ (LoginManager *) shareInstance;
//登录
- (void) login:(NSString*)userName andPassWord:(NSString*)userPassword;
//刷新Token
-(void)refreshToken;
//转为十六进制编码
void uCharToHex(char *Dst, const unsigned char *Src, const int SrcLen);
//延长用户令牌接口
- (void) updateUserTokenId;
//hmac_sha256加密
- (NSString *) reginatureHmac_sha256:(NSString *)secInfo;
//登录方法，向服务器发送请求
-(void)login;


@end
