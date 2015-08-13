//
//  HTNewsreelViewController.m
//  HaHaMeituan
//
//  Created by Pengtong on 15/8/9.
//  Copyright (c) 2015年 Pengtong. All rights reserved.
//

#import "HTNewsreelViewController.h"
#import "HTDeal.h"
#import "MJExtension.h"
#import "HTHomeDealCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "HTDetailController.h"
#import "HTDealDataCace.h"

@interface HTNewsreelViewController () <HTHomeDealCellDelegate>

@property (nonatomic, weak) UIImageView *noDealDataView;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *removeItem;
@end

NSString *const HTDone = @"完成";
NSString *const HTEdit = @"编辑";
#define HTString(str) [NSString stringWithFormat:@"  %@  ", str]


@implementation HTNewsreelViewController

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
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HTHomeDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.currentPage = 1;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:HTEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectStateChange:) name:HTCollectStateDidChangeNotification object:nil];
}

- (void)collectStateChange:(NSNotification *)notification
{
    [self.dealDataArray removeAllObjects];
    self.currentPage = 1;
    [self.dealDataArray addObjectsFromArray:[HTDealDataCace collectDeals:self.currentPage]];
    [self loadMoreDeals];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        noDealDataView.image = [UIImage imageWithName:self.noDataImageName];
        [_noDealDataView autoCenterInSuperview];
    }
    return _noDealDataView;
}

- (UIBarButtonItem *)backItem
{
    if (!_backItem)
    {
        self.backItem = [UIBarButtonItem itemWithIcon:@"icon_back" highIcon:@"icon_back_highlighted" target:self action:@selector(close)];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:HTString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:HTString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)removeItem
{
    if (!_removeItem) {
        self.removeItem = [[UIBarButtonItem alloc] initWithTitle:HTString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
        self.removeItem.enabled = NO;
    }
    return _removeItem;
}

- (void)loadMoreDeals
{
    if ([self.category isEqualToString:HTCollect])
    {
        [self.dealDataArray addObjectsFromArray:[HTDealDataCace collectDeals:++self.currentPage]];
    }
    else if ([self.category isEqualToString:HTScan])
    {
        [self.dealDataArray addObjectsFromArray:[HTDealDataCace scanDeals:++self.currentPage]];
    }
    
    [self.collectionView reloadData];
    
    [self.collectionView.footer endRefreshing];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAll
{
    for (HTDeal *deal in self.dealDataArray)
    {
        deal.checking = YES;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = YES;
}

- (void)unselectAll
{
    for (HTDeal *deal in self.dealDataArray)
    {
        deal.checking = NO;
    }
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}

- (void)remove
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (HTDeal *deal in self.dealDataArray)
    {
        if (deal.isChecking)
        {
            if ([self.category isEqualToString:HTCollect])
            {
                [HTDealDataCace removeCollectWithHTDeal:deal];
            }
            else if ([self.category isEqualToString:HTScan])
            {
                [HTDealDataCace removeScantWithHTDeal:deal];
            }
            
            
            [tempArray addObject:deal];
        }
    }
    
    [self.dealDataArray removeObjectsInArray:tempArray];
    
    [self.collectionView reloadData];
    
    self.removeItem.enabled = NO;
}

- (void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:HTEdit])
    {
        item.title = HTDone;
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.removeItem];
        
        for (HTDeal *deal in self.dealDataArray)
        {
            deal.editing = YES;
        }
    }
    else
    {
        item.title = HTEdit;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        for (HTDeal *deal in self.dealDataArray)
        {
            deal.editing = NO;
        }
    }
    
    [self.collectionView reloadData];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    int cols = (size.width == 1024) ? 3 : 2;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    CGFloat topMargin = (cols == 3) ? inset : inset / 2;
    
    layout.sectionInset = UIEdgeInsetsMake(topMargin, inset, topMargin, inset);
    
    layout.minimumLineSpacing = inset;
}

#pragma mark -- HTHomeDealCellDelegate
- (void)dealCellCheckingStateDidChange:(HTHomeDealCell *)dealCell
{
    BOOL hasChecking = NO;
    for (HTDeal *deal in self.dealDataArray)
    {
        if (deal.isChecking)
        {
            hasChecking = YES;
            break;
        }
    }
    
    self.removeItem.enabled = hasChecking;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    if ([self.category isEqualToString:HTCollect])
    {
        self.collectionView.footer.hidden = (self.dealDataArray.count == [HTDealDataCace collectDealCount]);
    }
    else if ([self.category isEqualToString:HTScan])
    {
        self.collectionView.footer.hidden = (self.dealDataArray.count == [HTDealDataCace scanDealCount]);
    }
    
    self.noDealDataView.hidden = (self.dealDataArray.count!=0);
    self.navigationItem.rightBarButtonItem.enabled = (self.dealDataArray.count!=0);
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dealDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTHomeDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.dealDataArray[indexPath.row];
    
    cell.delegate = self;
    
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
