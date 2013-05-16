//
//  LoginViewController.h
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "GetListManager.h"
#import "FileManager.h"
#import "head.h"

@interface LoginViewController : UIViewController<LoginViewDelegate>
{
    LoginView *m_LoginView;
}
-(void)loginViewSuccess:(NSString *)token;

@end
