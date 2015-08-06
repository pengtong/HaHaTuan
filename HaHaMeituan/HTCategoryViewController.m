//
//  HTCategoryViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTCategoryViewController.h"
#import "HTHomeDropdown.h"
#import "MJExtension.h"
#import "HTMetaData.h"
#import "HTCategory.h"

@interface HTCategoryViewController ()<HTHomeDropdownDataSource, HTHomeDropdownDelegate>

@end

@implementation HTCategoryViewController

- (void)loadView
{
    HTHomeDropdown *dropdown = [HTHomeDropdown dropdpwn];
//    dropdown.regions = [HTCategory objectArrayWithFilename:@"categories.plist"];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    self.view = dropdown;
    self.preferredContentSize = dropdown.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark --HTHomeDropdownDataSource

- (NSInteger)numberOfRowsInMianTable:(HTHomeDropdown *)homeDropdown
{
    return [HTMetaData categorys].count;
}

- (NSString *)homeDropdown:(HTHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    HTCategory *category = [HTMetaData categorys][row];
    
    return category.name;
}

- (NSArray *)homeDropdown:(HTHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    HTCategory *category = [HTMetaData categorys][row];
    return category.subcategories;
}

- (NSString *)homeDropdown:(HTHomeDropdown *)homeDropdown iconForRowInMainTable:(NSInteger)row
{
    HTCategory *category = [HTMetaData categorys][row];
    
    return category.small_icon;
}

- (NSString *)homeDropdown:(HTHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row
{
    HTCategory *category = [HTMetaData categorys][row];
    
    return category.small_highlighted_icon;
}

#pragma mark --HTHomeDropdownDelegate

- (void)homeDropdown:(HTHomeDropdown *)homeDropdown didSelectInMainTable:(NSInteger)row
{
    HTCategory *category = [HTMetaData categorys][row];
    
    if (category.subcategories.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:HTCategoryDidChangeNotification object:nil userInfo:@{HTSelectCategory : category}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)homeDropdown:(HTHomeDropdown *)homeDropdown didSelectInSubTable:(NSInteger)subRow mainTable:(NSInteger)mainRow
{
    HTCategory *category = [HTMetaData categorys][mainRow];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HTCategoryDidChangeNotification object:nil userInfo:@{HTSelectCategory : category, HTSelectSubCategories : category.subcategories[subRow]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
