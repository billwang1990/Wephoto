//
//  UpLoadManager.h
//  VDisk
//
//  Created by 戴安宁 on 12-9-19.
//  Copyright (c) 2012年 hoperun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "HttpEngine.h"
#import "AppDelegate.h"
//#import "PublecDefine.h"


@interface UpLoadManager :  NSObject<ASIHTTPRespondDelegate>{
    NSString *m_dir_id;
}
@property (nonatomic,assign) NSString *dir_id;

//获取实例
+ (UpLoadManager *)shareInstance;

//业务接口
//token: 动态令牌
//dir_id: 目录的id, 0为根目录
//cover: 重名时是否覆盖, yes或no
//file: 文件
//dologid: 参考dolog机制
- (void) postToken:(NSString *)token 
         andDir_id:(NSString *)dir_id 
          andCover:(NSString*)cover  
           andfile:(NSString*)filename
        andDologid:(NSString *)dologid
       andFileType:(NSString*)filetype
       andProgress:(UIProgressView*)myProgress
           andBody:(NSData *)body
;
@end


