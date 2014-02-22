//
//  WTYRootViewController.m
//  XMLDemo
//
//  Created by apple on 14-2-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "WTYRootViewController.h"

#import "GDataXMLNode.h"
#import "UserItem.h"
#import "QFDatabase.h"

@interface WTYRootViewController ()

@end

@implementation WTYRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //通过方法NSLocalizedStringFromTable 加载相应语言文件中的内容
    //Data为要加载的文件名,Title 为要从这个文件读取的内容的key
    self.title = NSLocalizedStringFromTable(@"Title", @"Data", @"description");

    _dataArray = [[NSMutableArray alloc] init];

    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 20;
    _userTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _userTableView.dataSource = self;
    _userTableView.delegate = self;
    
    [self.view addSubview:_userTableView];
    
    
    httpRequest = [[HttpRequest alloc] init];
    httpRequest.delegate = self;
    
    
    curPage = 1;
    pageCount = 9999;
    perPageCount = 20;
    [self loadData:curPage count:perPageCount];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    //滚动视图滚动到最底部
    if (scrollView.contentOffset.y+scrollView.frame.size.height>=scrollView.contentSize.height) {
        //加载新数据
        if (pageCount > curPage) {
            //将页码加一
            curPage+=1;
            [self loadData:curPage count:perPageCount];
        }
    }
}

-(void)loadData:(NSInteger)page count:(NSInteger)count {
    //nsin
    NSInteger totalCount = [[QFDatabase sharedDatabase] count];
    //数据库存中存在当前页数据
    if ((page - 1)*perPageCount < totalCount) {
        NSArray *array = [[QFDatabase sharedDatabase] readData:(page - 1) * perPageCount count:count];
        isLoading = NO;

        [_dataArray addObjectsFromArray:array];
        [_userTableView reloadData];
        NSLog(@"本地加载第%d页",page);
    }else {
        NSLog(@"从远程加载第%d页",page);
        
        NSString *url = [NSString stringWithFormat:@"http://192.168.88.8/sns/my/user_list.php?format=xml&page=%d&number=%d",page,count];
        [httpRequest downloadFromUrl:url];
    }
}
//获得指定节点的指定名称的子节点的文本信息（节点）

-(NSString *)elementContent:(GDataXMLElement *)element name:(NSString *)aname {
   NSArray *arr = [element elementsForName:aname];
    GDataXMLElement *subElement = [arr lastObject];
    return [subElement stringValue];
}
-(void)requestFinished:(HttpRequest *)request {
//    NSLog(@"%@",[[NSString alloc] initWithData:request.downloadData encoding:NSUTF8StringEncoding]);

    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:request.downloadData options:0 error:nil] autorelease];
    if (doc) {
        //
        NSString *totalStr = [self elementContent:doc.rootElement name:@"totalcount"];
        NSInteger totalCount = [totalStr integerValue];
        pageCount = totalCount%perPageCount == 0?totalCount/perPageCount:totalCount/perPageCount + 1;
        if (pageCount == 0) {
            pageCount = 8888;
        }
        
        NSArray *userArray = [doc nodesForXPath:@"//user" error:nil];
        
        //对获得的节点数组遍历
        NSMutableArray *tempArray = [NSMutableArray array];
        for (GDataXMLElement *element in userArray) {
 
            UserItem *item = [[[UserItem alloc] init] autorelease];
            item.uid = [self elementContent:element name:@"uid"];
            item.name = [self elementContent:element name:@"name"];
            
            [tempArray addObject:item];
        }
        [_dataArray addObjectsFromArray:tempArray];
        isLoading = NO;
        [[QFDatabase sharedDatabase] insertArray:tempArray];
    }

    [_userTableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_dataArray count]) {
        static NSString *moreCellName = @"moreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellName];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:moreCellName] autorelease];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            label.text = @"加载更多";
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.tag = 100;
            [cell.contentView addSubview:label];
            [label release];
        }
        
        return cell;
        
    }
    
    
    static NSString *usercellName = @"userCell";

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:usercellName];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:usercellName] autorelease];
    }
    UserItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.uid;
    cell.detailTextLabel.text = item.name;

    
    return cell;
}








@end
