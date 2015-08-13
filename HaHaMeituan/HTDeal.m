//
//  HTDeal.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/5.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTDeal.h"
#import "MJExtension.h"
#import "HTBusinesses.h"

@implementation HTDeal

MJCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [HTBusinesses class]};
}

- (BOOL)isEqual:(HTDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}

@end
