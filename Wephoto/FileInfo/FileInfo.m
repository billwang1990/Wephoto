//
//  FileInfo.m
//  VDisk
//
//  Created by 陶万里 on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileInfo.h"

@implementation FileInfo
@synthesize fileUid = m_fileUid;
@synthesize fileS3Url = m_fileS3Url;
@synthesize fileH = m_fileH;
@synthesize fileW = m_fileW;
@synthesize fileIp= m_fileIp;
@synthesize fileHid = m_fileHid;
@synthesize fileDtime = m_fileDtime;
@synthesize fileRevId = m_fileRevId;
@synthesize fileAppKey = m_fileAppKey;
@synthesize fileSource = m_fileSource;
@synthesize fileStatus = m_fileStatus;
@synthesize fileIsLocked = m_fileIsLocked;
@synthesize fileShare = m_fileShare;

- (void)dealloc{
    [m_fileUid release];
    [m_fileS3Url release];
    [m_fileDtime release];
    [m_fileIsLocked release];
    [m_fileStatus release];
    [m_fileSource release];
    [m_fileAppKey release];
    [m_fileRevId release];
    [m_fileHid release];
    [m_fileIp release];
    [m_fileW release];
    [m_fileH release];
    [super dealloc];
}

@end
