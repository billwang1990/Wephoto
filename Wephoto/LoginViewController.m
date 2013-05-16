//
//  LoginViewController.m
//  Wephoto
//
//  Created by xyhh on 13-3-21.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//
#import "LoginManager.h"
#import "LoginViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [super viewDidLoad];
        //加载视图
        m_LoginView=[[LoginView alloc]initWithFrame:self.view.bounds];
        m_LoginView.m_delegate=self;        //登录界面代理
        [self.view addSubview:m_LoginView];
        
        //注册接收登录成功的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(action:)
                                                     name:LOGIN_MANAGER_SUCCESS
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录视图的代理方法
-(void) loginButtonAction
{
    [[LoginManager shareInstance] login:m_LoginView.m_nameTextField.text andPassWord:m_LoginView.m_passWordTextField.text];
}


/*********************************************************************
 函数名称 : action
 函数描述 : 登录成功，接收通知
 参数 : (NSNotification*)
 返回值 : notify
 *********************************************************************/
-(void)action:(NSNotification*)notify
{
    
    [m_LoginView.arlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDictionary *dic=[notify userInfo];
    NSInteger errorcode =[[dic objectForKey:@"error"]intValue];
    
    NSLog(@"----------------%d",errorcode);
    UIAlertView *alertview =[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    switch (errorcode)
    {
        case 0:
        {
            NSDictionary *jsonData = [dic objectForKey:@"jsondata"];
            NSInteger err_code =[[jsonData objectForKey:@"err_code"]intValue];
   
            NSLog(@"%d",err_code);
            switch (err_code) {
                    //                        0: success.
                    //                        1: signature无效.
                    //                        2: account无效.
                    //                        3: time无效.
                    //                        701: 参数不全.
                    //                        900: 超出了请求限制
                case 0:
                {
                    NSString *token = [[jsonData objectForKey:@"data"] objectForKey:@"token"];
                     [self loginViewSuccess:token];//登录成功
                    //[[FileManager shareInstance]creatUsersFile:m_LoginView.m_nameTextField.text];
                    
                }
                    break;
                default:
                {
                    alertview.message=@"用户名或密码错误" ;
                    [alertview show];
                }
                    break;
            }
        }
            break;
        default:
        {
            alertview.message=@"网络链接错误，请检查网络链接" ;
            [alertview show];
        }
            break;
    }   
    [alertview release];
}


/*********************************************************************
 函数名称 : loginViewSuccess
 函数描述 : 登录成功
 参数 : N/A
 返回值 : N/A
 *********************************************************************/

-(void)loginViewSuccess:(NSString *)token
{
    [self.navigationController popViewControllerAnimated:YES];

    //向GetListManager传递参数去获取文件的列表
    //[[GetListManager shareInstance]getListToken:[LoginManager shareInstance].token anddir_id:@"0" andpage:@"0" andpageSize:@"0" anddologid:nil];

}
@end
