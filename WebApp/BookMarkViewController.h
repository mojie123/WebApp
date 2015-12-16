//
//  BookMarkViewController.h
//  WebApp
//
//  Created by Ibokan on 15/11/4.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import <UIKit/UIKit.h>

//协议传值
@protocol bookMarkDelegate <NSObject>

-(void)getBookMarkURL:(NSString *)URL;

@optional
-(void)getBookMark:(NSDictionary *)bookMark;


@end


@interface BookMarkViewController : UIViewController
@property(nonatomic,copy)NSString* name;
@property(nonatomic,assign)id<bookMarkDelegate>delegate;



@end
