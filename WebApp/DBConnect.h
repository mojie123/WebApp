//
//  DBConnect.h
//  WebApp
//
//  Created by Ibokan on 15/11/4.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBConnect : NSObject


@property(nonatomic,copy)NSString* title;

+(sqlite3*)openDataBase:(NSString*)title;

+(void)closeDataBase;

//返回数据库中所有对象
+(NSArray*)findAllBookMark:(NSString*)title;

//插入记录
+(NSInteger)insetBookMarkWith:(NSString *)name andTitle:(NSString*)title andURLstr:(NSString *)URLstr;


-(NSString*)sourcePath;
-(NSString*)targetFilePath;
@end
