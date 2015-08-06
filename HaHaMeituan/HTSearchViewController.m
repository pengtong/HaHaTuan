//
//  HTSearchViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/6.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTSearchViewController.h"
#import "UIView+AutoLayout.h"
#import "MJRefresh.h"

@interface HTSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation HTSearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"icon_back" highIcon:@"icon_back_highlighted" target:self action:@selector(close)];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.height = 35;
    titleView.width = 400;
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    [searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    searchBar.backgroundImage = [UIImage imageWithName:@"bg_login_textfield"];
    searchBar.placeholder = @"请输入关键字";
    self.searchBar = searchBar;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCityName:(NSString *)cityName
{
    _cityName = [cityName copy];
}

- (void)setParams:(NSMutableDictionary *)params
{
    params[@"city"] = self.cityName;
    params[@"keyword"] = self.searchBar.text;
}

#pragma mark --UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.collectionView.header beginRefreshing];
    
    [searchBar resignFirstResponder];
}

@end
