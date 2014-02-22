//
//  QFDatabase.m
//  XMLDemo
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "QFDatabase.h"

@implementation QFDatabase
+(QFDatabase *)sharedDatabase {
    static QFDatabase *gl_Database;
    if (!gl_Database) {
        gl_Database = [[QFDatabase alloc] init];
    }
    return gl_Database;
}
//获得指定文件的全路径
+(NSString *)filePath:(NSString *)fileName {
    NSString *homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents"];
    if (fileName && [fileName length] != 0) {
        homePath = [homePath stringByAppendingPathComponent:fileName];
    }
    return homePath;
}
-(void)createTable {
    NSArray *array = [NSArray arrayWithObjects:@"CREATE TABLE IF NOT EXISTS user (serial integer  NOT NULL  PRIMARY KEY AUTOINCREMENT DEFAULT 0,username Varchar(1024),headimage Varchar(1024) DEFAULT NULL,uid Varchar(64) DEFAULT NULL)", nil];
    for (NSString *sql in array) {
        if (![_database executeUpdate:sql]) {
            NSLog(@"创建表格失败:%@",[_database lastErrorMessage]);

        }
    }
}
//获得数据库中记录条数
-(NSInteger)count {
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM user" ];
    FMResultSet *rs = [_database executeQuery:sql];
    while ([rs next]) {
        NSInteger count = [rs intForColumnIndex:0];
        return count;
    }
    return 0;
}
- (void)dealloc
{
    [_database close];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        //
        _database = [[FMDatabase alloc] initWithPath:[QFDatabase filePath:@"user.db"]];
        //打开数据库
        if ([_database open]) {
            //创建表
            [self createTable];
        }
    }
    return self;
}
-(NSArray *)readData:(NSInteger)startIndex count:(NSInteger)count {
    NSString *sql = [NSString stringWithFormat:@"SELECT username,headimage FROM      user LIMIT %d,%d",startIndex,count];
    FMResultSet *rs = [_database executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        UserItem *item = [[UserItem alloc] init];
        item.name = [rs stringForColumn:@"username"];
        item.headimage = [rs stringForColumn:@"headimage"];
        [array addObject:item];
    }
    return array;
}
-(BOOL)isExistsItem:(UserItem *)item {
    NSString *sql = [NSString stringWithFormat:@"SELECT uid FROM user WHERE uid = ?"];
    //执行查询结果
    FMResultSet *rs = [_database executeQuery:sql,item.uid];
    while ([rs next]) {
        return YES;
    }
    return NO;
}
-(void)insertItem:(UserItem *)item {
    if ([self isExistsItem:item]) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO user(username,headimage) VALUES (?,?)"];
    //每一个?号是一个参数值,必须是对象类型
    //?号个娄要和字段个数对应
    if (![_database executeUpdate:sql,item.name,item.headimage]) {
        NSLog(@"插入失败:%@",[_database lastErrorMessage]);
    }
}
-(void)insertArray:(NSArray *)array {
    //准备批量操作
    [_database beginTransaction];
    //准备插入的语句
    for (UserItem *item  in array) {
        [self insertItem:item];
    }
    //提交
    [_database commit];
}
@end
