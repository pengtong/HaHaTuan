//
//  HTCityViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTCityViewController.h"
#import "MJExtension.h"
#import "HTCityGroup.h"
#import "HTCitySearchResultController.h"
#import "UIView+AutoLayout.h"

@interface HTCityViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *cover;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *cityGroup;
@property (nonatomic, weak) HTCitySearchResultController *citySearchResult;
@end

@implementation HTCityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"btn_navigation_close" highIcon:@"btn_navigation_close_hl" target:self action:@selector(close)];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.searchBar.tintColor = HTColor(32, 191, 179);
    self.cityGroup = [HTCityGroup objectArrayWithFilename:@"cityGroups.plist"];
}

- (HTCitySearchResultController *)citySearchResult
{
    if (!_citySearchResult)
    {
        HTCitySearchResultController *citySearchResult = [[HTCitySearchResultController alloc] init];
        self.citySearchResult = citySearchResult;
        [self.view addSubview:self.citySearchResult.view];
        [self.citySearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:10];
        [self addChildViewController:citySearchResult];
    }
    return _citySearchResult;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)coverClick
{
    [self.searchBar resignFirstResponder];
}

#pragma mark --UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [searchBar setBackgroundImage:[UIImage imageWithName:@"bg_login_textfield_hl"]];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0.5;
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [searchBar setBackgroundImage:[UIImage imageWithName:@"bg_login_textfield"]];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length)
    {
        self.citySearchResult.view.hidden = NO;
        self.citySearchResult.searchText = searchText;
    }
    else
    {
        self.citySearchResult.view.hidden = YES;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark --UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cityGroup[section] cities].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    HTCityGroup *cityGroup = self.cityGroup[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTCityGroup *cityGroup = self.cityGroup[indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:HTCityDidChangeNotification object:nil userInfo:@{HTSelectCityName : cityGroup.cities[indexPath.row]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    HTCityGroup *cityGroup = self.cityGroup[section];
    return cityGroup.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroup valueForKeyPath:@"title"];
}
@end
