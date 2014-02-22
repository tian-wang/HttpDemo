//
//  HttpRequest.h
//  XMLDemo
//
//  Created by apple on 14-2-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestDelegate.h"
@interface HttpRequest : NSObject<NSURLConnectionDataDelegate>

{
    //系统http请求类对象
    NSURLConnection *httpConnection;
    
}
@property(nonatomic,assign) id<HttpRequestDelegate> delegate;
@property(nonatomic,retain) NSMutableData *downloadData;

//从制定的网址请求
-(void)downloadFromUrl:(NSString *)url;
@end
