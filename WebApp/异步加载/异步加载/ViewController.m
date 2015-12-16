//
//  ViewController.m
//  异步加载
//
//  Created by Ibokan on 15/11/5.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView* _imgV;
    UIImageView* _imgV1;
    UIImageView* _imgV2;
    UIImageView* _imgV3;
    int i;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    i=0;
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    [self createUI];
    
    
    
    
}


-(void)createUI{
   
    _imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 375, 240)];
    _imgV.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imgV];
    
    _imgV1=[[UIImageView alloc]initWithFrame:CGRectMake(0,320, 50, 50)];
    _imgV1.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imgV1];
    
    _imgV2=[[UIImageView alloc]initWithFrame:CGRectMake(80, 320,50, 50)];
    _imgV2.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imgV2];
    
    _imgV3=[[UIImageView alloc]initWithFrame:CGRectMake(190, 320,50, 50)];
    _imgV3.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imgV3];
    
    UIButton* loadBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    loadBtn.frame=CGRectMake(100, 630, 100, 60);
    [loadBtn setTitle:@"IMGload" forState:UIControlStateNormal];
    [loadBtn addTarget:self  action:@selector(loadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loadBtn];
    
}
-(void)loadBtnAction:(id)sender{
    NSString* picURL=@"http://ww1.sinaimg.cn/bmiddle/005Zu0d2jw1exp5dk3a5bj30dw0i5tc4.jpg";
    NSData* picData= [NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]];
    //主函数传入的参数
    [self performSelectorOnMainThread:@selector(updateImageWithData:) withObject:picData waitUntilDone:YES];
                      
                      
    
}
-(void)updateImageWithData:(NSData*)imageData
{
    _imgV.image = [UIImage imageWithData:imageData];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    
    [self loadImageWithThread1];
    
}
//利用线程异步加载
-(void)loadImageWithThread{

    NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ww4.sinaimg.cn/bmiddle/005Zu0d2jw1exp22gkrp4j30dw09o3zt.jpg"]];
    
    NSThread* thread = [[NSThread alloc]initWithTarget:self selector:@selector(updateImageWithDatas:) object:data];
    [thread start];
}
-(void)updateImageWithDatas:(NSData*)imageData
{
    _imgV1.image = [UIImage imageWithData:imageData];
}


-(void)loadImageWithThread1{
    NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ww4.sinaimg.cn/bmiddle/005Zu0d2jw1exp22gkrp4j30dw09o3zt.jpg"]];
    NSData* data1=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ww4.sinaimg.cn/bmiddle/005Zu0d2jw1exp22gkrp4j30dw09o3zt.jpg"]];
    NSData* data2=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ww4.sinaimg.cn/bmiddle/005Zu0d2jw1exp22gkrp4j30dw09o3zt.jpg"]];
    NSArray* arr=[NSArray arrayWithObjects:data,data1,data2,data, nil];
    
    if (i<arr.count) {
        NSThread* thread = [[NSThread alloc]initWithTarget:self selector:@selector(updateImageWithDatas1:) object:arr];
        [thread start];
      
    }
    
    
   
    
   
 
}
-(void)updateImageWithDatas1:(NSArray*)arr
{
    _imgV2=[[UIImageView alloc]initWithFrame:CGRectMake(80*i+20, 320,50, 50)];
    _imgV2.contentMode=UIViewContentModeScaleAspectFill;
    _imgV2.image = [UIImage imageWithData:arr[i]];
    [self.view addSubview:_imgV2];
      i++;
    [self loadImageWithThread1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
