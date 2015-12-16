//
//  ViewController.m
//  火车售票
//
//  Created by Ibokan on 15/11/4.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSInteger _ticket;
    
    //自定义锁
    NSLock* _mLock;
}

@property(nonatomic,assign)NSInteger ticker;
@property(atomic,strong)NSObject * obj;
@end

@implementation ViewController
@synthesize  ticker=_ticket,obj=_obj;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mLock=[NSLock new];
    _ticket=20;

}
-(NSObject*)obj
{
    return _obj;
}

//属性atomic关键字的内部实现
-(void)setObj:(NSObject *)obj
{
    @synchronized(self){
        
    }
}

-(void)seleTicket{
    
    while (YES) {
        [NSThread sleepForTimeInterval:0.5];
//        NSObject* obj=[NSObject new];
        
        //用一个访问锁，锁定访问
        //不会自动补全
        
//       加锁，其他线程无法访问
        [_mLock lock];
        
        //模拟锁
//        @synchronized(obj){
            //询问是否有票
            if (_ticket>0) {
                _ticket--;
                NSLog(@"剩余票数：%lu  %@",_ticket,[NSThread currentThread]);
                
                }
            else {
                //如果没有票了
                NSLog(@"No ticker %@",[NSThread currentThread]);break;
                }

//        }
        //解锁
        [_mLock unlock];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    NSThread* thread1=[[NSThread alloc]initWithTarget:self selector:@selector(seleTicket) object:nil];
    thread1.name=@"售票窗口1";
    NSThread* thread2=[[NSThread alloc]initWithTarget:self selector:@selector(seleTicket) object:nil];
    thread2.name=@"售票窗口2";
    [thread1 start];
    [thread2 start];
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
