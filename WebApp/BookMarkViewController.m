//
//  BookMarkViewController.m
//  UI_11
//
//  Created by Vincent on 15/11/3.
//  Copyright (c) 2015年 Winfred. All rights reserved.
//

#import "BookMarkViewController.h"
#import "DBConnect.h"

@interface BookMarkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray * _allBookMark;
}

@end

@implementation BookMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //取得到所有数据
    _allBookMark = [DBConnect findAllBookMark:self.name];
    
    
    UIBarButtonItem * backBtn = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction:)];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    if([self.name isEqualToString:@"webInfo"]){
    self.title = @"书签";
    }
    if ([self.name isEqualToString:@"webInfo2"]) {
        self.title=@"历史";
    }
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    static NSString * idStr = @"bookMarkCell";
    cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idStr];
    }
    
    cell.textLabel.text = [_allBookMark[indexPath.row] objectForKey:@"title"];
    
    cell.detailTextLabel.text  = [_allBookMark[indexPath.row] objectForKey:@"website"];
    
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_allBookMark count];
}

//点击后，跳转到对应页面.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * bookMarkURL = [_allBookMark[indexPath.row] objectForKey:@"website"];
    
    [self.delegate getBookMarkURL:bookMarkURL];
    //    取消 模态视图 (因为上一个视图是ViewControllerpresent进来的,所以这里用dissViewController,而不用popVC)
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)backBtnAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        return;
    }
    
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //        调用删除方法。
        NSLog(@"点击了删除 indexpath(%lu,%lu)",indexPath.section,indexPath.row);
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction1.backgroundColor = [UIColor redColor];
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        //        调用置顶方法.
        [tableView setEditing:NO animated:YES];
    }];
    layTopRowAction2.backgroundColor = [UIColor greenColor];
    UITableViewRowAction *layTopRowAction3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了更多");
        
        [tableView setEditing:NO animated:YES];
        
    }];
    layTopRowAction3.backgroundColor = [UIColor blueColor];
    NSArray *arr = @[layTopRowAction1,layTopRowAction2,layTopRowAction3];
    return arr;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
