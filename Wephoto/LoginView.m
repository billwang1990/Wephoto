//
//  LoginView.m
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
@synthesize m_delegate;
@synthesize m_nameTextField=m_nameTextField;
@synthesize m_passWordTextField=m_passWordTextField;
@synthesize arlertView = m_ArlertView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        // Do any additional setup after loading the view, typically from a nib.
        
        //大的输入帐号背景，用一个button代替，禁用button点击事件
        UIButton *nameButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        nameButton.frame=CGRectMake(10, 55, 300, 45);
        nameButton.enabled=NO;
        [self addSubview:nameButton];
        
        //帐号label
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 40, 15)];
        nameLabel.text=@"帐 号";
        [nameButton addSubview:nameLabel];
        [nameLabel release];
        
        //大的输入密码背景，用一个button代替，禁用button点击事件
        UIButton *passWordButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        passWordButton.frame=CGRectMake(10, 110, 300, 45);
        passWordButton.enabled=NO;
        [self addSubview:passWordButton];
        
        //密码label
        UILabel *passLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 40, 15)];
        passLabel.text=@"密 码";
        [passWordButton addSubview:passLabel];
        [passLabel release];
        
        //帐号输入框
        m_nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(75, 67, 200, 20)];
        m_nameTextField.placeholder=@"新浪微搏帐号";
        //测试用，方便输入
        m_nameTextField.text=@"15902855952";
        m_nameTextField.delegate=self;
        [self addSubview:m_nameTextField];
        
        //密码输入框
        m_passWordTextField=[[UITextField alloc]initWithFrame:CGRectMake(75, 122, 200, 20)];
        m_passWordTextField.placeholder=@"新浪微搏密码";
        //测试用，方便输入
        m_passWordTextField.text=@"woxingwang3";
        m_passWordTextField.delegate=self;
        m_passWordTextField.secureTextEntry =YES;// 输入密码时变为点
        [self addSubview:m_passWordTextField];
        
        
        //注册按钮
        m_registrationButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        m_registrationButton.frame=CGRectMake(20, 165, 130, 40);
        [m_registrationButton setImage:[UIImage imageNamed:@"registration"] forState:UIControlStateNormal];
        [m_registrationButton addTarget:self action:@selector(registrationButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_registrationButton];
        
        //登录按钮
        m_loginButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        m_loginButton.frame=CGRectMake(170, 165, 130, 40);
        [m_loginButton setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        [m_loginButton addTarget:self action:@selector(loginButtonClick:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:m_loginButton];
        
        m_ArlertView =[[UIAlertView alloc]initWithTitle:@"正在登录"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles: nil];
        //等待旋转圆圈
        UIActivityIndicatorView *activiety =[[UIActivityIndicatorView alloc]
                                             initWithFrame:CGRectMake(120, 50, 50, 50)];
        //样式
        activiety.activityIndicatorViewStyle =UIActivityIndicatorViewStyleWhiteLarge;
        [activiety startAnimating];
        activiety.hidesWhenStopped=YES;//停止的时候隐藏
        //  [self addSubview:activiety];
        [m_ArlertView addSubview:activiety];
        [activiety release];
    }
    return self;
}
/*********************************************************************
 函数名称 : registrationButtonClick
 函数描述 : 注册按钮点击事件
 参数 : N/A
 返回值 : N/A
 *********************************************************************/
-(void)registrationButtonClick{
    //跳转到，浏览器，打开注册页面
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.cn/dpool/ttt/h5/reg.php"]];
}

/*********************************************************************
 函数名称 : loginButtonClick
 函数描述 : 登录按钮点击事件
 参数 : N/A
 返回值 : N/A
 *********************************************************************/
-(void)loginButtonClick:(id)sender withEvent:(UIEvent*)event{
    UITouch* touch = [[event allTouches] anyObject];
    if (touch.tapCount == 1) {
        //TODO........
        //判断用户名是否复合要求
        //判断用户名不能为空
        if (m_nameTextField.text.length==0) {
            [self alertShow:@"用户名不能为空"];
            return;
        }
        //判断密码是否复合要求
        //判断密码不能为空
        if (m_passWordTextField.text.length==0) {
            [self alertShow:@"密码不能为空"];
            return;
        }
        //判断密码长度不能小于4位
        else if (m_passWordTextField.text.length<4  ) {
            [self alertShow:@"密码长度不能小于4位"];
            return;
        }
        else{
            [m_ArlertView show];
            
            if (m_delegate) {
                [m_delegate loginButtonAction]; //登录代理
            }
        }
    }
}

-(void)didMissArlertview{
    
    [m_ArlertView dismissWithClickedButtonIndex:0 animated:YES];
    
}
-(void)alertShow:(NSString *)message{
    
    
    UIAlertView *m_TextAlert = [[UIAlertView alloc] initWithTitle:@""
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    [m_TextAlert show];
    [m_TextAlert release];
    
}

-(void)dealloc{
    
    [m_ArlertView release];
    [m_nameTextField release];
    [m_passWordTextField release];
    [super dealloc];
}

@end
