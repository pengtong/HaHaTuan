//
//  HTCollectViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/7.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTCollectViewController.h"
#import "HTDealDataCace.h"
#import "MJRefresh.h"
#import "HTHomeDealCell.h"

@interface HTCollectViewController ()

@end


@implementation HTCollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"我的收藏";
    
    self.category = HTCollect;
    self.noDataImageName = @"icon_collects_empty";
    [self.dealDataArray addObjectsFromArray:[HTDealDataCace collectDeals:self.currentPage]];
}

@end
