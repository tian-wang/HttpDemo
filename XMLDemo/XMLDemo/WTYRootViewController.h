//
//  WTYRootViewController.h
//  XMLDemo
//
//  Created by apple on 14-2-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"
@interface WTYRootViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,HttpRequestDelegate>
{
    NSMutableArray *_dataArray;
    
    UITableView *_userTableView;
    HttpRequest *httpRequest;
    //当前页码
    NSInteger curPage;
    //总页码
    NSInteger pageCount;
    //每页条数
    NSInteger perPageCount;
    //
    BOOL isLoading;
}

@end
