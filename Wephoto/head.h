//
//  head.h
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#ifndef Wephoto_head_h
#define Wephoto_head_h

#define LOGIN_APPKEY @"2973613270"                                 //appkey
#define LOGIN_APPSECRET @"16d679f0d13464e134a3407c0ac53070"        //appsecret

#define LOGIN_MANAGER_SUCCESS   @"longinManagerSuccess"   //登录成功

//获取token网址
#define LOGIN_GETTOKEN_URL      @"http://openapi.vdisk.me/?m=auth&a=get_token"
#define LOGIN_KEEPTOKEN_URL     @"http://openapi.vdisk.me/?m=user&a=keep_token"

#define LOGIN_MANAGER_SUCCESS   @"longinManagerSuccess"   //登录成功

#define dir_idisnonnexistent  2
#define beyondtime   900
#define invalid token  702
#define invalidparam  909
#define success  0

#define RCSGETLISTFAILED_MANAGER_NTF_CENTER         @"RCSGETLISTFAILED_MANAGER_NTF_CENTER"

#define RELOADPHOTO @"RELOADPHOTO"  

//获取列表的通知名
#define RCSGETLISTSUCCESS_MANAGER_NTF_CENTER   @"RCSGETLISTSUCCESS_MANAGER_NTF_CENTER"

#define  UPLOAD_KEY_URL @"http://openapi.vdisk.me/?m=file&a=upload_file"    //上传url

#define MoveDirToAnotherDir @"http://openapi.vdisk.me/?m=dir&a=move_dir"
#define CreatNewDir   @"http://openapi.vdisk.me/?m=dir&a=create_dir"
#define CreatNewDir   @"http://openapi.vdisk.me/?m=dir&a=create_dir"
#define DeleteDir     @"http://openapi.vdisk.me/?m=dir&a=delete_dir"
#define ReNameDir     @"http://openapi.vdisk.me/?m=dir&a=rename_dir"

//获取列表信息
#define Getlisturl    @"http://openapi.vdisk.me/?m=dir&a=getlist"
#define UPLOAD_KEY_BEGIN    @"UPLOADBEGIN"    //上传开始
#define UPLOAD_KEY_END      @"UPLOADEND"   //上传结束

#define CHANGE_FILE_MANAGER_NTF_CENTER              @"CHANGE_FILE_MANAGER_NTF_CENTER"
//获取单个文件信息
#define OBTAIN_FILEINFO_URL @"http://openapi.vdisk.me/?m=file&a=get_file_info"
#define RCS_OBTAIN_FILEINFO_MANAGER_NTF_CENTER @"RCS_OBTAIN_FILEINFO_MANAGER_NTF_CENTER"




#endif
