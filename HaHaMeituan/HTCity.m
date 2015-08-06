//
//  HTCity.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTCity.h"
#import "HTRegion.h"
#import "MJExtension.h"

@implementation HTCity

+ (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [HTRegion class]};
}

@end
