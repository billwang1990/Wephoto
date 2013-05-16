//
//  Profile.h
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@interface Profile : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    LoginViewController *m_LoginViewController;
}

@property (retain, nonatomic) IBOutlet UITableView *table;

@end
