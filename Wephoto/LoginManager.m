//
//  LoginManager.m
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager
@synthesize loginUserName = m_loginUserName;
@synthesize loginUserPassword = m_loginPassword;
@synthesize error_code = m_error_code;
@synthesize err_msg = m_err_msg;
@synthesize token = m_token;
@synthesize loninID = m_loninID;
@synthesize returnTime = m_time;
@synthesize is_active = m_is_active;
@synthesize currentAppkey = m_currentAppkey;
@synthesize dologid = m_dologid;
@synthesize dologdir = m_dologdir;
@synthesize urlString = urlString;

static LoginManager *loginManager = nil;

-(void)dealloc
{
    [m_loginUserName release];
    [m_loginPassword release];
    [m_err_msg release];
    [m_token release];
    [m_loninID release];
    [m_is_active release];
    [m_currentAppkey release];
    [m_dologdir release];
    [urlString release];
    [super dealloc];
}

/*********************************************************************
 函数名称 : shareInstance
 函数描述 : 单例接口
 参数 : N/A
 返回值 : N/A
 *********************************************************************/
+ (LoginManager *)shareInstance
{
	@synchronized(self) //保持同步
    {
		if (loginManager == nil)
		{
			loginManager = [[LoginManager alloc] init];
		}
	}
	return loginManager;
}

//转为十六进制编码
void uCharToHex(char *Dst, const unsigned char *Src, const int SrcLen)
{
    char *Temp = Dst;
    int i;
    
    if (Dst == NULL || Src == NULL || SrcLen <= 0)
    {
        return;
    }
    
    for (i = 0; i < SrcLen; ++i)
    {
        sprintf(Temp, "%02x", Src[i]);
        Temp += 2;
    }
    return;
}

/*********************************************************************
 函数名称 : reginatureHmac_sha256
 函数描述 : 将字符串进行编码加密
 参数 : secInfo（需要加密的字符串，由自己拼接）
 返回值 : string（加密后的字符串）
 *********************************************************************/
