//
//  PublicMethod.m
//  Wephoto
//
//  Created by xyhh on 13-3-22.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import "PublicMethod.h"

@implementation PublicMethod

/*********************************************************************
 函数名称 : changeTime
 函数描述 : 时间与时间戳的转化
 参数 : time
 返回值 : confromTimeStr
 作者 : 朱冬蕾
 *********************************************************************/
+(NSString *)changeTime:(NSString*)time{
    int timer = [time intValue];
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone *timezone =[NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timezone];
    NSDate *comfromTimeSp =[NSDate dateWithTimeIntervalSince1970:timer];
    NSString *confromTimeStr =[formatter stringFromDate:comfromTimeSp];
    [formatter release];
    return confromTimeStr;
}

@end
