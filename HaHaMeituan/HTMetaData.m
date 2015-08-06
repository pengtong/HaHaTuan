//
//  HTMetaData.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTMetaData.h"
#import "MJExtension.h"
#import "HTCity.h"
#import "HTCategory.h"
#import "HTSort.h"

@implementation HTMetaData


static NSArray *_cities;
+ (NSArray *)cities
{
    if (!_cities)
    {
        _cities = [HTCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

static NSArray *_categorys;
+ (NSArray *)categorys
{
    if (!_categorys)
    {
        _categorys = [HTCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categorys;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (!_sorts)
    {
        _sorts = [HTSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

@end
