//
//  FileManager.m
//  VDisk
//
//  Created by 赵石 on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"
#import "GetListManager.h"
#import "ListData.h"

static FileManager *fileManager = nil;

@implementation FileManager
@synthesize userFilePath;
@synthesize fileRootPath;

+ (FileManager *)shareInstance
{
    @synchronized(self)
    {
        if (nil == fileManager)
        {
            fileManager = [[FileManager alloc] init];
            
        }
    }
    return fileManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        userNameStr = [[NSMutableString alloc]init];
    }
    return self;
}

/******************************************************************************
 函数名称 : creatUsersFile:
 函数描述 : 文件操作函数
 输入参数 : 用户名
 输出参数 : N/A
 返回值  : BOOL
 备  注 : 只有在登录成功以后进行调用，仅调用一次，创建用户目录
 作 者 : 赵 石
 ******************************************************************************/

-(void)creatUsersFile:(NSString *)userName 
{
    [userNameStr setString:userName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:[SYSTEM_ROOT_PATH stringByExpandingTildeInPath]];
    [fileManager createDirectoryAtPath:userNameStr withIntermediateDirectories:YES attributes:nil error:nil];
}
/******************************************************************************
 函数名称 : operationFile:
 函数描述 : 拼接路径，对文件操作
 输入参数 : 父级数组，列表数组，父文件ID，文件操作类型
 输出参数 : N/A
 返回值  : 无
 备  注 : 
 ******************************************************************************/
-(void)operationFile:(NSArray *)parentArray
             andList:(NSArray *)listArray
         andParentID:(NSString *)pID
           andFileID:(NSString *)fileId
           andToPath:(NSString *)toPath
         andFileType:(RequestType)fileType
{
    self.fileRootPath = [NSMutableString stringWithFormat:@"%@/%@",SYSTEM_ROOT_PATH,userNameStr];
    NSMutableString *filePath = [NSMutableString stringWithString:@""];
    NSString *parentId = pID;
    
    while (![parentId isEqualToString:@"0"]) {
        for (ListData *listData in parentArray) {
            if ([listData.weipanID isEqualToString:parentId]) {
                [filePath insertString:[NSString stringWithFormat:@"/%@",listData.weipanName] atIndex:0];
                parentId = listData.weipanPid;
                break;
            }
        }
    }
    self.userFilePath = [NSString stringWithFormat:@"%@%@",fileRootPath,filePath];
    if (nil == fileId && listArray !=nil) {
        for (ListData *listData in listArray) {
            if (nil == listData.weipanType ) {
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@/%@",filePath,listData.weipanName];
                NSMutableString *fileOperatPath =[NSMutableString stringWithString:fileRootPath];
                [fileOperatPath appendString:[NSString stringWithFormat:@"%@",str]];
                [self fileOperating:fileOperatPath toPath:toPath fileType:fileType];
            }
        }
    }else if(listArray !=nil){
        for (ListData *listData in listArray) {
            if ([listData.weipanID isEqualToString:fileId]) {
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@/%@",filePath,listData.weipanName];
                NSMutableString *fileOperatPath =[NSMutableString stringWithString:fileRootPath];
                [fileOperatPath appendString:[NSString stringWithFormat:@"%@",str]];
                [self fileOperating:fileOperatPath toPath:toPath fileType:fileType];
            }
        }

    }
}

/******************************************************************************
 函数名称 : fileOperating:
 函数描述 : 文件操作函数
 输入参数 : 路径名，目的路径，文件操作
 输出参数 : N/A
 返回值  : BOOL
 备  注 : 对文件进行创建、删除、复制操作
 作 者 : 赵 石
 ******************************************************************************/

-(BOOL)fileOperating:(NSString *)filePathName toPath:(NSString *)toPath fileType:(RequestType)fileType
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	switch (fileType) 
	{
        case VDISK_CREATEDIR: //创建文件夹
		case VDISK_GETLIST:   //创建列表
		{
			if ([fileManager fileExistsAtPath:filePathName])
				return YES;
			return [fileManager createDirectoryAtPath:filePathName withIntermediateDirectories:YES attributes:nil error:nil];
		}
        case VDISK_DELETEDIR:  //删除文件/文件夹
		{
			if (![fileManager fileExistsAtPath:filePathName])
				return YES;
			return [fileManager removeItemAtPath:filePathName error:nil];
		}
		case VDISK_COPYFILE:	//复制文件
		{
			if ((toPath == nil)&&(![fileManager fileExistsAtPath:filePathName])) 
				return NO;
			if ([fileManager fileExistsAtPath:toPath]) 
				return YES;
			return [fileManager copyItemAtPath:filePathName toPath:toPath error:nil];
		}
		case VDISK_MOVEDIR: //移动文件
		{
			if ((toPath == nil)&&(![fileManager fileExistsAtPath:filePathName])) 
				return NO;
			if ([fileManager fileExistsAtPath:toPath]) 
				return YES;
			return [fileManager moveItemAtPath:filePathName toPath:toPath error:nil]; 
		}	
		default:
			break;
	}
	return NO;
}

//
-(NSString *)getCurrentFileFrom
{
    return self.userFilePath;
}

-(void)dealloc
{
    [userNameStr release];
    [userFilePath release];
    [super dealloc];
}

@end
