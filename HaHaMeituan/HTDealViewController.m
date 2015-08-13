//
//  HTDealViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/6.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTDealViewController.h"
#import "DPAPI.h"
#import "HTDeal.h"
#import "MJExtension.h"
#import "HTHomeDealCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "HTDetailController.h"

@interface HTDealViewController () <DPRequestDelegate>
@property (nonatomic, strong) NSMutableArray *dealDataArray;

@property (nonatomic, assign) CGFloat currentPage;

@property (nonatomic, assign) CGFloat totalCount;

@property (nonatomic, weak) UIImageView *noDealDataView;
/** 最后一个请求 */
@property (nonatomic, weak) DPRequest *lastRequest;
@end

@implementation HTDealViewController

static NSString * const reuseIdentifier = @"dealcell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [HTHomeDealCell cellSize];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = HTColor(230, 230, 230);
    self.collectionView.showsVerticalScrollIndicator = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HTHomeDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDealData)];
}

- (NSMutableArray *)dealDataArray
{
    if (!_dealDataArray)
    {
        _dealDataArray = [NSMutableArray array];
    }
    
    return _dealDataArray;
}

- (UIImageView *)noDealDataView
{
    if (!_noDealDataView)
    {
        UIImageView *noDealDataView = [[UIImageView alloc] init];
        [self.view addSubview:noDealDataView];
        _noDealDataView = noDealDataView;
        noDealDataView.image = [UIImage imageWithName:@"icon_deals_empty"];
        [_noDealDataView autoCenterInSuperview];
    }
    return _noDealDataView;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    int cols = (size.width == 1024) ? 3 : 2;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    CGFloat topMargin = (cols == 3) ? inset : inset /2;
    
    layout.sectionInset = UIEdgeInsetsMake(topMargin, inset, topMargin, inset);
    
    layout.minimumLineSpacing = inset;
}

- (void)loadMoreDeals
{
    self.currentPage++;
    
    [self loadDeals];
}

- (void)loadNewDealData
{
    self.currentPage = 1;
    
    [self loadDeals];
}

- (void)loadDeals
{
    DPAPI *dp = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self setParams:params];
    params[@"page"] = @(self.currentPage);
    HTLog(@"%@", params);
    
    self.lastRequest = [dp requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

#pragma mark --DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (self.lastRequest != request) return;
    
//    HTLog(@"%@", result);
    NSArray *dealArray = [HTDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.currentPage == 1)
    {
        [self.dealDataArray removeAllObjects];
    }
    
    [self.dealDataArray addObjectsFromArray:dealArray];
    [self.collectionView reloadData];
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
    self.totalCount = [result[@"total_count"] integerValue];
    self.noDealDataView.hidden = (self.dealDataArray.count!=0);
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
//    HTLog(@"%@", error);
    [MBProgressHUD showError:@"网络繁忙，请稍后再试!" toView:self.view];
    
    if (self.currentPage > 1)
    {
        self.currentPage--;
    }
    
    [self.collectionView.header endRefreshing];
    [self.collectionView.footer endRefreshing];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    self.collectionView.footer.hidden = (self.dealDataArray.count == self.totalCount);
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dealDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTHomeDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.dealDataArray[indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HTDetailController *detailVC = [[HTDetailController alloc] init];
    detailVC.deal = self.dealDataArray[indexPath.row];
    [self presentViewController:detailVC animated:YES completion:nil];
}

@end
