/********************************************************************
 文件名称 : ASIPublicDefine.h 文件
 作 者 : wei_hangtian
 创建时间 : 2012-09-12
 文件描述 : 接口类型定义
 *********************************************************************/

#ifndef VDisk_ASIPublicDefine_h
#define VDisk_ASIPublicDefine_h

typedef enum 
{
    VDISK_KEEPSYN                        = 0x100,   //保持同步
    VDISK_GETTOKEN                       = 0x101,   //获得token
    VDISK_KEEPTOKEN                      = 0x102,   //保持token
    VDISK_UPLOADFILE                     = 0x103,   //文件上传（10M以下）
    VDISK_UPLOADFILEANDSHARE             = 0x103,  //上传文件并分享（10M以下）
    VDISK_CREATEDIR                      = 0x104,  //创建目录
    VDISK_GETLIST                        = 0x105,  //获得列表
    VDISK_GETCAPACITYINFO                = 0x106,  //获得容量信息
    VDISK_UPLOADWITHSHA1                 = 0x107,  //无文件上传（sha1）
    VDISK_GETFILEINFO                    = 0x108,  //获得单个文件信息
    VDISK_DELETEDIR                      = 0x109,  //删除目录
    VDISK_DELETEFILE                     = 0x10a,  //删除文件
    VDISK_COPYFILE                       = 0x10b,  //复制文件
    VDISK_MOVEFILE                       = 0x10c,  //移动文件
    VDISK_RENAMEFILE                     = 0x10d,  //文件重命名
    VDISK_RENAMEDIR                      = 0x10e,  //目录重命名
    VDISK_MOVEDIR                        = 0x10f,  //移动目录
    VDISK_SHAREFILE                      = 0x110,  //分享文件
    VDISK_CANCLESHAREFILE                = 0x111,  //取消分享
    VDISK_GETRECYCLELIST                 = 0x112,  //获得回收站列表
    VDISK_CLEARRECYCLE                   = 0x113,  //清空回收站
    VDISK_DELETEFILEFROMRECYCLE          = 0x114,  //从回收站彻底删除一个文件
    VDISK_DELETEDIRFROMRECYCLE           = 0x115,  //从回收站彻底删除一个目录
    VDISK_RESTOREFILEFROMRECYCLE         = 0x116,  //从回收站还原一个文件
    VDISK_RESTOREDIRFROMRECYCLE          = 0x117,  //从回收站还原一个目录
    VDISK_GETDIRIDWITHPATH               = 0x118,  //通过路径得到目录id
    VDISK_DOLOGID                        = 0x119,  //dologid机制
    VDISK_DOWNLOADFILE                   = 0x11a,  //文件下载
}RequestType;

#endif
