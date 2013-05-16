/********************************************************************
 文件名称 : HttpEngine.h 文件
 作 者   : 
 创建时间 : 2012-09-12
 文件描述 : http请求类
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIPublicDefine.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASINetworkQueue.h"

@protocol ASIHTTPRespondDelegate <NSObject>

-(void)responseOfHttpRequest:(NSString *)respString 
                      orData:(NSData *)respData 
                     andType:(RequestType)reqType 
                    andError:(NSError *)error;
@end


@interface HttpEngine : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    ASINetworkQueue *m_Queue;                   //请求队列
    ASINetworkQueue *m_UpLoadQueue;             //上传请求队列
    ASINetworkQueue *m_downLoadQueue;             //下载请求队列
    float m_currentSize;
    float value;
}

@property (nonatomic,retain) NSMutableDictionary *downloadDictionary;     // http下载字典，用于取消请求
@property (nonatomic,assign) float value;
@property (nonatomic,assign) float m_upLoadSize;

+ (HttpEngine *)shareInstance;

- (void)postMethodHttpRequest:(NSURL *)aUrl 
                      andHead:(NSDictionary *)aHead 
                      andBody:(NSData *)sbody
                      andType:(RequestType)Type
                      andDelegate:(id)delegate;
/*********************************************************************
 函数名称 : postFormDataMethodHttpRequest:
 函数描述 : 上传
 参数 : url
 返回值 : N/A
 作者 : 戴安宁
 *********************************************************************/
- (void)postFormDataMethodHttpRequest:(NSURL *)aUrl 
                              andfile:(NSString*)filename
                           andDologid:(NSString *)dologid
                              andBody:(NSData *)sbody
                              andType:(RequestType)Type
                          andFileType:(NSString*)filetype
                          andProgress:(id)myProgress
                          andDelegate:(id)delegate;


- (void)getMethodHttpRequest:(NSURL *)aUrl 
                  andRequest:(NSString *)request 
                     andType:(RequestType)reqType
                 andDelegate:(id)delegate;

//下载文件的请求方法
- (void)getMethodHttpRequest:(NSURL *)aUrl 
                  andRequest:(NSString *)request 
                     andType:(RequestType)reqType
             andProgressView:(id)progress
                 andDelegate:(id)delegate;
             
- (void)obtainResponse:(ASIHTTPRequest *)request;


@end
