//
//  ViewController.m
//  作业1
//
//  Created by Ibokan on 15/11/4.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
    
    NSLog(@"a主线程----%@",[NSThread mainThread]);

    dispatch_queue_t queue1=dispatch_queue_create("xxxx",NULL);
    //创建串行队列
    
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    
    //2.添加任务到队列中执行
    dispatch_async(queue1, ^{
        NSLog(@"a下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue1, ^{
        NSLog(@"a下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue1, ^{
        NSLog(@"a下载图片2----%@",[NSThread currentThread]);
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