- (NSString *) reginatureHmac_sha256:(NSString *)secInfo
{
    const char *cKey  = [LOGIN_APPSECRET cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [secInfo cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    
    CCHmacContext hctx;
    CCHmacInit(&hctx, kCCHmacAlgSHA256, cKey, strlen(cKey));
    CCHmacUpdate(&hctx, cData, strlen(cData));
    CCHmacFinal(&hctx, cHMAC);
    
    char* dest = (char*)malloc(2*CC_SHA256_DIGEST_LENGTH);
    if(dest == NULL)
    {
        return @"";
    }
    memset(dest, 0, 2*CC_SHA256_DIGEST_LENGTH);
    uCharToHex(dest,cHMAC,CC_SHA256_DIGEST_LENGTH);
    
    return [[NSString stringWithCString:dest encoding:NSUTF8StringEncoding] lowercaseString];
}

/*********************************************************************
 函数名称 : login:andPassWord
 函数描述 : UI界面点击登录后执行的方法，用以向服务器发送请求,外部接口
 参数 :
 userName : 用户名
 userPassword : 密码
 返回值 : N/A
 *********************************************************************/
- (void) login:(NSString*)userName andPassWord:(NSString*)userPassword
{
    //变量赋值
    self.loginUserName = userName;
    self.loginUserPassword = userPassword;
    //登录
    [self login];
}

-(void)login
{
    //时间参数
    unsigned long timeFrom1970 = time(NULL);
    
    //字符串的拼接
    NSString *secInfo = [NSString stringWithFormat:@"account=%@&appkey=%@&password=%@&time=%ld",m_loginUserName,LOGIN_APPKEY,m_loginPassword,
                         timeFrom1970];
    
    //字符串拼接成为可以发送的URL字符串
    self.urlString = [NSString stringWithFormat:@"%@&account=%@&password=%@&appkey=%@&time=%ld&signature=%@&app_type=sinat",LOGIN_GETTOKEN_URL,m_loginUserName,
                      m_loginPassword,LOGIN_APPKEY,timeFrom1970,[self reginatureHmac_sha256:secInfo]];
    
    //向服务器发送请求
    [[HttpEngine shareInstance] postMethodHttpRequest:[NSURL URLWithString:self.urlString]
                                              andHead:nil
                                              andBody:nil
                                              andType:VDISK_GETTOKEN
                                          andDelegate:self];
    
}

//代理方法
-(void)responseOfHttpRequest:(NSString *)respString
                      orData:(NSData *)respData
                     andType:(RequestType)reqType
                    andError:(NSError *)error
{
    NSInteger errorCode = [error code];
    NSDictionary *jsonDicString = nil;
    NSLog(@"======= %@",respString);
    switch (errorCode)
    {
        case 0:
            //http请求正常
        {
            //解析返回JSON成字典
            NSData *respondString = [respString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *localError = nil;
            //请求正常，解析返回的JSON数据
            jsonDicString = [NSJSONSerialization JSONObjectWithData:respondString options:NSJSONReadingAllowFragments error:&localError];
            
            if (jsonDicString !=NULL)
            {
                switch(reqType)
                {
                    case VDISK_GETTOKEN: //获取token
                    {
                        //成员变量赋值
                        self.error_code = [[jsonDicString objectForKey:@"err_code"] intValue];
                        if (m_error_code == 0)
                        {
                            self.err_msg = [jsonDicString objectForKey:@"err_msg"];
                            self.loninID = [[jsonDicString objectForKey:@"data"]objectForKey:@"uid"];
                            self.returnTime = [[[jsonDicString objectForKey:@"data"] objectForKey:@"time"] intValue];
                            self.token = [[jsonDicString objectForKey:@"data"] objectForKey:@"token"];
                            self.is_active = [[jsonDicString objectForKey:@"data"] objectForKey:@"is_active"];
                            self.currentAppkey = [[jsonDicString objectForKey:@"data"]objectForKey:@"appkey"];
                            
                            //正常登录，间隔10分钟保持一次token
                            if([m_tokenTimer isValid])
                            {
                                [m_tokenTimer invalidate];
                                m_tokenTimer = nil;
                            }
                            //十分钟刷新一次
                            m_tokenTimer = [NSTimer scheduledTimerWithTimeInterval:600
                                                                            target:[LoginManager shareInstance]
                                                                          selector:@selector(refreshToken)
                                                                          userInfo:nil
                                                                           repeats:YES];
                        }
                    }
                        break;
                        
                    case VDISK_KEEPTOKEN: //保持token
                    {
                        //数据赋值
                        self.error_code = [[jsonDicString objectForKey:@"err_code"] intValue];
                        if (m_error_code == 0)
                        {
                            self.err_msg = [jsonDicString objectForKey:@"err_msg"];
                            self.loninID = [[jsonDicString objectForKey:@"data"]objectForKey:@"uid"];
                            self.dologid = [[jsonDicString objectForKey:@"dologid"] intValue];
                            self.dologdir = [jsonDicString objectForKey:@"dologdir"];
                            
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            appDelegate.dologid = [jsonDicString objectForKey:@"dologid"];
                            appDelegate.dologdir = [jsonDicString objectForKey:@"dologdir"];
                        }
                        else
                        {
                            //重新登录
                            [self login];
                            //标识为是重新获取token，只更新token，不用发送通知
                            refreshToken = YES;
                        }
                    }
                        break;
                    default: //其他不进行处理
                        break;
                }
            }
            else
            {
                errorCode = 1;//连接不到服务器
                //http请求其他错误,可以连接到http，但是连接不到服务器
                jsonDicString  =[NSDictionary dictionaryWithObject:@"nilObject" forKey:@"jsondata"];
            }
        }
            break;
        default:
            //http请求其他错误,字典的内容不同
            jsonDicString  =[NSDictionary dictionaryWithObject:@"nilObject" forKey:@"jsondata"];
            break;
    }
    //只有获取token的时候才有必要发送通知，其他时候只要进行数据的更新
    if (refreshToken == NO)
    {
        //发送的字典，包括搜索引擎的错误码，和服务器返回的数据，有正常登录的数据和非正常登录的数据
        NSDictionary *sendDic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",errorCode],@"error",
                                 jsonDicString,@"jsondata",nil];
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_MANAGER_SUCCESS object:nil userInfo:sendDic];
        [sendDic release];
    }
}

/*********************************************************************
 函数名称 : refreshToken
 函数描述 : 刷新，保持Token
 参数 : N/A
 返回值 : N/A
 *********************************************************************/
-(void)refreshToken
{
    [[LoginManager shareInstance] updateUserTokenId];
}

/*********************************************************************
 函数名称 : updateUserTokenId
 函数描述 : 延长用户令牌接口
 参数 : N/A
 返回值 : N/A
 *********************************************************************/
- (void) updateUserTokenId
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //字符串的拼接
    NSString *secInfo = [NSString stringWithFormat:@"token=%@&dologid=%@",m_token,appDelegate.dologid];
    
    self.urlString = [NSString stringWithFormat:@"%@&%@",LOGIN_KEEPTOKEN_URL,secInfo];
    
    //向服务器发送请求
    [[HttpEngine shareInstance] postMethodHttpRequest:[NSURL URLWithString:self.urlString]
                                              andHead:nil
                                              andBody:nil
                                              andType:VDISK_KEEPTOKEN
                                          andDelegate:[LoginManager shareInstance]];
}


@end
