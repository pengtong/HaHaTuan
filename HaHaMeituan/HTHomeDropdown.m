//
//  HTHomeDropdown.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTHomeDropdown.h"
#import "HTHomeDropdownmainCell.h"
#import "HTHomeDropdownsubCell.h"

@interface HTHomeDropdown ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (nonatomic, assign) NSInteger selectedRow;
@end

@implementation HTHomeDropdown

+ (instancetype)dropdpwn
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HTHomeDropdown" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    self.mainTableView.backgroundColor = HTColor(230, 230, 230);
    self.subTableView.backgroundColor = HTColor(230, 230, 230);
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView)
    {
        return [self.dataSource numberOfRowsInMianTable:self];
    }
    else
    {
        return [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedRow].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.mainTableView)
    {
        cell = [HTHomeDropdownmainCell cellWithTableView:tableView];
        cell.textLabel.text = [self.dataSource homeDropdown:self titleForRowInMainTable:indexPath.row];
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:iconForRowInMainTable:)])
        {
            cell.imageView.image = [UIImage imageWithName:[self.dataSource homeDropdown:self iconForRowInMainTable:indexPath.row]];
        }
        
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTable:)])
        {
            cell.imageView.highlightedImage = [UIImage imageWithName:[self.dataSource homeDropdown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:indexPath.row];
        if (subdata.count)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        cell = [HTHomeDropdownsubCell cellWithTableView:tableView];
        cell.textLabel.text = [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedRow][indexPath.row];
    }
    
    return cell;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView)
    {
        self.selectedRow = indexPath.row;
        
        [self.subTableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectInMainTable:)])
        {
            [self.delegate homeDropdown:self didSelectInMainTable:indexPath.row];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectInSubTable:mainTable:)])
        {
            [self.delegate homeDropdown:self didSelectInSubTable:indexPath.row mainTable:self.selectedRow];
        }
    }
}
@end
