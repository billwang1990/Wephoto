//
//  UpLoadManager.m
//  VDisk
//
//  Created by 戴安宁 on 12-9-19.
//  Copyright (c) 2012年 hoperun. All rights reserved.
//

#import "UpLoadManager.h"

@implementation UpLoadManager
@synthesize dir_id=m_dir_id;

+ (UpLoadManager *)shareInstance{
    static UpLoadManager *instance = nil;
    
    if (!instance)
    {
        @synchronized(self)
        {
            if (!instance) 
            {
                instance = [[UpLoadManager alloc] init];
            }
        }
    }
	return instance;
}
/*********************************************************************
 函数名称 : postToken
 函数描述 : 上传文件请求
 参数 : 
 token: 动态令牌
 dir_id: 目录的id, 0为根目录
 cover: 重名时是否覆盖, yes或no
 file: 文件
 dologid: 参考dolog机制
 返回值 : 无
 作者 : 戴安宁
 *********************************************************************/
- (void) postToken:(NSString *)token 
         andDir_id:(NSString *)dir_id 
          andCover:(NSString*)cover  
           andfile:(NSString*)filename
        andDologid:(NSString *)dologid
       andFileType:(NSString*)filetype
       andProgress:(UIProgressView*)myProgress
           andBody:(NSData *)body
{
    self.dir_id =dir_id;
    if (body.length>(10*1024*1024)) {
        return;
    }
    AppDelegate *appdelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"dogodid传上去的%@",appdelegate.dologid);
    NSString *request =[NSString stringWithFormat:@"%@&token=%@&dir_id=%@&cover=%@",UPLOAD_KEY_URL,token,dir_id,cover];
    //向网络层发请求
    [[HttpEngine shareInstance]postFormDataMethodHttpRequest:[NSURL URLWithString:request]  
                                                     andfile:filename 
                                                  andDologid:appdelegate.dologid 
                                                     andBody:body 
                                                     andType:VDISK_UPLOADFILE
                                                 andFileType:filetype
                                                 andProgress:myProgress
                                                 andDelegate:self];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:UPLOAD_KEY_BEGIN object:nil];
}
/*********************************************************************
 函数名称 : responseOfHttpRequest
 函数描述 : 回调函数
 参数 : respString
 返回值 : 无
 作者 : 戴安宁
 *********************************************************************/
-(void)responseOfHttpRequest:(NSString *)respString 
                      orData:(NSData *)respData 
                     andType:(RequestType)reqType 
                    andError:(NSError *)error{
    NSLog(@"%@",respString);
    if(error.code==0)
    {
        //解析json
        SBJsonParser *parser =[[SBJsonParser alloc]init];
        NSDictionary *json =[parser objectWithString:respString];
        //更新dologid
        AppDelegate *appdelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
        appdelegate.dologid =[json objectForKey:@"dologid"];
        appdelegate.dologdir=[json objectForKey:@"dologdir"];
        NSLog(@"dologid新的===========%@",appdelegate.dologid);
        [parser release];
        
        [[NSNotificationCenter  defaultCenter]postNotificationName:UPLOAD_KEY_END object:nil];
        
    }
}


//curl -F file=@filename.txt -F token=1f68cdc01158118da219aac3b1838fe5 -F cover=yes -F dir_id=0 "http://openapi.vdisk.me/?m=file&a=upload_file"

@end
