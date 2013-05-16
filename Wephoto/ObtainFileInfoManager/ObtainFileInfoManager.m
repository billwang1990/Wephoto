/*********************************************************************
 文件名称 : ObtainFileInfoManager.m
 作   者 : 陶万里
 创建时间 : 2012-09-22
 文件描述 : 获取文件信息模块
 *********************************************************************/

#import "ObtainFileInfoManager.h"

static ObtainFileInfoManager *obtainFileInfo = nil;

@implementation ObtainFileInfoManager

+(ObtainFileInfoManager *)shareInstance{
    @synchronized(self)
    {
        if (!obtainFileInfo)
        {
            obtainFileInfo = [[self alloc] init];
        }
    }
    return obtainFileInfo;
}

/*********************************************************************
 函数名称 : postFileInfoToken
 函数描述 : 获取文件信息业务接口
 参数 : token
 fid
 dologid
 返回值 : N／A
 作者 : 陶万里
 *********************************************************************/
- (void)getFileInfoToken:(NSString *)token
                  andFid:(NSString *)fid
          andRuquestBody:(NSString *)requestBody
              andDologid:(NSString *)dologid{
    m_requestBody = requestBody;
    NSString *request = [NSString stringWithFormat:@"%@&token=%@&fid=%@",OBTAIN_FILEINFO_URL,token,fid];
    /* 向服务器发送post请求 */
    [[HttpEngine shareInstance]postMethodHttpRequest:[NSURL URLWithString:request] andHead:nil andBody:nil andType:VDISK_GETFILEINFO andDelegate:self];
}

/*********************************************************************
 函数名称 : responseOfHttpRequest
 函数描述 : 回调函数
 参数 : respString
 respData
 type
 error
 返回值 : N／A
 作者 : 陶万里
 *********************************************************************/
-(void)responseOfHttpRequest:(NSString *)respString 
                      orData:(NSData *)respData 
                     andType:(RequestType)reqType 
                    andError:(NSError *)error{
//    NSLog(@"%@",respString);
    NSMutableDictionary *listDict = [[NSMutableDictionary alloc]init];
     //如果网络层没有错误，继续解析
    if (error.code == 0) {
        if (reqType == VDISK_GETFILEINFO) {
            NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc]init];
            SBJsonParser *parser =[[SBJsonParser alloc]init];
            NSDictionary *json =[parser objectWithString:respString];
//            NSLog(@"%@",json);
            if(json !=nil){
                NSNumber *err_code = [NSNumber numberWithInt:[[json objectForKey: @"err_code"] intValue]];
                NSString *err_msg =[json objectForKey:@"err_msg"];
                NSDictionary *data = [json objectForKey:@"data"];
                //如果解析的err_code为0即成功的
                if ([err_code intValue] == 0) {
                    FileInfo *dataList = [[FileInfo alloc]init];
                    dataList.weipanID = [data objectForKey:@"id"];
                    dataList.weipanName = [data objectForKey:@"name"];
                    dataList.fileUid = [data objectForKey:@"uid"];
                    dataList.weipanDir_ID = [data objectForKey:@"dir_id"];
                    dataList.weipanCtime = [data objectForKey:@"ctime"];
                    dataList.weipanItime = [PublicMethod changeTime: [data objectForKey:@"ltime"]];
                    dataList.weipanSize = [data objectForKey:@"size"];
                    dataList.fileIsLocked = [data objectForKey:@"is_locked"];
                    dataList.weipanType = [data objectForKey:@"type"];
                    dataList.weipanMd5 = [data objectForKey:@"md5"];
                    dataList.weipansha1 = [data objectForKey:@"sha1"];
                    dataList.fileH = [data objectForKey:@"h"];
                    dataList.fileW = [data objectForKey:@"w"];
                    dataList.fileHid = [data objectForKey:@"hid"];
                    dataList.fileStatus = [data objectForKey:@"share_status"];
                    dataList.fileAppKey = [data objectForKey:@"app_key"];
                    dataList.fileSource = [data objectForKey:@"source"];
                    dataList.fileIp = [data objectForKey:@"ip"];
                    dataList.fileRevId = [data objectForKey:@"rev_id"];
                    dataList.fileShare = [data objectForKey:@"share"];
                    dataList.fileS3Url = [data objectForKey:@"s3_url"];
                    dataList.weipanUrl = [data objectForKey:@"url"];
                    dataList.weipanByte = [data objectForKey:@"byte"];
                    dataList.weipanLength = [data objectForKey:@"length"];
                    dataList.fileDtime = [data objectForKey:@"dtime"];
                    
                    AppDelegate *appDelgate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                    appDelgate.dologid = [json objectForKey:@"dologid"];
                    NSString *dologdir = [json objectForKey:@"dologdir"];
                    //加入到字典中
                    [jsonDic setObject:dataList forKey:@"jsonData"];
                    [jsonDic setObject:err_code forKey:@"err_code"];
                    [jsonDic setObject:err_msg forKey:@"err_msg"];
                    [jsonDic setObject:appDelgate.dologid forKey:@"dologid"];
                    [jsonDic setObject:dologdir forKey:@"dologdir"];
                    [dataList release];
                }
            }
            [listDict setObject:jsonDic forKey:@"jsonData"];
            [jsonDic release];
            [parser release];
        }
    }
    [listDict setObject:[NSNumber numberWithInt:error.code] forKey:@"errorCode"];
//    NSLog(@"listDic:%@",listDict);
    // 向ui层发送通知，将解析数据发送给ui层
    [[NSNotificationCenter defaultCenter] postNotificationName:RCS_OBTAIN_FILEINFO_MANAGER_NTF_CENTER object:m_requestBody userInfo:listDict];
    [listDict release];
}


@end
