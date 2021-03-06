//
//  Photo.h
//  Wephoto
//
//  Created by xyhh on 13-3-27.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REPhotoObjectProtocol.h"

@interface Photo : NSObject <REPhotoObjectProtocol>

@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSDate *date;

- (id)initWithThumbnailURL:(NSURL *)thumbnailURL date:(NSDate *)date;
+ (Photo *)photoWithURLString:(NSString *)urlString date:(NSDate *)date;

@end
