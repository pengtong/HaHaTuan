//
//  HTDealAnnotation.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/11.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
// 成都市

#import "HTDealAnnotation.h"

@implementation HTDealAnnotation

- (BOOL)isEqual:(HTDealAnnotation *)other
{
    
    return [self.title isEqual:other.title];
}

@end
