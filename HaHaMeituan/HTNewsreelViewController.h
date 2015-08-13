//
//  HTNewsreelViewController.h
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/9.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTNewsreelViewController : UICollectionViewController

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *dealDataArray;

@property (nonatomic, copy) NSString *noDataImageName;

@property (nonatomic, copy) NSString *category;
@end
