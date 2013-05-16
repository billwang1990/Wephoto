/********************************************************************
 文件名称 : HttpEngine.h 文件
 作 者   : 
 创建时间 : 2012-09-12
 文件描述 : http请求类
 *********************************************************************/

#import "HttpEngine.h"
#define REQUESTTIMEOUT 101
#define REQUESTTOOMANY 102

static HttpEngine *httpEngine = nil;

@implementation HttpEngine
@synthesize downloadDictionary;
@synthesize value;
@synthesize m_upLoadSize;

+ (HttpEngine *)shareInstance
{
    @synchronized(self)
    {
        if (nil == httpEngine)
        {
            httpEngine = [[HttpEngine alloc] init];
        }
    }
    return httpEngine;
}

-(id)init
{
    self = [super init];
    if (self) 
    {
        m_Queue = [[ASINetworkQueue alloc] init];
        [m_Queue setShowAccurateProgress:YES];
        [m_Queue go];
        
        m_UpLoadQueue = [[ASINetworkQueue alloc] init];
        [m_UpLoadQueue setShowAccurateProgress:YES];
        [m_UpLoadQueue go];
        
        m_downLoadQueue = [[ASINetworkQueue alloc] init];
        [m_downLoadQueue setShowAccurateProgress:YES];
        [m_downLoadQueue go];
        
        //http下载字典，用于取消请求
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
        self.downloadDictionary = dictionary;
        [dictionary release];

    }
    return self;
}

- (void)dealloc
{
    [m_UpLoadQueue release];
    [m_Queue release];
    [downloadDictionary release];
    [m_downLoadQueue release];
    [super dealloc];
}

/*********************************************************************
 函数名称 : getMethodHttpRequest
 函数描述 : 以GET方式进行http请求
 参数 : 
 aUrl: 请求的url
 request: 请求参数string
 reqType: 请求类型
 返回值 : 无
 作者 : wei_hangtian
 *********************************************************************/
- (void)getMethodHttpRequest:(NSURL *)aUrl 
                  andRequest:(NSString *)request 
                     andType:(RequestType)reqType
                 andDelegate:(id)delegate
{
    NSString *a_Str = [NSString stringWithFormat:@"%@",aUrl];
    NSString *ano_Str = [NSString stringWithFormat:@"%@&%@",a_Str,request];
    NSURL *a_Url = [NSURL URLWithString:ano_Str];
    ASIHTTPRequest *a_Request = [[ASIHTTPRequest alloc] initWithURL:a_Url];
    
    a_Request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:reqType],@"type",delegate,@"delegate", nil];
    [a_Request setRequestMethod:@"GET"];
    [a_Request setDelegate:self];
    [m_Queue addOperation:a_Request];
    [a_Request release];
}

/*********************************************************************
 函数名称 : getMethodHttpRequest
 函数描述 : 以GET方式进行http请求
 参数 : 
 aUrl: 请求的url
 request: 请求参数string
 reqType: 请求类型
 progress:进度条
 返回值 : 无
 作者 : 陶万里
 *********************************************************************/

- (void)getMethodHttpRequest:(NSURL *)aUrl 
                  andRequest:(NSString *)request 
                     andType:(RequestType)reqType
             andProgressView:(id)progress
                 andDelegate:(id)delegate{
    ASIHTTPRequest *a_Request = [[ASIHTTPRequest alloc] initWithURL:aUrl];
    a_Request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:reqType],@"type",delegate,@"delegate", nil];
    [a_Request setRequestMethod:@"GET"];
    [a_Request setDelegate:self];
    //设置继续使用未下载完的文件
    [a_Request setAllowResumeForFileDownloads:YES];
    // 设置下载进度回调代理
    [a_Request setDownloadProgressDelegate:progress];
    //添加进入字典管理
    @synchronized(self.downloadDictionary) {
        [self.downloadDictionary setObject:a_Request forKey:aUrl];
    }
    [m_downLoadQueue addOperation:a_Request];
    [a_Request release];
}


/*********************************************************************
 函数名称 : postMethodHttpRequest
 函数描述 : 以POST方式进行http请求
 参数 : 
 aUrl: 请求的url
 aHead: 请求头
 sbody: 请求体
 Type : 请求类型
 返回值 : 无
 作者 : 赵 石
 *********************************************************************/

- (void)postMethodHttpRequest:(NSURL *)aUrl 
                      andHead:(NSDictionary *)aHead 
                      andBody:(NSData *)sbody
                      andType:(RequestType)Type
                      andDelegate:(id)delegate
{
   
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:aUrl];
    [request appendPostData:sbody];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Type],@"type",delegate,@"delegate",nil];
    [m_Queue addOperation:request];
    [request release];
    
}

/*********************************************************************
 函数名称 : postFormDataMethodHttpRequest
 函数描述 : 以POST方式进行http请求
 参数 : 
 aUrl: 请求的url
 Token: token
 andBody: 请求体
 Type : 请求类型
 返回值 : 无
 
 *********************************************************************/
- (void)postFormDataMethodHttpRequest:(NSURL *)aUrl 
                              andfile:(NSString*)filename
                           andDologid:(NSString *)dologid
                              andBody:(NSData *)sbody
                              andType:(RequestType)Type
                          andFileType:(NSString*)filetype
                          andProgress:(id)myProgress
                          andDelegate:(id)delegate
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:aUrl];
	[request setDelegate:self];
	[request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addPostValue:dologid forKey:@"dologid"];
    [request addData:sbody withFileName:filename andContentType:@"image/jpeg" forKey:@"photos"];
    request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Type],@"type",delegate,@"delegate",nil];
    [request setUploadProgressDelegate:myProgress];
     //加入队列
    [m_UpLoadQueue addOperation:request];
    NSLog(@"...................Value: %f",[myProgress progress]);
	//[request startSynchronous];
    [request release];
}



- (void)obtainResponse:(ASIHTTPRequest *)request
{
    id<ASIHTTPRespondDelegate> a_Delegate = [request.userInfo objectForKey:@"delegate"];
    int type = [[request.userInfo objectForKey:@"type"] intValue];
    if (a_Delegate && [a_Delegate respondsToSelector:@selector(responseOfHttpRequest:orData:andType:andError:)])
    {
        [a_Delegate responseOfHttpRequest:[request responseString] orData:[request responseData] andType:type andError:[request error]];
        
    }
}

#pragma mark-delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
   // NSLog(@"%@",request.responseString);
    [self obtainResponse:request];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self obtainResponse:request];
    NSError *error = [request error];
    NSLog(@"error~~~~~~~~~~~~%@",error);
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
}

// 获取当前下载量
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
    NSLog(@"%f",m_currentSize);
//     //获取当前下载量
//    m_currentSize += bytes;
//    self.value = m_currentSize/request.contentLength;
//    NSLog(@"-------------------------------------------------------------------------------%f",self.value);
}

//-(void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength{
//
//
//}
//-(void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes{
//         //获取当前上传量
//       // m_upLoadSize = bytes+m_upLoadSize;
//}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{

}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    
}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
    
}



@end
