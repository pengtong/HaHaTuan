//
//  HTDistrictViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTDistrictViewController.h"
#import "HTHomeDropdown.h"
#import "HTCityViewController.h"
#import "HTRegion.h"

@interface HTDistrictViewController ()<HTHomeDropdownDataSource, HTHomeDropdownDelegate>
- (IBAction)changeCity;

@end

@implementation HTDistrictViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIView *titleView = [self.view.subviews firstObject];
    HTHomeDropdown *dropdown = [HTHomeDropdown dropdpwn];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    [self.view addSubview:dropdown];
    dropdown.y = titleView.height;
    
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
}


- (IBAction)changeCity
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    HTNavigationViewController *nav = [[HTNavigationViewController alloc] initWithRootViewController:[[HTCityViewController alloc]init]];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark --HTHomeDropdownDataSource

- (NSInteger)numberOfRowsInMianTable:(HTHomeDropdown *)homeDropdown
{
    return self.regions.count;
}

- (NSString *)homeDropdown:(HTHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    HTRegion *region = self.regions[row];
    
    return region.name;
}

- (NSArray *)homeDropdown:(HTHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    HTRegion *region = self.regions[row];
    
    return region.subregions;
}

#pragma mark --HTHomeDropdownDelegate

- (void)homeDropdown:(HTHomeDropdown *)homeDropdown didSelectInMainTable:(NSInteger)row
{
    HTRegion *region = self.regions[row];
    
    if (region.subregions.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:HTRegionDidChangeNotification object:nil userInfo:@{HTSelectRegion : region}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)homeDropdown:(HTHomeDropdown *)homeDropdown didSelectInSubTable:(NSInteger)subRow mainTable:(NSInteger)mainRow
{
    HTRegion *region = self.regions[mainRow];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HTRegionDidChangeNotification object:nil userInfo:@{HTSelectRegion : region, HTSelectSubRegions : region.subregions[subRow]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
