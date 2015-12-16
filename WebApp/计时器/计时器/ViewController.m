//
//  ViewController.m
//  计时器
//
//  Created by Ibokan on 15/11/5.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "ViewController.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define btnWidth ([UIScreen mainScreen].bounds.size.width-40)/2
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    //按钮
    UIButton* start;
    UIButton* stop;
    UIButton* chongzhi;
    UIButton* jishi;
    
    //显示计时
    UILabel* _label;
   
    
    NSThread* _thread;//计时线程
    //记录分钟和秒数
    NSInteger fenzhong;
    CGFloat miao;
    //用来储存tabelView的数据
    NSMutableArray* arr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr=[[NSMutableArray alloc]init];
    
    
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, Height/2)];
    view.backgroundColor=[UIColor colorWithRed:0.3 green:0.8 blue:0.3 alpha:1];
    [self.view addSubview:view];
    
   
    _label=[UILabel new];
    _label.frame=CGRectMake(Width/2-45, Height/2-140, 140, 30);
    _label.text=@"00:00.0";
    _label.font=[UIFont systemFontOfSize:30];
    _label.textColor=[UIColor blackColor];
    [self.view addSubview:_label];

    [self button];//按钮
    
    
    UIScrollView* scr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, Height/2+5, Width, Height/2-65)];
    scr.contentSize=CGSizeMake(Width, Height/2);
    [self.view addSubview:scr];
    
    UITableView* tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height/2) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.tag=1000;
    tableView.dataSource=self;
    [scr addSubview:tableView];
    
    
    
    
}
#pragma mark tableView代理方法
#pragma mark 分几段
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
#pragma mark 每段行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=[arr objectAtIndex:arr.count-indexPath.row-1];
    NSLog(@"text:%@",cell.textLabel.text);
    return cell;
}






#pragma mark 按钮创建
-(void)button{
    start=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    start.frame=CGRectMake(20,Height-60, btnWidth*2, 40);
    [start setTitle:@"开始" forState:UIControlStateNormal];
    start.layer.borderWidth = 0.3;
    start.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [start addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    stop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    stop.frame=CGRectMake(20,Height-60, btnWidth, 40);
    stop.layer.borderWidth = 0.3;
    stop.alpha=0;
    stop.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [stop setTitle:@"暂停" forState:UIControlStateNormal];
    [stop addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop];
    
    jishi=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    jishi.frame=CGRectMake(20+btnWidth,Height-60, btnWidth, 40);
    jishi.alpha=0;
    jishi.layer.borderWidth = 0.3;
    jishi.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [jishi setTitle:@"计时" forState:UIControlStateNormal];
    [jishi addTarget:self action:@selector(jishiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jishi];
    
    
    chongzhi=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    chongzhi.frame=CGRectMake(20+btnWidth,Height-60, btnWidth, 40);
    chongzhi.layer.borderWidth = 0.3;
    chongzhi.alpha=0;
    chongzhi.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [chongzhi setTitle:@"重置" forState:UIControlStateNormal];
    [chongzhi addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chongzhi];
    
}




#pragma mark 开始按钮
-(void)startAction{
    start.alpha=0;
    chongzhi.alpha=0;
    stop.alpha=1;
    jishi.alpha=1;
    
    
    _thread=[[NSThread alloc]initWithTarget:self selector:@selector(task:) object:@"Alloc"];
    [_thread start];
    
    
    
}

#pragma mark 停止按钮
-(void)stopAction{
    stop.alpha=0;
    jishi.alpha=0;
    start.alpha=1;
    chongzhi.alpha=1;
    
    
    [_thread cancel];
    start.frame=stop.frame;
    
    
}
#pragma mark 计时按钮
-(void)jishiAction{
    
   
    [arr addObject:_label.text];
    
    
    UITableView* tableView=(UITableView*)[self.view viewWithTag:1000];
    [tableView reloadData];
    
    //刷新tableView
    //    [tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark 重置按钮
-(void)chongzhiAction{
    miao=0;
    fenzhong=0;
    chongzhi.alpha=0;
    start.alpha=1;
    
    
    [_thread cancel];
    _label.text=@"00:00.0";
   
    start.frame=CGRectMake(20,Height-60, btnWidth*2, 40);
    [arr removeAllObjects];
    UITableView* tableView=(UITableView*)[self.view viewWithTag:1000];
    [tableView reloadData];
    
}




#pragma mark 开始计时
-(void)task:(id)sender{
    NSString* tem;
    NSString* tem1;
    for (int i=0; YES; i++) {
        miao+=0.1;
        if (miao>=59.900000) {
            fenzhong++;
            miao=0;
            NSLog(@"%f",miao);
        }
        
        //当秒小于10时，tem显示0+秒数
        if (miao<10) {
             tem=[NSString stringWithFormat:@"0%.1f",miao];
        }
        else{
            tem=[NSString stringWithFormat:@"%.1f",miao];
        }
        
        //当分钟小于10时，tem显示0+分钟数
        if (fenzhong<10) {
            tem1=[NSString stringWithFormat:@"0%lu",fenzhong];
            
        }else{
            tem1=[NSString stringWithFormat:@"%lu",fenzhong];
        }
        
        
        NSString* string=[NSString stringWithFormat:@"%@:%@",tem1,tem];
        //更新UI层
        [self performSelectorOnMainThread:@selector(labelAction:) withObject:string waitUntilDone:NO];
        
//        NSThread* thread=[[NSThread alloc]initWithTarget:self selector:@selector(labelAction:) object:string];
//        [thread start];
        //设置当前线程0.1执行一次
        [NSThread sleepForTimeInterval:0.1];//秒
        //判断是否要暂停
        if([_thread isCancelled]){
            [_thread cancel];
            
            break;
        }
   
    }

}
#pragma mark 重开一条线程用于_label.text的更新
-(void)labelAction:(NSString*)string{
     _label.text=string;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
