//
//  HTCommon.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#ifndef HaHaMeituan_HTCommon_h
#define HaHaMeituan_HTCommon_h

#import <Foundation/Foundation.h>
#import "UIView+MJ.h"
#import "NString+Extend.h"
#import "UIImage+HHImage.h"
#import "UIBarButtonItem+HT.h"
#import "NSDate+HH.h"
#import "HTNavigationViewController.h"

#define HTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0  alpha:1]

#ifdef DEBUG
#define HTLog(...) NSLog(__VA_ARGS__)
#else
#define HTLog(...) nil
#endif

extern NSString *const HTCityDidChangeNotification;
extern NSString *const HTSelectCityName;

extern NSString *const HTSortDidChangeNotification;
extern NSString *const HTSelectSort;

extern NSString *const HTCategoryDidChangeNotification;
extern NSString *const HTSelectCategory;
extern NSString *const HTSelectSubCategories;

extern NSString *const HTRegionDidChangeNotification;
extern NSString *const HTSelectRegion;
extern NSString *const HTSelectSubRegions;

#endif
