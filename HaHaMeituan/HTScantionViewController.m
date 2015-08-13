//
//  HTScantionViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/7.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTScantionViewController.h"
#import "HTDealDataCace.h"
#import "MJRefresh.h"
#import "HTHomeDealCell.h"

@interface HTScantionViewController ()

@end

@implementation HTScantionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"浏览记录";
    
    self.category = HTScan;
    self.noDataImageName = @"icon_latestBrowse_empty";
    [self.dealDataArray addObjectsFromArray:[HTDealDataCace scanDeals:self.currentPage]];
}

@end
