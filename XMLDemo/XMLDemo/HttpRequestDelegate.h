//
//  HttpRequestDelegate.h
//  XMLDemo
//
//  Created by apple on 14-2-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HttpRequest;
@protocol HttpRequestDelegate <NSObject>


-(void)requestFinished:(HttpRequest *)request;
@optional
//下载失败
-(void)requestFail:(HttpRequest *)request;
@end
