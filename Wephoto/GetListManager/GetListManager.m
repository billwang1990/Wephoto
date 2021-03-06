/********************************************************************
 文件名称 : GetListManager.h 文件
 作 者 : 朱冬蕾
 创建时间 : 2012-09-12
 文件描述 : 获取列表信息模块
 *********************************************************************/

#import "GetListManager.h"

static GetListManager *getlist = nil;

@implementation GetListManager
@synthesize listDict;
@synthesize keepListarr;
@synthesize operatingDirID;
@synthesize operatingDirPid;
@synthesize operatingDirToPid;
@synthesize operatingDirName;
@synthesize deleteArray;
@synthesize m_dologid;
@synthesize listarr;
@synthesize tmpcount;

/*********************************************************************
 函数名称 : shareInstance
 函数描述 : 单例模式
 参数 : 
 返回值 : getlist
 作者 : 朱冬蕾
 *********************************************************************/
+ (GetListManager *)shareInstance
{
    @synchronized(self)
    {
        if (!getlist)
        {
            getlist = [[self alloc] init];
        }
    }
    return getlist;
}


-(id)init
{
    self = [super init];
    if (self) {        
        NSMutableDictionary *temListData = [[NSMutableDictionary alloc]init];
        self.listDict = temListData;
        [temListData release];
        
        //为ui建立一个全局数组，持有点击的id
        NSMutableArray *keepListData = [[NSMutableArray alloc]init];
        self.keepListarr = keepListData;
        [keepListData release];
        
        NSMutableArray *tmplistarr = [[NSMutableArray alloc]init];
        self.listarr = tmplistarr;
        [self.listarr addObject:@"0"];
        [tmplistarr release];
        
        self.tmpcount =1;

        //接收回收站还原文件通知
        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restore:) name:GETRECYCLELIST_NOTICE_NAME object:nil];
        //接收上传文件刷新列表通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newupload) name:UPLOAD_KEY_END object:nil];
    }
    return self;
}


/*********************************************************************
 函数名称 : restore
 函数描述 : 还原回收站文件通知响应方法
 参数 : notify
  返回值 : N／A
 作者 : 朱冬蕾
 *********************************************************************/
-(void)restore:(NSNotification *)notify
{

}

/*********************************************************************
 函数名称 : newupload
 函数描述 : 上传文件刷新列表事件
 参数 :N/A
 返回值 : N／A
 作者 : 朱冬蕾
 *********************************************************************/
-(void)newupload{
    NSMutableDictionary *data =[[NSMutableDictionary alloc]init];
    [data setObject:[UpLoadManager shareInstance].dir_id forKey:@"dir_id"];
    //给ui层添加通知，刷新列表
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_FILE_MANAGER_NTF_CENTER object:nil userInfo:data];
    [data release];
}
/*********************************************************************
 函数名称 : getListToken
 函数描述 : 列表接口
 参数 : token
 dir_id
 page
 pageSize
 dologid
 返回值 : N／A
 *********************************************************************/
-(void)getListToken:(NSString*)token
          anddir_id:(NSString*)dir_id
            andpage:(NSString*)Page
        andpageSize:(NSString*)pageSize
         anddologid:(NSString*)dologid

{  
    m_listPid =dir_id;
    BOOL hasEqual=NO;
    AppDelegate *appdelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //判断是否是最新的dologid，如果不是，则重新向网络端请求数据
    if([self.m_dologid isEqualToString:appdelegate.dologid])
    {
        NSMutableArray *listArr =[[NSMutableArray alloc]init];
        ListData *list;
        //遍历本地存有对象的数组
        for(int i=0;i<[keepListarr count];i++){
            list =[keepListarr objectAtIndex:i];
            
            if([list.weipanPid isEqualToString:dir_id]){
                [self.listDict removeAllObjects];
                [listArr addObject:list];
                hasEqual =YES;
            }
        }
        //如果数组中有一样的，则发送数组中的对象
        if(hasEqual ==YES)
        {
            [self.listDict setObject:listArr forKey:@"list"];
            [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTSUCCESS_MANAGER_NTF_CENTER object:nil userInfo:self.listDict]; 
            
        }
        //如果数组中不存在需要的对象，则向网络端请求数据
        else
        {
            NSString *url = [NSString stringWithFormat:@"%@&token=%@&dir_id=%@",Getlisturl,token,dir_id];
            [[HttpEngine shareInstance]postMethodHttpRequest:[NSURL URLWithString:url] andHead:nil andBody:nil	 andType:VDISK_GETLIST andDelegate:self];
        }
        [listArr release];
        
    } else 
    {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&dir_id=%@",Getlisturl,token,dir_id];
        [[HttpEngine shareInstance]postMethodHttpRequest:[NSURL URLWithString:url] andHead:nil andBody:nil	 andType:VDISK_GETLIST andDelegate:self];
    }
}


