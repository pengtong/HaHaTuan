//
//  HTHomeDropdown.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/2.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTHomeDropdown;

@protocol HTHomeDropdownDataSource <NSObject>

- (NSInteger)numberOfRowsInMianTable:(HTHomeDropdown *)homeDropdown;

- (NSString *)homeDropdown:(HTHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row;

- (NSArray *)homeDropdown:(HTHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row;

@optional
- (NSString *)homeDropdown:(HTHomeDropdown *)homeDropdown iconForRowInMainTable:(NSInteger)row;

- (NSString *)homeDropdown:(HTHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row;

@end

@protocol HTHomeDropdownDelegate <NSObject>
@optional
- (void)homeDropdown:(HTHomeDropdown *)homeDropdown didSelectInMainTable:(NSInteger)row;

- (void)homeDropdown:(HTHomeDropdown *)homeDropdown didSelectInSubTable:(NSInteger)subRow mainTable:(NSInteger)mainRow;
@end

@interface HTHomeDropdown : UIView


+ (instancetype)dropdpwn;

@property (nonatomic, weak) id<HTHomeDropdownDataSource> dataSource;

@property (nonatomic, weak) id<HTHomeDropdownDelegate> delegate;
@end
