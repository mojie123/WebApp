//
//  ViewController.m
//  WebApp
//
//  Created by Ibokan on 15/11/3.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "ViewController.h"
#import "ActivityView.h"
#import "DBConnect.h"
#import "BookMarkViewController.h"

@interface ViewController ()<UITextFieldDelegate,UIWebViewDelegate,bookMarkDelegate>
{
    

    UIWebView * _webV;  //网页View
    UIView * _naviV;    //顶部View
    UITextField * _addressTF;//地址输入框
    ActivityView * _acV;//小菊花
    //    当历史记录足够大的时候,historyARR所占内存过大,会导致APP占大内存。
    //    NSMutableArray * historyARR;
    //    NSMutableArray * bookMarkARR;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  导航控制器(navigationBar)高度,44,StatusBar 20  相加为64.
    
    //    设置顶部视图
    _naviV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 64)];
    
    
    _naviV.backgroundColor = [UIColor colorWithRed:0.4 green:0.9 blue:0.4 alpha:1];
    
    
    //    地址栏
    
    _addressTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, 275, 30)];
    _addressTF.borderStyle = UITextBorderStyleLine;
    _addressTF.backgroundColor = [UIColor whiteColor];
    
    _addressTF.font = [UIFont systemFontOfSize:17.0];
    
    _addressTF.returnKeyType = UIReturnKeyGo;//改变键盘return值
    
    _addressTF.keyboardType = UIKeyboardTypeURL;
    
    _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _addressTF.delegate = self;
    
    [_naviV addSubview:_addressTF];
    //    按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelBtn.frame = CGRectMake(300, 30, 60, 30);
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_naviV addSubview:cancelBtn];
    [self.view addSubview:_naviV];
    
    
    //网页显示
    _webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 375, 667-64-44)];
    
    _webV.delegate = self;
    
    [self.view addSubview:_webV];
    
    
    //小菊花
    _acV = [[ActivityView alloc] initWithFrame:_webV.frame];
    [self.view addSubview:_acV];
    [_acV hidden];
    
    //手势，左右
    UISwipeGestureRecognizer * forwardGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forwardAction:)];
    forwardGes.direction = UISwipeGestureRecognizerDirectionLeft;//向左滑前进
    
    UISwipeGestureRecognizer * backGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    backGes.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_webV addGestureRecognizer:forwardGes];
    [_webV addGestureRecognizer:backGes];
    
    [self initToolBar];
}
//toolbar
-(void)initToolBar
{
    
    
    UIToolbar * tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 667-44, 375, 44)];
    
    UIBarButtonItem * bookMarkBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookMarkBtnAction:)];
    UIBarButtonItem* lishi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(lishi:)];
    
    
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //    若选择flexible ,则width属性,无效果.
    space.width = 1000;
    
    UIBarButtonItem * addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnAction:)];
    
    
    UIBarButtonItem * nextBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(forwardAction:)];
    
    UIBarButtonItem * lastBtn =[[ UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backAction:)];
    
    
    
    tool.items = @[lastBtn,nextBtn,space,bookMarkBtn,space,lishi,space,addBtn];
    
    [self.view addSubview:tool];

}
 

-(void)addBtnAction:(UIBarButtonItem *)item
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加书签"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    
    
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alertView setDelegate:self];
    UITextField *tf = [alertView textFieldAtIndex:0];
    UITextField *ptf = [alertView textFieldAtIndex:1];
    ptf.secureTextEntry = NO;//设为YES则是密码框
    ptf.text = [_webV.request.URL absoluteString];
    
    ptf.placeholder = @"\"Http://...\"";//placeholder提示文字
    
#pragma mark  获取网页title
    tf.text = [_webV stringByEvaluatingJavaScriptFromString:@"document.title"];
    tf.placeholder = @"Website title";
    [alertView show];
}

