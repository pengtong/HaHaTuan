//
//  HTListPriceLabel.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/5.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTListPriceLabel.h"

@implementation HTListPriceLabel


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //Drawing code
    UIRectFill(CGRectMake(rect.origin.x, rect.size.height * 0.5, rect.size.width, 1));
}


@end
