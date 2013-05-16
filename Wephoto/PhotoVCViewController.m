//
//  PhotoVCViewController.m
//  Wephoto
//
//  Created by xyhh on 13-3-27.
//  Copyright (c) 2013年 bill wang. All rights reserved.
//

#import "PhotoVCViewController.h"
#import "REPhotoCollectionController.h"
#import "ThumbnailView.h"
#import "AppDelegate.h"
#import "Photo.h"
#import "SDWebImageRootViewController.h"
#import "GetListManager.h"
#import "LoginManager.h"

@interface PhotoVCViewController ()
@property (strong, nonatomic) SDWebImageRootViewController *sdimagevc;

@end

@implementation PhotoVCViewController
@synthesize photocollect;
@synthesize sdimagevc;

-(BOOL)respondsToSelector:(SEL)aSelector
{
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    return [dateFormat dateFromString:string];
}

- (NSMutableArray *)prepareDatasource
{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/5acf0f48d5ac11e1a3461231381315e1_5.jpg"
                                               date:[self dateFromString:@"05/01/2012"]]];
    return datasource;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Establish:) name:RCSGETLISTSUCCESS_MANAGER_NTF_CENTER object:nil];//更新列表
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newDataInfo:) name:RCS_OBTAIN_FILEINFO_MANAGER_NTF_CENTER object:@"collectionRequest"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoreload) name:RELOADPHOTO object:nil];
    return self;
}

-(void)refreshphoto
{
    
    [[GetListManager shareInstance]getListToken:[LoginManager shareInstance].token anddir_id:@"0" andpage:@"0" andpageSize:@"0" anddologid:nil];
    
    /*
    if([tmp_photos count])
    {
        int i ;
        for(i = 0; i < [tmp_photos count]; i++)
        {
            NSString *tmp = (NSString *)[tmp_photos objectAtIndex:i];
            [self.photocollect.datasource addObject:[Photo photoWithURLString:tmp date:[self dateFromString:@"06/10/2012"]]];
        }
        [self.photocollect reloadData];
        
        [tmp_photos removeAllObjects];
    
    }  
*/     
}

- (void)dealloc
{
    if(tmp_photos != nil)
    {
        [tmp_photos release];
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.photocollect = [[REPhotoCollectionController alloc] initWithDatasource:[self prepareDatasource]];
 
    // self.photocollect = [[REPhotoCollectionController alloc ]initself];
    
    tmp_photos = [[NSMutableArray alloc] init];
    
    self.photocollect.thumbnailViewClass = [ThumbnailView class];
    
    [self.photocollect reloadData];
    [self addChildViewController:self.photocollect];
    [self.view addSubview:self.photocollect.view];
    
    
    UIImage *image = [UIImage imageNamed:@"Icon"];
    CGRect frame = CGRectMake(0, 0, 28, 28);
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshphoto) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = btnSearch;
    [btn release];
    [btnSearch release];
    /*
    self.sdimagevc = [[[SDWebImageRootViewController alloc] init]autorelease];
    [self addChildViewController:self.sdimagevc];
    [self.view addSubview:self.sdimagevc.view];
   */

 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*********************************************************************
 函数名称 : Establish:
 函数描述 :业务层通知触发方法 接收业务层的数据
 参数 :  nofity
 
 *********************************************************************/
-(void)Establish:(NSNotification *)nofity
{
    //如果进入文件夹  接收数据  加载文件夹内部文件
    NSDictionary *dataInfo = [nofity userInfo];
    NSMutableArray *m_dataArray = [dataInfo objectForKey:@"list"];
    
    int count = [m_dataArray count];
    NSLog(@"%d",count);
    
    int index;
    
    ListData *listdata;
    NSMutableArray *fileid_array = [[[NSMutableArray alloc]init]autorelease];
    
    //AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for(index = 0;index < count; index++)
    {
        listdata = [m_dataArray objectAtIndex:index];
        if([(NSString*)listdata.weipanType isEqualToString:@"image/jpeg"])
        {
            [fileid_array  addObject:listdata.weipanID];
            
            NSString *tmp = (NSString *)listdata.weipanThumbnail;
            
            [self.photocollect.datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/c0039594b74011e181bd12313817987b_5.jpg" date:[self dateFromString:@"06/10/2012"]]];
            
            //[tmp_photos addObject:tmp];
            //发送请求根据文件id获取文件信息的通知
            //[[ObtainFileInfoManager shareInstance]getFileInfoToken:[LoginManager shareInstance].token andFid:listdata.weipanID andRuquestBody:@"collectionRequest" andDologid:appDelegate.dologid];
        }

    }
    [self.photocollect reloadData];
    
}

-(void)newDataInfo:(NSNotification *)notify
{
    NSDictionary *userInfo = [notify userInfo];
    
    if ([[notify object]isEqualToString:@"collectionRequest"]) {
        FileInfo *fileinfo;
        fileinfo = [[userInfo objectForKey:@"jsonData"] objectForKey:@"jsonData"];
        //fileinfo.weipanUrl;    //向GetListManager传递参数去获取文件的列表
       // [[GetListManager shareInstance]getListToken:[LoginManager shareInstance].token anddir_id:@"0" andpage:@"0" andpageSize:@"0" anddologid:nil];
    }
    
}


@end
