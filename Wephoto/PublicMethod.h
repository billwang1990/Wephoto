//
//  PublicMethod.h
//  Wephoto
//
//  Created by xyhh on 13-3-22.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicMethod : NSObject
/*********************************************************************
 函数名称 : changeTime
 函数描述 : 时间与时间戳的转化
 参数 : time
 返回值 : confromTimeStr
 作者 : 朱冬蕾
 *********************************************************************/
+(NSString *)changeTime:(NSString*)time;
@end
