//
//  HTDealDataCace.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/9.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTDeal.h"

@interface HTDealDataCace : NSObject

+ (NSArray *)collectDeals:(NSInteger)page;

+ (NSArray *)scanDeals:(NSInteger)page;

+ (NSInteger)collectDealCount;

+ (NSInteger)scanDealCount;

+ (void)saveCollectWithHTDeal:(HTDeal *)deal;

+ (void)removeCollectWithHTDeal:(HTDeal *)deal;

+ (void)saveScanWithHTDeal:(HTDeal *)deal;

+ (void)removeScantWithHTDeal:(HTDeal *)deal;

+ (BOOL)isCollect:(HTDeal *)deal;
@end
