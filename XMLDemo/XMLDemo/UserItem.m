//
//  UserItem.m
//  XMLDemo
//
//  Created by apple on 14-2-9.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem
- (void)dealloc
{
    self.uid = nil;
    self.name = nil;
    [super dealloc];
}
@end
