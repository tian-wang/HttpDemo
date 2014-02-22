//
//  QFDatabase.h
//  XMLDemo
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "UserItem.h"
@interface QFDatabase : NSObject
{
    FMDatabase *_database;
}
+(QFDatabase *)sharedDatabase;
//获得指定文件的全路径
+(NSString *)filePath:(NSString *)fileName;
-(void)insertItem:(UserItem *)item;
-(void)insertArray:(NSArray *)array;
-(NSInteger)count;
-(NSArray *)readData:(NSInteger)startIndex count:(NSInteger)count ;
@end
