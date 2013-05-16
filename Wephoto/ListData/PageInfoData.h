//
//  PageInfoData.h
//  VDisk
//
//  Created by 朱冬蕾 on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageInfoData : NSObject
{
    NSNumber* m_page;         //当前页码
    NSNumber* m_pageSize;     //每页行数
    NSNumber* m_rstotal;      //文件总数
    NSNumber* m_pageTotal;    //文件页数
    
}
@property(retain,nonatomic)NSNumber* page;
@property(retain,nonatomic)NSNumber* pageSize;
@property(retain,nonatomic)NSNumber* rstotal;
@property(retain,nonatomic)NSNumber* pageTotal;
@end
