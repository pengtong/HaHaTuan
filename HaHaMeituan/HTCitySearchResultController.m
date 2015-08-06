//
//  HTCitySearchResultController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTCitySearchResultController.h"
#import "MJExtension.h"
#import "HTCity.h"
#import "HTMetaData.h"

@interface HTCitySearchResultController ()
@property (nonatomic, strong) NSArray *cityResult;
@end

@implementation HTCitySearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    searchText = searchText.lowercaseString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
    self.cityResult = [[HTMetaData cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cityResult";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [self.cityResult[indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTCity *city = self.cityResult[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HTCityDidChangeNotification object:nil userInfo:@{HTSelectCityName : city.name}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%ld条结果", self.cityResult.count];
}

@end
