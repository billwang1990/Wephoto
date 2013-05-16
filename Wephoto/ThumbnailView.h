//
//  ThumbnailView.h
//  Wephoto
//
//  Created by xyhh on 13-3-27.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//
#import "REPhotoThumbnailView.h"

@interface ThumbnailView : REPhotoThumbnailView {
    EGOImageButton *imageButton;
}

- (void)setPhoto:(NSObject <REPhotoObjectProtocol> *)photo;

@end
