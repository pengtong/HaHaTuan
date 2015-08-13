//
//  HTMetaData.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCategory.h"
#import "HTDeal.h"

@interface HTMetaData : NSObject

+ (NSArray *)cities;

+ (NSArray *)categorys;

+ (NSArray *)sorts;


+ (HTCategory *)categoryWithDeal:(HTDeal *)deal;
@end
