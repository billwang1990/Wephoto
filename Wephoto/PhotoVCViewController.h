//
//  PhotoVCViewController.h
//  Wephoto
//
//  Created by xyhh on 13-3-27.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "head.h"
#import "ListData.h"
#import "ObtainFileInfoManager.h"
#import "LoginManager.h"

@class REPhotoCollectionController;

@interface PhotoVCViewController : UIViewController<UINavigationControllerDelegate>
{
 
    NSMutableArray *tmp_photos;
}

@property (nonatomic, strong) REPhotoCollectionController *photocollect;


@end