/*********************************************************************
 函数名称 : responseOfHttpRequest
 函数描述 : 回调函数
 参数 : respString
 respData
 type
 error
 返回值 : N／A
 作者 : 朱冬蕾
 *********************************************************************/
-(void)responseOfHttpRequest:(NSString *)respString 
                      orData:(NSData *)respData 
                     andType:(RequestType)reqType 
                    andError:(NSError *)error
{
    NSLog(@"======= %@",respString);
        //如果是请求列表数据，那么事先清空字典
    count ++;
    if (reqType == VDISK_GETLIST) {
        if (self.listDict.allKeys.count != 0) {
            [self.listDict removeAllObjects];
        }
    }
    
    [self.listDict setObject:[NSNumber numberWithInt:error.code] forKey:@"err"];
    //如果网络层没有错误，继续解析
    if(error.code ==success){
        
        //json解析获取列表信息
        SBJsonParser *parser =[[SBJsonParser alloc]init];
        NSDictionary *json =[parser objectWithString:respString];
        [self.listDict setObject:json forKey:@"json"];
        if(json !=nil){
            NSNumber *err_code = [NSNumber numberWithInt:[[json objectForKey: @"err_code"] intValue]];
            NSString *err_msg =[json objectForKey:@"err_msg"];
            NSString *dologid =[json objectForKey:@"dologid"];
            NSMutableArray *dologdir =[json objectForKey:@"dologdir"];
            //更新dologid和dologdir
            AppDelegate *appdelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
            appdelegate.dologid =[json objectForKey:@"dologid"];
            appdelegate.dologdir =[json objectForKey:@"dologdir"];
            
            //加入到字典中
            [self.listDict setObject:err_code forKey:@"err_code"];
            [self.listDict setObject:err_msg forKey:@"err_msg"];
            [self.listDict setObject:dologid forKey:@"dologid"];
            [self.listDict setObject:dologdir forKey:@"dologdir"];
            
            //如果解析的err_code为0即成功的
            if([err_code intValue] ==success)
            {
                //根据type类型执行不同的操作
                switch (reqType) 
                {
                    case VDISK_GETLIST:
                    {
                        self.m_dologid =dologid;
                        NSDictionary *data =[json objectForKey:@"data"];
                        NSArray *list =[data objectForKey:@"list"];
                        NSDictionary *pageInfo =[data objectForKey:@"pageinfo"];
                        
                        NSMutableDictionary *pageinfodic =[[NSMutableDictionary alloc]init];
                        PageInfoData *info =[[PageInfoData alloc]init];
                        //当前页码
                        info.page = [pageInfo objectForKey:@"page"];
                        //每页行数
                        info.pageSize =[pageInfo objectForKey:@"pageSize"];
                        //文件总数
                        info.rstotal =[pageInfo objectForKey:@"rstotal"];
                        //文件页数
                        info.pageTotal =[pageInfo objectForKey:@"pageTotal"];
                        
                        [pageinfodic setObject:info forKey:@"info"];
                        //建立数组，存放list属性
                        NSMutableArray *listArray =[[NSMutableArray alloc]init];
                        //获取多个list对象
                        for(int i=0;i<[info.rstotal intValue];i++)
                        {
                            NSDictionary *fileInfo = [list objectAtIndex:i];
                            ListData *vi = [[ListData alloc] init];
                            vi.weipanID =[fileInfo objectForKey:@"id"];
                            vi.weipanName =[fileInfo objectForKey:@"name"];
                            vi.weipanDir_ID=[fileInfo objectForKey:@"dir_id"];
                            vi.weipanCtime =[fileInfo objectForKey:@"ctime"];
                            NSString *time =[fileInfo objectForKey:@"ltime"];
                            vi.weipanItime =[PublicMethod changeTime:time];
                            vi.weipanSize =[fileInfo objectForKey:@"size"];
                            vi.weipanPid =m_listPid;
                            vi.weipanType =[fileInfo objectForKey:@"type"];
                            vi.weipanFile_num =[fileInfo objectForKey:@"file_num"];
                            vi.weipanMd5 =[fileInfo objectForKey:@"md5"];
                            vi.weipansha1=[fileInfo objectForKey:@"sha1"];
                            vi.weipanShare =[fileInfo objectForKey:@"share"];
                            vi.weipanByte =[fileInfo objectForKey:@"byte"];
                            vi.weipanLength =[fileInfo objectForKey:@"length"];
                            vi.weipanThumbnail =[fileInfo objectForKey:@"thumbnail"];
                            vi.weipanUrl =[fileInfo objectForKey:@"url"];
                            [listArray addObject:vi];
                            
                            //加入到keeplist中
                            //[self.keepListarr addObject:vi];
                            [vi release];
                        }
                        //加入到字典中
                        [self.listDict setObject:pageinfodic forKey:@"pageinfodic"];
                        [self.listDict setObject:listArray forKey:@"list"];
                        //发送通知，将数据通过字典方式发给ui层
                        [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTSUCCESS_MANAGER_NTF_CENTER object:nil userInfo:self.listDict];
                        
                        //[[FileManager shareInstance]operationFile:keepListarr andList:listArray andParentID:m_listPid andFileID:nil andToPath:nil andFileType:VDISK_GETLIST];
                        [pageinfodic release];
                        [listArray release];
                        [info release];
                        
                    }
                        break;
                    case VDISK_CREATEDIR:  
                    {
                        //解析创建目录请求的json
                        ListData *listData = [[ListData alloc]init];
                        NSDictionary *data = [json objectForKey:@"data"];
                        listData.weipanID = [data objectForKey:@"dir_id"];
                        listData.weipanName = [data objectForKey:@"name"];
                        listData.weipanCtime = [PublicMethod changeTime:[data objectForKey:@"ctime"]];
                        listData.weipanItime = [PublicMethod changeTime:[data objectForKey:@"ltime"]];
                        listData.weipanPid = self.operatingDirPid;
                        listData.weipanUid = [data objectForKey:@"uid"];
                        listData.weipanFile_num = @"0";
                        
                        //把解析的数据放入字典中
                        [[self.listDict objectForKey:@"list"] addObject:listData];
                        [self.keepListarr addObject:listData];
                        //发送通知，将数据通过字典方式发给ui层
                        [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTSUCCESS_MANAGER_NTF_CENTER object:nil userInfo:self.listDict]; 
                        [[FileManager shareInstance]operationFile:keepListarr andList:[self.listDict objectForKey:@"list"] andParentID:self.operatingDirPid andFileID:nil andToPath:nil andFileType:VDISK_CREATEDIR];
                        
                        [listData release];
                    }
                        break;
                    case VDISK_DELETEDIR:
                    {
                        
                        //把要删除的目录或者移走的目录删除掉，并且把新目录传给UI层
                        NSMutableArray *listArray = [self.listDict objectForKey:@"list"];
                        
                        NSString *tmpListDataPid;
                        ListData *tmplistData;
                        
                        for (tmplistData in listArray) {
                            if ([tmplistData.weipanID isEqualToString:operatingDirID]) {
                                tmpListDataPid = [tmplistData.weipanPid retain];
                                [[FileManager shareInstance]operationFile:keepListarr andList:[self.listDict objectForKey:@"list"] andParentID:tmpListDataPid andFileID:operatingDirID andToPath:nil andFileType:VDISK_DELETEDIR];
                                [listArray removeObject:tmplistData];
                                [self.keepListarr removeObject:tmplistData];
                                //发送通知，将数据通过字典方式发给ui层
                                [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTSUCCESS_MANAGER_NTF_CENTER object:nil userInfo:self.listDict]; 
                                [tmpListDataPid release];
                                break;
                            }
                        }
                    }
                        break;
                    case VDISK_MOVEDIR:
                    {
                        
                        //把要删除的目录或者移走的目录删除掉，并且把新目录传给UI层
                        NSMutableArray *listArray = [self.listDict objectForKey:@"list"];
                        for (ListData *tmplistData in listArray) {
                            if ([tmplistData.weipanID isEqualToString:operatingDirID]) {
                                [listArray removeObject:tmplistData];
                                break;
                            }
                        }
                        //发送通知，将数据通过字典方式发给ui层
                        [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTSUCCESS_MANAGER_NTF_CENTER object:nil userInfo:self.listDict]; 
                        [[FileManager shareInstance]operationFile:keepListarr andList:[self.listDict objectForKey:@"list"] andParentID:nil andFileID:self.operatingDirID andToPath:self.operatingDirToPid andFileType:VDISK_MOVEDIR];
                    }
                        break;
                    case VDISK_RENAMEDIR:
                    {
                        //重命名目录，并且把新目录传给UI层
                        NSMutableArray *listArray = [self.listDict objectForKey:@"list"];
                        NSString *tmpListDataPid;
                        for (ListData *tmplistData in listArray) {
                            if ([tmplistData.weipanID isEqualToString:operatingDirID]) {
                                tmpListDataPid = [tmplistData.weipanPid retain];
                                tmplistData.weipanName = self.operatingDirName;
                                //发送通知，将数据通过字典方式发给ui层
                                [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTSUCCESS_MANAGER_NTF_CENTER object:nil userInfo:self.listDict]; 
                                [[FileManager shareInstance]operationFile:keepListarr andList:[self.listDict objectForKey:@"list"] andParentID:tmpListDataPid andFileID:self.operatingDirID andToPath:nil andFileType:VDISK_RENAMEDIR];
                                [tmpListDataPid release];
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        //类型没有匹配的，发送通知，告诉ui获取列表数据失败
                        [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTFAILED_MANAGER_NTF_CENTER object:nil];
                        break;
                }
                if (count < self.deleteArray.count) {
                    [self deleteDirInDir:self.operatingDirPid WithToken:[LoginManager shareInstance].token andDirIDArray:self.deleteArray andDologID:nil];
                }else{
                    count = 0;
                }
                
            } else 
            {
                //err_code不问零，发送通知，告诉ui获取列表数据失败
                [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTFAILED_MANAGER_NTF_CENTER object:nil];
            }
        } 
        else 
        {
            //json为空，发送通知，告诉ui获取列表数据失败
            [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTFAILED_MANAGER_NTF_CENTER object:nil];
        }
        [parser release];
    }  
    else
    {
        //err.code不为零，发送通知，告诉ui获取列表数据失败
        [[NSNotificationCenter defaultCenter]postNotificationName:RCSGETLISTFAILED_MANAGER_NTF_CENTER object:nil];
    }
}

#pragma mark - 目录请求
/*********************************************************************
 函数名称 : creatDirWithToken:andDirName:andParentID:andDologID:
 函数描述 : 新建文件目录
 参数 : 
 token : 动态签名
 dirName : 新目录名称
 parentID : 上级目录ID
 dologID : dologid
 返回值 : 无
 作者 : 崔俊奇
 *********************************************************************/
-(void)creatDirInDir:(NSString *)dirPid
           WithToken:(NSString *)token 
          andDirName:(NSString *)dirName 
         andParentID:(NSString *)parentID 
          andDologID:(NSString *)dologID
{
    [self refreshCurrentListDictWithPid:dirPid];
    self.operatingDirPid = parentID;
    NSString *request = [NSString stringWithFormat:@"%@&token=%@&create_name=%@&parent_id=%@",CreatNewDir,token,[dirName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],parentID];
    
    
    //    发送post请求，创建新目录
    [[HttpEngine shareInstance]postMethodHttpRequest:[NSURL URLWithString:request] 
                                             andHead:nil 
                                             andBody:nil 
                                             andType:VDISK_CREATEDIR 
                                         andDelegate:self];
}

/*********************************************************************
 函数名称 : deleteDirWithToken:andDirName:andParentID:andDologID:
 函数描述 : 删除文件目录
 参数 : 
 token : 动态签名
 dirName : 新目录名称
 parentID : 上级目录ID
 dologID : dologid
 返回值 : 无
 作者 : 崔俊奇
 *********************************************************************/
-(void)deleteDirInDir:(NSString *)dirPid
            WithToken:(NSString *)token 
             andDirIDArray:(NSArray *)dirIDArray 
           andDologID:(NSString *)dologid
{
    [self refreshCurrentListDictWithPid:dirPid];
    self.deleteArray = dirIDArray;
    self.operatingDirID = [dirIDArray objectAtIndex:count];
    self.operatingDirPid = dirPid;
    
    NSString *request = [NSString stringWithFormat:@"%@&token=%@&dir_id=%@",DeleteDir,token,self.operatingDirID];
    
    //    发送删除目录请求
    [[HttpEngine shareInstance]postMethodHttpRequest:[NSURL URLWithString:request] 
                                             andHead:nil 
                                             andBody:nil 
                                             andType:VDISK_DELETEDIR 
                                         andDelegate:self];
}

/*********************************************************************
 函数名称 : reNameDirWithToken:andDirID:andNewName:andDologID:
 函数描述 : 重命名文件目录
 参数 : 
 token : 动态签名
 dirID : 目录ID
 newName : 新目录名称
 dologID : dologid
 返回值 : 无
 作者 : 崔俊奇
 *********************************************************************/
-(void)reNameDirInDir:(NSString *)dirPid
            WithToken:(NSString *)token 
             andDirID:(NSString *)dirID 
           andNewName:(NSString *)newName
           andDologID:(NSString *)dologid
{
    [self refreshCurrentListDictWithPid:dirPid];
    self.operatingDirID = dirID;
    self.operatingDirName = newName;
    self.operatingDirPid = dirPid;
    
    NSString *reqest = [NSString stringWithFormat:@"%@&token=%@&dir_id=%@&new_name=%@",ReNameDir,token,dirID,newName];
    
    //    发送重命名目录请求
    [[HttpEngine shareInstance]postMethodHttpRequest:[NSURL URLWithString:reqest] 
                                             andHead:nil 
                                             andBody:nil 
                                             andType:VDISK_RENAMEDIR 
                                         andDelegate:self];
}

/*********************************************************************
 函数名称 : moveDirWithToken:andDirID:andNewName:andDologID:
 函数描述 : 移动目录
 参数 : 
 token : 动态签名
 dirID : 目录ID
 newName : 移动后的目录名称
 parentID : 移动到的目录名称
 dologID : dologid
 返回值 : 无
 作者 : 崔俊奇
 *********************************************************************/
-(void)moveDirInDir:(NSString *)dirPid
          WithToken:(NSString *)token 
           andDirID:(NSString *)dirID 
         andNewName:(NSString *)newName 
         ToParentID:(NSString *)parentID 
         andDologID:(NSString *)dologid
{
    [self refreshCurrentListDictWithPid:dirPid];
    self.operatingDirID = dirID;
    self.operatingDirToPid = parentID;
    
    NSString *reqest = [NSString stringWithFormat:@"%@&token=%@&dir_id=%@&new_name=%@&to_parent_id=%@",MoveDirToAnotherDir,token,dirID,newName,parentID];
    
    //    发送移动目录请求
    [[HttpEngine shareInstance]postMethodHttpRequest:[NSURL URLWithString:reqest] 
                                             andHead:nil 
                                             andBody:nil 
                                             andType:VDISK_MOVEDIR 
                                         andDelegate:self];
}

-(void)refreshCurrentListDictWithPid:(NSString *)dirPid
{
    m_listPid =dirPid;
    NSMutableArray *listArr =[[NSMutableArray alloc]init];
    ListData *list;
    for(int i=0;i<[keepListarr count];i++){
        list =[keepListarr objectAtIndex:i];
        
        if([list.weipanPid isEqualToString:dirPid]){
            [self.listDict removeAllObjects];
            [listArr addObject:list];
        }
    }
    [self.listDict setObject:listArr forKey:@"list"];
    [listArr release];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UPLOAD_KEY_END object:nil];
    [keepListarr release];
    [operatingDirID release];
    [operatingDirToPid release];
    [operatingDirPid release];
    [operatingDirName release];
    [super dealloc];
}

@end
