/*********************************************************************
 文件名称 : ObtainFileInfoManager.h
 作   者 : 陶万里
 创建时间 : 2012-09-22
 文件描述 : 获取文件信息模块
 *********************************************************************/

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "HttpEngine.h"
#import "head.h"
#import "FileInfo.h"
#import "AppDelegate.h"
#import "PublicMethod.h"

@interface ObtainFileInfoManager : NSObject<ASIHTTPRespondDelegate>{
    NSString *m_requestBody;
}

+(ObtainFileInfoManager *)shareInstance;


//获取单个文件信息业务接口
- (void)getFileInfoToken:(NSString *)token
                   andFid:(NSString *)fid
           andRuquestBody:(NSString *)requestBody
               andDologid:(NSString *)dologid;


@end
