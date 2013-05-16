//
//  ListData.m
//  VDisk
//
//  Created by 朱冬蕾 on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListData.h"

@implementation ListData
@synthesize weipanID=m_weipanID;
@synthesize weipanMd5=m_weipanMd5;
@synthesize weipanByte=m_weipanByte;
@synthesize weipanCtime=m_weipanCtime;
@synthesize weipanUrl=m_weipanUrl;
@synthesize weipanName=m_weipanName;
@synthesize weipanSize=m_weipanSize;
@synthesize weipanType=m_weipanType;
@synthesize weipanFile_num=m_weipanFile_num;
@synthesize weipanItime=m_weipanItime;
@synthesize weipansha1 =m_weipansha1;
@synthesize weipanShare=m_weipanShare;
@synthesize weipanDir_ID=m_weipanDir_ID;
@synthesize weipanLength=m_weipanLength;
@synthesize weipanThumbnail=m_weipanThumbnail;
@synthesize weipanFid=m_weipanFid;
@synthesize weipanUid=m_weipanUid;
@synthesize isSelected =m_isSelected;
@synthesize weipanPid =m_weipanPid;



- (void)dealloc {
    [m_weipanID release];
    [m_weipanByte release];
    [m_weipanCtime release];
    [m_weipanDir_ID release];
    [m_weipanItime release];
    [m_weipanLength release];
    [m_weipanMd5 release];
    [m_weipanName release];
    [m_weipansha1 release];
    [m_weipanShare release];
    [m_weipanSize release];
    [m_weipanThumbnail release];
    [m_weipanType release];
    [m_weipanUrl release];
    [m_weipanUid release];
    [m_weipanFid release];
    [m_weipanPid release];
   
       [super dealloc];
}

@end