#pragma mark 警告框代理方法，点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *tf,*ptf;
    switch (buttonIndex) {
        case 0:
            //取消
            break;
        case 1:
            //确定
            //            网页名校验
            tf = [alertView textFieldAtIndex:0];
            NSString *bookmarkName;
            if (tf.text.length == 0) {
                bookmarkName = [_webV stringByEvaluatingJavaScriptFromString:@"document.title"];
            } else {
                bookmarkName = tf.text;
            }
            //            网址校验
            ptf = [alertView textFieldAtIndex:1];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@",ptf.text];
            if (bookmarkName.length > 0 && urlStr.length > 0) {
               
                NSInteger result =[DBConnect insetBookMarkWith:@"webInfo" andTitle:bookmarkName andURLstr:urlStr];
                if (result == 1) {
                    NSLog(@"书签插入成功~~!!");
                }
                else
                {
                    NSLog(@"书签插入失败....");
                }
            }
            break;
    }
}


-(void)bookMarkBtnAction:(UIBarButtonItem *)item
{
    BookMarkViewController * bmVC = [[BookMarkViewController alloc] init];
    bmVC.name=@"webInfo";
    bmVC.delegate = self;
    UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:bmVC];
    [self presentViewController:naviCon animated:YES completion:nil];
    
}

-(void)lishi:(UIBarButtonItem*)item
{
    BookMarkViewController * bmVC = [[BookMarkViewController alloc] init];
    bmVC.name=@"webInfo2";
    bmVC.delegate = self;
    UINavigationController *naviCon = [[UINavigationController alloc] initWithRootViewController:bmVC];
    
    [self presentViewController:naviCon animated:YES completion:nil];
    
}





#pragma mark
-(void)getBookMarkURL:(NSString *)URL
{
    NSURL *url = [[NSURL alloc] initWithString:URL];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [_webV loadRequest:request];
    
    [_acV showWithText:@"loading.."];
}

#pragma mark 前进
-(void)forwardAction:(id)sender
{
    if ([_webV canGoForward]) {
        [_webV goForward];
        [_acV showWithText:@"前进.."];
    }
    
}

#pragma mark 后退
-(void)backAction:(id)sender
{
    if ([_webV canGoBack]) {
        [_webV goBack];
        [_acV showWithText:@"后退"];
    }
    
}


//取消网页加载按钮
-(void)cancelBtnAction:(UIButton *)sender
{
    [_addressTF resignFirstResponder];//隐藏键盘
    
    [_acV hidden];
    if (_webV.isLoading) {
        [_webV stopLoading];
    }
}

//对URL做处理.做补全   https://www.baidu.com
//   URL补全就可以看作 *逻辑*功能
-(NSString *)getURL:(NSString *)string
{
    NSString * str1 = [string substringWithRange:NSMakeRange(0, 7)];
    NSString * str2 = [string substringToIndex:8];
    
    if ([str1 isEqualToString:@"http://"]||[str2 isEqualToString:@"https://"])
    {
        return string;
    }
    else
    {
        NSString * str3 = [NSString stringWithFormat:@"http://%@",string];
        return str3;
    }
}
#pragma mark return按钮作为网址请求 触发按钮.
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];//收起键盘
    if (textField.text.length > 8)//www.*.cn
    {
        // 补全地址，调用getURL方法
        NSString * str =  [self getURL:_addressTF.text];
        NSURL * url = [NSURL URLWithString:str];
        
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        
        //跳转
        [_webV loadRequest:request];
        
        //        小菊花提示
        [_acV showWithText:@"加载中.."];
    }
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //加载开始的时候就加进历史记录
     NSString * urlStr = [NSString stringWithFormat:@"%@",webView.request.URL];
    NSString *bookmarkName  = [_webV stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [DBConnect insetBookMarkWith:@"webInfo2" andTitle:bookmarkName andURLstr:urlStr];
}
#pragma mark  加载完调用
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    webView会返回当前网址
    NSString * urlStr = [NSString stringWithFormat:@"%@",webView.request.URL];
    NSLog(@"%@",urlStr);
    _addressTF.text = urlStr;
    
    [_acV hidden];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
