//
//  ViewController.m
//  多线程
//
//  Created by Ibokan on 15/11/4.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSThread* _thread;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* stopBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopBtn.frame=CGRectMake(100, 100, 100, 40);
    [stopBtn  setTitle:@"Stop" forState:UIControlStateNormal];
    [stopBtn addTarget:self  action:@selector(stopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)stopBtn:(UIButton*)btn{
//    NSThread* cThread=[NSThread currentThread];
    //询问是否取消，没有就取消
     
        [_thread cancel];
    
}
//用方能指针传参数，因为线程参数不确定
-(void)task:(id)sender{
    for (int i=0; i<1000; i++) {
        if([_thread isCancelled]){
            [_thread cancel];
            
            break;
        }
        NSLog(@"%d,%@,%@",i,[NSThread currentThread],sender);
        //设定睡眠时长,默认是当前进程
        [NSThread sleepForTimeInterval:0.01];//秒
//        //定得时间段
//        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        
      
    
    }

}
-(void)createThree{
    //默认start之后，调用主线程
      NSInvocationOperation* IO=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(task:) object:@"Invocation"];
    [IO start];
    
}

-(void)sleep{
    //设定睡眠时长
    [NSThread sleepForTimeInterval:1];//秒
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self createTwo];
//    [self createFour];
    
    
}

-(void)createOne{
    //开辟新线程，
    
    [NSThread detachNewThreadSelector:@selector(task:) toTarget:self withObject:@"detach"];
}
//线程2
-(void)createTwo{
     _thread=[[NSThread alloc]initWithTarget:self selector:@selector(task:) object:@"Alloc"];
    [_thread start];
    
}
-(void)createFour{
    NSInvocationOperation* io1=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(task:) object:@"queue"];
    NSInvocationOperation* io2=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(task:) object:@"queue2"];
    NSOperationQueue* queue=[[NSOperationQueue alloc]init];
    //设置最大并发数(却大线程数)
    [queue setMaxConcurrentOperationCount:2];
    [queue addOperation:io1];
    [queue addOperation:io2];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
