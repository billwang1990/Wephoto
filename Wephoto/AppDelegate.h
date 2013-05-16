//
//  AppDelegate.h
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "head.h"

@class PhotoVCViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSString *_dologid;
    NSArray  *_dologdir;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabbar;
@property (strong, nonatomic) PhotoVCViewController *photo;
@property (strong, nonatomic) Profile   *profile;

@property (retain, nonatomic) NSString *dologid;
@property (retain, nonatomic) NSArray  *dologdir;

@end
