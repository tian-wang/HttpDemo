//
//  HttpRequest.m
//  XMLDemo
//
//  Created by apple on 14-2-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest
- (id)init
{
    self = [super init];
    if (self) {
        self.downloadData = [NSMutableData data];
    }
    return self;
}
-(void)downloadFromUrl:(NSString *)url {
    //如果url有中文等特殊字符需要编码
    
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *newUrl = [NSURL URLWithString:url];
    

    NSLog(@"%@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:newUrl];
    httpConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //检查回应数据的状态吗
//    清楚就数据
    [self.downloadData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([self.delegate respondsToSelector:@selector(requestFinished:)]) {
        
        [self.delegate  requestFinished:self];
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"加载失败:   %@",error);
    if ([self.delegate  respondsToSelector:@selector(requestFail:)]) {
        [self.delegate  requestFail:self];
    }
}

@end
