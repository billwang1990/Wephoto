//
//  Photo.m
//  Wephoto
//
//  Created by xyhh on 13-3-27.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize thumbnailURL = _thumbnailURL, date = _date, thumbnail = _thumbnail;

- (id)initWithThumbnailURL:(NSURL *)thumbnailURL date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _thumbnailURL = thumbnailURL;
        _date = date;
    }
    return self;
}

+ (Photo *)photoWithURLString:(NSString *)urlString date:(NSDate *)date
{
    return [[Photo alloc] initWithThumbnailURL:[NSURL URLWithString:urlString] date:date];
}

@end
