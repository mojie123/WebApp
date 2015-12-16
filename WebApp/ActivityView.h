//
//  ActivityView.h
//  WebApp
//
//  Created by Ibokan on 15/11/3.
//  Copyright (c) 2015年 eoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView
{
    UIActivityIndicatorView * _activityV;
    UILabel * _textLabel;
}

//显示文本和小菊花.
-(void)showWithText:(NSString *)showText;


-(void)hidden;

@end
