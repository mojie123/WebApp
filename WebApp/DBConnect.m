//
//  DBConnect.m
//  WebApp
//
//  Created by Ibokan on 15/11/4.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import "DBConnect.h"

@implementation DBConnect
//数据库文件位置
static sqlite3 * dbPoint;
+(sqlite3*)openDataBase:(NSString*)title
{

    //避免重复打开数据库；
    if (dbPoint) {
        return dbPoint;
    }
    NSString * sourcePath = [DBConnect sourcePath:title];
    NSString * targetPath = [DBConnect  targetFilePath:title];
    //文件管理对象。
    NSFileManager* fileManager = [NSFileManager defaultManager];
    //询问文件是否存在，
    if (![fileManager fileExistsAtPath:targetPath]) {
        NSError* err=nil;//用于打印错误信息
        //如果不存在，则复制数据库文件
        if(![fileManager copyItemAtPath:sourcePath toPath:targetPath error:nil]){
            NSLog(@"open data base error %@",[err localizedDescription]);
            return nil;
        }
    }
   
    //打开数据库文件
    sqlite3_open([targetPath UTF8String], &dbPoint);
    
    return dbPoint;
}
+(NSString*)sourcePath:(NSString*)title{
    
    return [[NSBundle mainBundle]pathForResource:title ofType:@"sqlite"];
}

#pragma mark 把数据库写进沙盒中
+(NSString*)targetFilePath:(NSString*)title{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* name=[NSString stringWithFormat:@"%@.sqlite",title];
    return [path stringByAppendingPathComponent:name];
}
#pragma mark 关闭数据库
+(void)closeDataBase
{
    if (dbPoint) {
        sqlite3_close(dbPoint);
        dbPoint = nil;
        NSLog(@"data base is closed.");
    }
    
}
#pragma mark 获得所有数据
+(NSArray*)findAllBookMark:(NSString*)title;
{
    
    //打开数据库
    sqlite3* db=[DBConnect openDataBase:title];
    sqlite3_stmt* stmt;
    //预加载数据库语句
    int resuly = sqlite3_prepare_v2(db, "select * from bookMark order by id desc", -1, &stmt, NULL);
    if (resuly == SQLITE_OK) {
        NSMutableArray* arr=[NSMutableArray new];
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            const unsigned char * hTitle = sqlite3_column_text(stmt, 1);
            const unsigned char * hWebsite = sqlite3_column_text(stmt,2);
            
            //用字典储存
            NSDictionary* history=@{@"title":[NSString stringWithUTF8String:(const char*)hTitle],@"website":[NSString stringWithUTF8String:(const char*)hWebsite] };
            [arr addObject:history];
        }
        sqlite3_finalize(stmt);
        [DBConnect closeDataBase];
        return arr;
    }
    else
    {
        sqlite3_finalize(stmt);
        [DBConnect closeDataBase];
        return nil;
    }
    
}

#pragma mark 插入数据

+(NSInteger)insetBookMarkWith:(NSString *)name andTitle:(NSString*)title andURLstr:(NSString *)URLstr
{
    NSInteger insertResult = 0;
    sqlite3 *db = [DBConnect openDataBase:name];
    sqlite3_stmt * stmt;
    NSString * sqlStr = [NSString stringWithFormat:@"insert into bookMark (title,website) values ('%@','%@')",title,URLstr];
    int result = sqlite3_prepare_v2(db,[sqlStr UTF8String] , -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        if (SQLITE_DONE == sqlite3_step(stmt)) {
            insertResult = 1;
        }
    }
    sqlite3_finalize(stmt);
    [DBConnect closeDataBase];
    return insertResult;
    
}






@end
