//
//  LoginView.h
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import <UIKit/UIKit.h>

//代理方法
@protocol LoginViewDelegate <NSObject>

-(void)loginButtonAction;

@end

@interface LoginView : UIView<UITextFieldDelegate>
{
    
    id<LoginViewDelegate>m_delegate;
    UITextField *m_nameTextField;       //用户名输入框
    UITextField *m_passWordTextField;   //密码输入框
    UIButton *m_registrationButton;     //注册按钮
    UIButton *m_loginButton;            //登录按钮
    //验证用户名和密码弹出框
    UIAlertView *m_ArlertView;          //登录等待框
}
@property(retain,nonatomic)UITextField *m_nameTextField;
@property(retain,nonatomic) UITextField *m_passWordTextField;
@property(assign,nonatomic)id<LoginViewDelegate>m_delegate;
@property(retain,nonatomic)UIAlertView *arlertView;
    
-(void)didMissArlertview;
-(void)alertShow:(NSString *)message;

@end