//
//  HTDealDataCace.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/9.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTDealDataCace.h"
#import "FMDB.h"

@implementation HTDealDataCace

static FMDatabaseQueue *_queue;

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathExtension:@"deal.sqlite"];
    _queue = [[FMDatabaseQueue alloc] initWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_collect (id integer primary key autoincrement, deal_id text not null, deal blob not null);"];
        [db executeUpdate:@"create table if not exists t_scan (id integer primary key autoincrement, deal_id text not null, deal blob not null);"];
    }];
    
}

+ (NSArray *)collectDeals:(NSInteger)page
{
    __block NSMutableArray *dealArray = [NSMutableArray array];
    NSInteger size = 40;
    NSInteger pos = (page - 1) * size;
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQueryWithFormat:@"select * from t_collect order BY id desc limit %ld,%ld;", pos, size];

        while ([rs next])
        {
            HTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"deal"]];
            [dealArray addObject:deal];
        }
        [rs close];
    }];
    
    return dealArray;
}

+ (void)saveCollectWithHTDeal:(HTDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"insert into t_collect(deal_id, deal)values (?, ?)", deal.deal_id, data];
    }];
}

+ (void)removeCollectWithHTDeal:(HTDeal *)deal
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_collect where deal_id=?", deal.deal_id];
    }];
}

+ (BOOL)isCollect:(HTDeal *)deal
{
    __block FMResultSet *rs = nil;
    [_queue inDatabase:^(FMDatabase *db) {
         rs = [db executeQuery:@"select deal_id from t_collect where deal_id=?", deal.deal_id];
    }];
    
    if ([rs next])
    {
        if ([[rs stringForColumn:@"deal_id"] isEqualToString:deal.deal_id])
        {
            [rs close];
            return YES;
        }
    }
    
    return NO;
}

+ (NSInteger)collectDealCount
{
    __block FMResultSet *rs = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        rs = [db executeQueryWithFormat:@"select count(*) AS deal_count from t_collect;"];
    }];
    
    [rs next];

    return [rs intForColumn:@"deal_count"];
}

+ (NSArray *)scanDeals:(NSInteger)page
{
    __block NSMutableArray *dealArray = [NSMutableArray array];
    NSInteger size = 40;
    NSInteger pos = (page - 1) * size;
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQueryWithFormat:@"select * from t_scan order BY id desc limit %ld,%ld;", pos, size];
        
        while ([rs next])
        {
            HTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"deal"]];
            [dealArray addObject:deal];
        }
        [rs close];
    }];
    
    return dealArray;
}

+ (void)saveScanWithHTDeal:(HTDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"insert into t_scan(deal_id, deal)values (?, ?)", deal.deal_id, data];
    }];
}

+ (void)removeScantWithHTDeal:(HTDeal *)deal
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_scan where deal_id=?", deal.deal_id];
    }];
}

+ (NSInteger)scanDealCount
{
    __block FMResultSet *rs = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        rs = [db executeQueryWithFormat:@"select count(*) AS deal_count from t_scan;"];
    }];
    
    [rs next];
    
    return [rs intForColumn:@"deal_count"];
}

@end
