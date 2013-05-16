//
//  FileManager.h
//  VDisk
//
//  Created by 赵石 on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIPublicDefine.h"
#define SYSTEM_ROOT_PATH	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface FileManager : NSObject
{
    NSMutableString *userNameStr; //用户名
    NSString        *userFilePath;//当前文件目录
    
}
@property (nonatomic,retain) NSString        *userFilePath;
@property (nonatomic,retain) NSMutableString *fileRootPath;
//创建单例
+ (FileManager *)shareInstance;
//创建以用户名命名的文件夹
-(void)creatUsersFile:(NSString *)userName;
//获取操作的文件路径，类型
-(void)operationFile:(NSArray *)parentArray
             andList:(NSArray *)listArray
         andParentID:(NSString *)pID
           andFileID:(NSString *)fileId
           andToPath:(NSString *)toPath
         andFileType:(RequestType)fileType;
//对文件进行操作
-(BOOL)fileOperating:(NSString *)filePathName 
              toPath:(NSString *)toPath 
            fileType:(RequestType)iType;
//获取当前的文件目录
-(NSString *)getCurrentFileFrom;

@end
