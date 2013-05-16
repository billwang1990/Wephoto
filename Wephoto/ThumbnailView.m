//
//  ThumbnailView.m
//  Wephoto
//
//  Created by xyhh on 13-3-27.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import "ThumbnailView.h"

@implementation ThumbnailView

- (void)setPhoto:(NSObject <REPhotoObjectProtocol> *)photo
{
    if (photo.thumbnailURL) {
        imageButton.imageURL = photo.thumbnailURL;
    } else {
        [imageButton setImage:photo.thumbnail forState:UIControlStateNormal];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageButton = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
        imageButton.frame = CGRectMake(1, 1, self.frame.size.width - 2, self.frame.size.height - 2);
        [self addSubview:imageButton];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
