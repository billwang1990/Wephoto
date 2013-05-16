//
//  FileInfo.h
//  VDisk
//
//  Created by 陶万里 on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListData.h"

@interface FileInfo : ListData{
    NSString *m_fileUid;     
    NSString *m_fileDtime;
    NSString *m_fileIsLocked;
    NSString *m_fileW;
    NSString *m_fileH;
    NSString *m_fileHid;
    NSString *m_fileStatus;
    NSString *m_fileAppKey;
    NSString *m_fileSource;
    NSString *m_fileIp;
    NSString *m_fileRevId;
    NSNumber *m_fileShare;
    NSString *m_fileS3Url;            // 下载地址
}

@property(retain,nonatomic)NSString  *fileUid;
@property(retain,nonatomic)NSString  *fileDtime;
@property(retain,nonatomic)NSString  *fileIsLocked;
@property(retain,nonatomic)NSString  *fileW;
@property(retain,nonatomic)NSString  *fileH;
@property(retain,nonatomic)NSString  *fileHid;
@property(retain,nonatomic)NSString  *fileStatus;
@property(retain,nonatomic)NSString  *fileAppKey;
@property(retain,nonatomic)NSString  *fileSource;
@property(retain,nonatomic)NSString  *fileIp;
@property(retain,nonatomic)NSString  *fileRevId;
@property(assign,nonatomic)NSNumber  *fileShare;
@property(retain,nonatomic)NSString  *fileS3Url;     // 下载地址


@end
